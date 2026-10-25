# Android platform setup

This ZIP contains the Flutter/Dart source and does not include generated Android Gradle wrapper/platform files. Generate those using the Flutter SDK on your computer/Termux:

```bash
cd ayur_sathi
flutter create --platforms=android --project-name ayur_sathi .
flutter pub get
```

If Flutter asks whether to overwrite `lib/main.dart` or `pubspec.yaml`, choose **No / keep existing**. If your Flutter version regenerates these files, restore the source files from this ZIP afterward.

## AndroidManifest.xml
Open `android/app/src/main/AndroidManifest.xml`. Add these entries inside the existing `<manifest>` element (but outside `<application>`):

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

Inside the existing `<application>` element add the AdMob **test app ID** while testing:

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-3940256099942544~3347511713" />
```

Do not add a second `<application>` or `<manifest>` element. Replace the test app ID with your own AdMob app ID before production release. The banner unit ID is configured in `lib/services/ads_service.dart`.
