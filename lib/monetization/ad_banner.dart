import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../theme/tokens.dart';
import 'ad_ids.dart';
import 'monetization.dart';

/// Adaptive banner pinned above the tab bar. Takes no space until an ad has
/// loaded, and disappears once ads are removed.
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _ad;
  bool _loaded = false;
  int? _width;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final show = MonetizationScope.of(context).showAds;
    final width = MediaQuery.sizeOf(context).width.truncate();
    if (!show || width != _width) _disposeAd();
    // _width is set while loading too, so a rebuild doesn't load twice.
    if (show && _width == null) _load(width);
  }

  Future<void> _load(int width) async {
    _width = width;
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (!mounted || size == null || _ad != null || width != _width) return;
    _ad = BannerAd(
      adUnitId: AdIds.banner,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (mounted) setState(_resetAd);
        },
      ),
    )..load();
  }

  void _resetAd() {
    _ad = null;
    _loaded = false;
  }

  void _disposeAd() {
    _ad?.dispose();
    _resetAd();
    _width = null;
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (ad == null || !_loaded) return const SizedBox.shrink();
    return ColoredBox(
      color: context.colors.card,
      child: SizedBox(
        width: double.infinity,
        height: ad.size.height.toDouble(),
        child: Center(
          child: SizedBox(
            width: ad.size.width.toDouble(),
            height: ad.size.height.toDouble(),
            child: AdWidget(ad: ad),
          ),
        ),
      ),
    );
  }
}
