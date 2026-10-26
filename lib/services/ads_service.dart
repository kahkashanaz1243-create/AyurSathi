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

  static BannerAd createBanner({VoidCallback? onLoaded}) {
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
  // If an ad is not available, continue to the feature normally.
  static void showInterstitialIfDue({
    required VoidCallback onContinue,
  }) {
    final now = DateTime.now();
    final last = _lastInterstitialTime;

    if (_hasShownInterstitial &&
        last != null &&
        now.difference(last) < adInterval) {
      onContinue();
      return;
    }

    final ad = _interstitialAd;

    if (ad != null) {
      _interstitialAd = null;
      _showLoadedInterstitial(ad, onContinue);
      return;
    }

    if (_isLoading) {
      // An ad request is already in progress. Do not block navigation.
      onContinue();
      return;
    }

    _isLoading = true;

    InterstitialAd.load(
      adUnitId: interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (loadedAd) {
          _isLoading = false;
          _showLoadedInterstitial(loadedAd, onContinue);
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          debugPrint('Interstitial ad failed: $error');
          onContinue();
        },
      ),
    );
  }

  static void _showLoadedInterstitial(
    InterstitialAd ad,
    VoidCallback onContinue,
  ) {
    _lastInterstitialTime = DateTime.now();
    _hasShownInterstitial = true;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitial();
        onContinue();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Interstitial display failed: $error');
        ad.dispose();
        loadInterstitial();
        onContinue();
      },
    );

    ad.show();
  }
}
