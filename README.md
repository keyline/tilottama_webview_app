# Tilottomaa Hair & Skin

A production-oriented Flutter application that displays the Tilottomaa Hair &
Skin client portal in a native mobile WebView.

## Client portal

The application loads:

<https://tilottamaahairandskin.com/clients/>

## Features

- Native WebView on Android and iOS
- JavaScript-enabled client portal
- In-app HTTP and HTTPS navigation
- External handling for phone, email, and application links
- Android back-button support for WebView history
- Loading progress indicator
- Connection-error screen with retry
- Hidden horizontal and vertical scroll indicators
- Light appearance enforced on Flutter, Android, and iOS
- HTTPS-only Android network policy
- Mandatory, non-dismissible application updates

## Requirements

- Flutter SDK with Dart `3.12.1` or newer
- Android SDK and Java 17
- Android 7.0/API 24 or newer
- Xcode with an iOS 13.0 or newer deployment target

## Getting started

Install the dependencies:

```shell
flutter pub get
```

Run the application on a connected device or emulator:

```shell
flutter run
```

Run static analysis:

```shell
flutter analyze
```

## Project structure

```text
lib/
|-- main.dart                                  Application entry point
|-- app/
|   `-- app.dart                               Material app and theme
|-- core/
|   `-- app_constants.dart                     Portal URL and branding
`-- features/
    |-- update/
    |   `-- mandatory_update_gate.dart         Store update enforcement
    `-- webview/
        |-- client_portal_screen.dart          WebView and navigation logic
        `-- widgets/
            |-- portal_error_view.dart         Connection-error UI
            `-- portal_progress_bar.dart       Page-loading indicator
```

## Mandatory updates

The application uses the `upgrader` package to compare its installed version
with the public Google Play or Apple App Store version. When a newer version is
available:

- Only the **Update now** action is shown.
- The dialog cannot be dismissed by tapping outside it.
- The device back button cannot close the dialog.
- The update check runs again when the application resumes.

Store checks begin working after the application has a public store listing.
Google Play internal and closed testing listings may not be detectable because
they are not publicly accessible.

For explicit minimum-version enforcement, add the appropriate marker to the
store description and update its version for every mandatory release:

```text
Google Play: [Minimum supported app version: 0.1.0]
Apple App Store: [:mav: 0.1.0]
```

The marker version must use the application version without its build number.
For example, for `version: 1.2.0+15`, use `1.2.0`.

## Application identity

The configured Android application ID and iOS bundle ID are:

```text
com.tilottomaa.hairandskin
```

Confirm this identifier before the first store release. Store application
identifiers cannot normally be changed after publishing.

## Versioning

Update the `version` field in `pubspec.yaml` before every release:

```yaml
version: 1.0.0+1
```

- `1.0.0` is the user-visible version.
- `1` is the Android version code and iOS build number.
- Both values must increase as required by the respective store.

## Release builds

Build an Android App Bundle for Google Play:

```shell
flutter build appbundle --release
```

Build the iOS release application on macOS:

```shell
flutter build ipa --release
```

### Android signing

The current Android release configuration uses the debug signing key so local
release builds can run. Do not publish that build. Before publishing, create an
upload keystore and replace the debug signing configuration in
`android/app/build.gradle.kts` with a private release signing configuration.
Never commit the keystore or its passwords.

### iOS signing

Open `ios/Runner.xcworkspace` in Xcode, select the correct Apple Developer team,
and confirm that the bundle ID and signing certificates match the App Store
Connect application.

## Important files

- Portal URL and branding: `lib/core/app_constants.dart`
- Mandatory-update settings: `lib/features/update/mandatory_update_gate.dart`
- Android permissions and security: `android/app/src/main/AndroidManifest.xml`
- Android package and SDK settings: `android/app/build.gradle.kts`
- iOS application settings: `ios/Runner/Info.plist`
