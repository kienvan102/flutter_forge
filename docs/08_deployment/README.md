# 08 — Deployment & CI/CD

> Time: ~3–4 days | Goal: Automated builds for all 6 platforms on every push

---

## Flavors (Environments)

Like backend staging/prod separation. Flutter calls these "flavors".

```
dev     → local development, debug logging, self-signed certs OK
staging → close to prod, test server, real cert pinning
prod    → Play Store / App Store / deployed web
```

### Setup Flavors

```dart
// lib/core/config/env.dart
enum Flavor { dev, staging, prod }

class AppConfig {
  static late Flavor flavor;
  static late String apiBaseUrl;
  static late bool enableLogging;
  static late bool enableCertPinning;

  static void init(Flavor f) {
    flavor = f;
    switch (f) {
      case Flavor.dev:
        apiBaseUrl = 'https://api-dev.securevault.com';
        enableLogging = true;
        enableCertPinning = false;  // easier local dev
      case Flavor.staging:
        apiBaseUrl = 'https://api-staging.securevault.com';
        enableLogging = true;
        enableCertPinning = true;
      case Flavor.prod:
        apiBaseUrl = 'https://api.securevault.com';
        enableLogging = false;
        enableCertPinning = true;
    }
  }
}
```

```dart
// lib/main_dev.dart
void main() {
  AppConfig.init(Flavor.dev);
  runApp(const ProviderScope(child: SecureVaultApp()));
}

// lib/main_prod.dart
void main() {
  AppConfig.init(Flavor.prod);
  runApp(const ProviderScope(child: SecureVaultApp()));
}
```

---

## GitHub Actions CI/CD

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  # ── Analyze & Test ──────────────────────────────────────────
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.x'
          cache: true

      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v4

  # ── Android ─────────────────────────────────────────────────
  build-android:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: '3.22.x', cache: true }

      - name: Decode keystore
        run: |
          echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 -d > android/app/keystore.jks

      - name: Build release APK + AAB
        run: |
          flutter build apk --release --flavor prod \
            --dart-define=FLAVOR=prod \
            --obfuscate --split-debug-info=./debug-symbols \
            -t lib/main_prod.dart
          flutter build appbundle --release --flavor prod \
            -t lib/main_prod.dart
        env:
          KEYSTORE_PASSWORD: ${{ secrets.KEYSTORE_PASSWORD }}
          KEY_ALIAS: ${{ secrets.KEY_ALIAS }}
          KEY_PASSWORD: ${{ secrets.KEY_PASSWORD }}

      - uses: actions/upload-artifact@v4
        with:
          name: android-release
          path: |
            build/app/outputs/flutter-apk/app-prod-release.apk
            build/app/outputs/bundle/prodRelease/app-prod-release.aab

  # ── iOS ─────────────────────────────────────────────────────
  build-ios:
    runs-on: macos-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: '3.22.x', cache: true }

      - name: Install Apple certs & provisioning profile
        uses: apple-actions/import-codesign-certs@v2
        with:
          p12-file-base64: ${{ secrets.IOS_P12_BASE64 }}
          p12-password: ${{ secrets.IOS_P12_PASSWORD }}

      - run: flutter build ipa --release -t lib/main_prod.dart --obfuscate --split-debug-info=./debug-symbols

      - uses: actions/upload-artifact@v4
        with:
          name: ios-release
          path: build/ios/ipa/

  # ── Web ─────────────────────────────────────────────────────
  build-web:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: '3.22.x', cache: true }

      - run: flutter build web --release --wasm -t lib/main_prod.dart

      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: ${{ secrets.GITHUB_TOKEN }}
          firebaseServiceAccount: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
          channelId: live
          projectId: secure-vault-prod

  # ── macOS ────────────────────────────────────────────────────
  build-macos:
    runs-on: macos-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: '3.22.x', cache: true }

      - run: flutter config --enable-macos-desktop
      - run: flutter build macos --release -t lib/main_prod.dart

      - uses: actions/upload-artifact@v4
        with:
          name: macos-release
          path: build/macos/Build/Products/Release/
```

---

## Android Signing (local setup)

```bash
# Generate a keystore (once, keep it SAFE)
keytool -genkey -v \
  -keystore secure_vault.jks \
  -alias secure_vault \
  -keyalg RSA -keysize 2048 \
  -validity 10000

# android/key.properties (gitignored!)
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=secure_vault
storeFile=../secure_vault.jks
```

```groovy
// android/app/build.gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

---

## Deployment Targets

| Platform | Service | Notes |
|----------|---------|-------|
| Android | Google Play Console | Upload AAB, not APK |
| iOS | App Store Connect | Requires Apple Developer ($99/yr) |
| Web | Firebase Hosting / Netlify / Vercel | Free tier sufficient |
| macOS | Mac App Store OR notarized DMG | Notarization = Apple scans binary |
| Windows | Microsoft Store OR standalone installer | `flutter build windows` |
| Linux | Snapcraft / Flathub OR tarball | `flutter build linux` |

---

## .gitignore Additions for Flutter

```gitignore
# Build outputs
build/
*.apk
*.ipa
*.aab

# Sensitive files
android/key.properties
android/app/keystore.jks
ios/Runner/GoogleService-Info.plist
google-services.json
.env
debug-symbols/

# Flutter/Dart
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
pubspec.lock    # Commit this for apps, gitignore for packages
```

---

## SecureVault — Final Milestone 🎉

- GitHub Actions running on every push: analyze → test → build all platforms
- Signed Android APK + AAB artifacts
- iOS IPA artifact
- Web deployed to Firebase Hosting
- macOS build artifact
- `Flavor` system: dev / staging / prod
- All secrets in GitHub Secrets, zero hardcoded values

**You now have a production-ready, security-first Flutter app shipping to 6 platforms.** 🚀
