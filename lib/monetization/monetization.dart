import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ad_ids.dart';

/// Ads, the consent they need, and the one-time "Remove ads" purchase.
///
/// Ads only ever appear on the tab screens and after a mock test, never while
/// someone is studying a lesson or answering questions.
class Monetization extends ChangeNotifier {
  Monetization(SharedPreferences prefs)
      : _prefs = prefs,
        enabled = !kIsWeb && (Platform.isAndroid || Platform.isIOS) && AdIds.configured {
    _adsRemoved = prefs.getBool(_removedKey) ?? false;
  }

  /// No ads and nothing to buy (tests, desktop, unconfigured release builds).
  Monetization.disabled()
      : _prefs = null,
        enabled = false;

  final SharedPreferences? _prefs;
  final bool enabled;

  bool _adsRemoved = false;
  bool _adsStarted = false;
  bool _privacyOptionsRequired = false;
  ProductDetails? _product;
  bool _purchasePending = false;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;

  InterstitialAd? _interstitial;
  bool _interstitialLoading = false;
  DateTime? _lastInterstitial;

  /// Shortest time between two full-screen ads.
  static const interstitialGap = Duration(minutes: 3);
  static const _removedKey = 'ads_removed';

  bool get showAds => enabled && _adsStarted && !_adsRemoved;
  bool get adsRemoved => _adsRemoved;

  /// Localized store price, or null until the store answers.
  String? get removeAdsPrice => _product?.price;
  bool get purchasePending => _purchasePending;

  /// Users in the EU and UK must be able to change their consent later.
  bool get privacyOptionsRequired => _privacyOptionsRequired;

  void init() {
    if (!enabled) return;
    unawaited(_initPurchases());
    _gatherConsent();
  }

  // Consent ------------------------------------------------------------------

  void _gatherConsent() {
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        await ConsentForm.loadAndShowConsentFormIfRequired((_) {});
        _privacyOptionsRequired = await ConsentInformation.instance.getPrivacyOptionsRequirementStatus() ==
            PrivacyOptionsRequirementStatus.required;
        notifyListeners();
        await _startAds();
      },
      (_) => _startAds(),
    );
    // Consent given in an earlier session lets ads start without waiting.
    _startAds();
  }

  Future<void> _startAds() async {
    if (_adsStarted || !await ConsentInformation.instance.canRequestAds()) return;
    if (_adsStarted) return;
    _adsStarted = true;
    await MobileAds.instance.initialize();
    notifyListeners();
    _loadInterstitial();
  }

  void showPrivacyOptions() => ConsentForm.showPrivacyOptionsForm((_) {});

  // Interstitial -------------------------------------------------------------

  void _loadInterstitial() {
    if (!showAds || _interstitial != null || _interstitialLoading) return;
    _interstitialLoading = true;
    InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialLoading = false;
          _interstitial = ad;
        },
        onAdFailedToLoad: (_) => _interstitialLoading = false,
      ),
    );
  }

  /// Shows a full-screen ad at a natural break, at most once every
  /// [interstitialGap]. Does nothing if no ad is ready.
  void showInterstitial() {
    final ad = _interstitial;
    if (!showAds) return;
    if (ad == null) {
      _loadInterstitial();
      return;
    }
    final last = _lastInterstitial;
    if (last != null && DateTime.now().difference(last) < interstitialGap) return;

    _interstitial = null;
    _lastInterstitial = DateTime.now();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _loadInterstitial();
      },
    );
    ad.show();
  }

  // Remove ads ---------------------------------------------------------------

  Future<void> _initPurchases() async {
    final iap = InAppPurchase.instance;
    _purchaseSub = iap.purchaseStream.listen(_onPurchases, onError: (_) {});
    if (!await iap.isAvailable()) return;
    final response = await iap.queryProductDetails({AdIds.removeAdsProduct});
    _product = response.productDetails.firstOrNull;
    notifyListeners();
    // Play restores silently, which covers reinstalls and new phones. On iOS a
    // restore can ask for the Apple ID password, so it waits for the button.
    if (Platform.isAndroid) await iap.restorePurchases();
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      if (p.productID == AdIds.removeAdsProduct) {
        switch (p.status) {
          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            _purchasePending = false;
            _removeAds();
          case PurchaseStatus.pending:
            _purchasePending = true;
          case PurchaseStatus.error:
          case PurchaseStatus.canceled:
            _purchasePending = false;
        }
      }
      if (p.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(p);
    }
    notifyListeners();
  }

  void _removeAds() {
    _adsRemoved = true;
    _prefs?.setBool(_removedKey, true);
    _interstitial?.dispose();
    _interstitial = null;
  }

  Future<void> buyRemoveAds() async {
    final product = _product;
    if (product == null || _purchasePending) return;
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: product));
  }

  Future<void> restorePurchases() => InAppPurchase.instance.restorePurchases();

  @override
  void dispose() {
    _purchaseSub?.cancel();
    _interstitial?.dispose();
    super.dispose();
  }
}

/// Makes [Monetization] available to the widget tree.
class MonetizationScope extends InheritedNotifier<Monetization> {
  const MonetizationScope({super.key, required Monetization monetization, required super.child})
      : super(notifier: monetization);

  static Monetization of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MonetizationScope>()!.notifier!;

  /// Read without subscribing to rebuilds (for callbacks).
  static Monetization read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<MonetizationScope>()!.notifier!;
}
