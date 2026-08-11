# Tilottomaa Beauty Parlour

Production Flutter WebView wrapper for the Tilottomaa client portal.

## Mandatory updates

The app checks the public Google Play/App Store listing on launch and resume. When
a newer version is available, only **Update now** is offered and the prompt cannot
be dismissed. Store detection starts working after the first public release.

For a server-enforced minimum version, append the following marker to the store
description and update it with each mandatory release:

- Google Play: `[Minimum supported app version: 0.1.0]`
- App Store: `[:mav: 0.1.0]`

Before publishing, replace the Android release debug signing configuration with
your upload keystore and confirm `com.tilottomaa.hairandskin` is the final package
ID. Configure the same bundle ID in Xcode for iOS.
