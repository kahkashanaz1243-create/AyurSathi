# AyurSathi

Offline-first bilingual (Hindi + English) wellness app built with Flutter.

## Included features
1. Ayurvedic Daily Routine checklist
2. Yoga Mudra Guide
3. Herbal Plant Guide
4. Healthy Recipe Book
5. Herbal Tea Recipe Book
6. Unani Terms Guide
7. Prakriti Questionnaire (educational self-reflection only)
8. Wellness Journal (local SQLite)
9. Eye Break timer/reminder
10. Health Report PDF Maker

Also includes local notification scheduling and Google Mobile Ads test banner integration.

## Requirements
- Flutter stable (Dart 3.4+)
- Android Studio / Android SDK or a compatible Flutter Android build environment
- Internet for first `flutter pub get` and ads. The core content and journal work offline.

## Setup
```bash
flutter doctor
flutter create . --platforms=android
flutter pub get
flutter analyze
flutter test
flutter run
```

If `flutter create .` asks to overwrite existing files, do not overwrite `lib/` or `pubspec.yaml`; the project already includes these. Run it only to generate missing platform scaffolding. If `android/` already exists, skip that command.

## Android permissions / setup
- The notification plugin may require Android notification permission on Android 13+; the app requests it where supported.
- Google Mobile Ads uses Google's official **test banner ID** in `lib/services/ads_service.dart`. Replace it with your own AdMob app/ad unit IDs only after creating an AdMob account and reviewing Google's policies.
- Ads need internet; app content and local journal do not.
- Android release builds need a valid upload keystore and signing configuration before Play Console submission.

## Build
```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build apk --release
flutter build appbundle --release
```
Outputs:
- `build/app/outputs/flutter-apk/app-release.apk`
- `build/app/outputs/bundle/release/app-release.aab`

For Play Store, configure release signing in `android/key.properties` and `android/app/build.gradle` (or `.kts`) using Flutter's current Android signing instructions. Never commit a keystore or passwords to GitHub.

## Offline and privacy
- Journal records are stored in the app's local SQLite database.
- There is no account, login, server, or admin panel.
- Deleting app data or uninstalling may delete journal records. Export/back up important records before uninstalling.
- Ads may collect device/ad identifiers according to Google's SDK and your consent/legal obligations. Before publishing, add a privacy policy, complete Play Console Data safety and ads declarations, and implement consent flow if required for your audience/region.

## Health disclaimer
Content is general educational information, not diagnosis or treatment. The Prakriti questionnaire is a traditional self-reflection tool, not a clinical assessment. Consult a qualified clinician for health concerns. Herbs can interact with medicines and may not be suitable during pregnancy or for some medical conditions.
