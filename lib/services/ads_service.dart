import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  // Google's official test banner ID. Replace only with your own AdMob unit ID
  // after setting up your app and reviewing consent/privacy requirements.
  static const String bannerId = 'ca-app-pub-3940256099942544/6300978111';

  static BannerAd createBanner({VoidCallback? onLoaded}) {
    final ad = BannerAd(
      adUnitId: bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded?.call(),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
    ad.load();
    return ad;
  }
}
