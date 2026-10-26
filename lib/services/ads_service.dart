
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  // Real AdMob ad unit IDs for AyurSathi.
  static const String bannerId =
    
'ca-app-pub-3580956288241135/6226674529';


static const String interstitialId =
    'ca-app-pub-3580956288241135/8661266175';

  static DateTime? _lastInterstitialTime;
  static InterstitialAd? _interstitialAd;
  static bool _isLoading = false;
  static bool _hasShownInterstitial = false;

  static const Duration adInterval = Duration(seconds: 60);

  static BannerAd createBanner({
    VoidCallback? onLoaded,
  }) {
    final ad = BannerAd(
      adUnitId: bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded?.call(),
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed: $error');
          ad.dispose();
        },
      ),
    );

    ad.load();
    return ad;
  }

  static void loadInterstitial() {
    if (_isLoading || _interstitialAd != null) return;

    _isLoading = true;

    InterstitialAd.load(
      adUnitId: interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoading = false;
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          debugPrint('Interstitial ad failed: $error');
        },
      ),
    );
  }

  // Call at a natural transition, such as opening a feature.
  static void showInterstitialIfDue() {
    final now = DateTime.now();
    final last = _lastInterstitialTime;

    if (_hasShownInterstitial &&
        last != null &&
        now.difference(last) < adInterval) {
      return;
    }

    final ad = _interstitialAd;
    if (ad == null) {
      loadInterstitial();
      return;
    }

    _interstitialAd = null;
    _lastInterstitialTime = now;
    _hasShownInterstitial = true;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Interstitial display failed: $error');
        ad.dispose();
        loadInterstitial();
      },
    );

    ad.show();
  }
}
