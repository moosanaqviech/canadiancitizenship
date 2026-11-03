import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// AdMob and store identifiers.
///
/// Debug and profile builds always use Google's test ad units: tapping real
/// ads during development can get the AdMob account suspended. Release builds
/// use the real units below; empty them to switch ads off.
///
/// The AdMob *app* IDs live in android/app/build.gradle.kts and
/// ios/Runner/Info.plist.
abstract final class AdIds {
  static const _androidBanner = 'ca-app-pub-7523920922953083/8663829660';
  static const _androidInterstitial = 'ca-app-pub-7523920922953083/6005876734';
  static const _iosBanner = 'ca-app-pub-7523920922953083/6515239120';
  static const _iosInterstitial = 'ca-app-pub-7523920922953083/4164407955';

  /// Non-consumable product, created with this ID in Play Console and
  /// App Store Connect.
  static const removeAdsProduct = 'remove_ads';

  static String get banner => _pick(
        android: _androidBanner,
        ios: _iosBanner,
        androidTest: 'ca-app-pub-3940256099942544/9214589741',
        iosTest: 'ca-app-pub-3940256099942544/2435281174',
      );

  static String get interstitial => _pick(
        android: _androidInterstitial,
        ios: _iosInterstitial,
        androidTest: 'ca-app-pub-3940256099942544/1033173712',
        iosTest: 'ca-app-pub-3940256099942544/4411468910',
      );

  /// Whether this build has ad units to show at all.
  static bool get configured => banner.isNotEmpty && interstitial.isNotEmpty;

  static String _pick({
    required String android,
    required String ios,
    required String androidTest,
    required String iosTest,
  }) {
    if (Platform.isAndroid) return kReleaseMode ? android : androidTest;
    if (Platform.isIOS) return kReleaseMode ? ios : iosTest;
    return '';
  }
}
