# 00 — Environment Setup

> Time: ~30 min | Prerequisites: Dart Tour complete

---

## Install Flutter

```bash
# macOS (recommended: use fvm for version management)
brew install fvm
fvm install stable
fvm global stable

# Add to your shell profile:
export PATH="$PATH:$HOME/fvm/default/bin"

# Verify
flutter doctor
dart --version   # should be ≥ 3.4
```

For Windows/Linux: https://docs.flutter.dev/get-started/install

---

## IDE Setup

**VS Code (recommended)**
- Install extension: `Flutter` (includes Dart)
- Install extension: `Dart Data Class Generator`
- Install extension: `Better Comments`

```json
// .vscode/settings.json (add to your project)
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk",
  "editor.formatOnSave": true,
  "[dart]": {
    "editor.defaultFormatter": "Dart-Code.dart-code"
  }
}
```

**Android Studio / IntelliJ**
- Plugin: Flutter + Dart (bundled)
- Enable: Editor → Code Style → Dart → Format on save

---

## Enable All Platforms

```bash
# Desktop
flutter config --enable-macos-desktop
flutter config --enable-windows-desktop
flutter config --enable-linux-desktop

# Web
flutter config --enable-web

# Confirm
flutter devices
```

---

## Your First Flutter Run

```bash
# Create a new project (outside this repo — just for quick testing)
flutter create hello_flutter
cd hello_flutter

flutter run -d chrome          # web
flutter run -d macos           # desktop (macOS)
flutter run                    # mobile (pick from device list)
```

Hot reload: press `r` in the terminal, or save in VS Code (with format on save).
Hot restart: press `R`.

---

## Useful Flutter CLI Commands

| Command | What it does |
|---------|-------------|
| `flutter pub get` | Install dependencies |
| `flutter pub upgrade` | Upgrade all deps |
| `flutter pub add <pkg>` | Add a new dependency |
| `flutter analyze` | Static analysis |
| `flutter test` | Run all tests |
| `flutter build apk` | Build Android APK |
| `flutter build web` | Build web bundle |
| `flutter build macos` | Build macOS app |

---

## Project Structure (what each folder does)

```
my_app/
├── lib/                ← Your Dart source code
│   └── main.dart       ← Entry point
├── test/               ← Unit and widget tests
├── integration_test/   ← E2E tests
├── android/            ← Android-specific config (rarely touch)
├── ios/                ← iOS-specific config (Xcode)
├── web/                ← Web entry point + manifest
├── macos/              ← macOS entry point
├── windows/            ← Windows entry point
├── linux/              ← Linux entry point
├── pubspec.yaml        ← Dependencies (= package.json / go.mod)
└── pubspec.lock        ← Lock file (commit this!)
```

> 💡 **Backend Lens:** `pubspec.yaml` is your `go.mod` or `package.json`. `pub.dev` is npm / pkg.go.dev. Lock files work the same way.

---

## pubspec.yaml Basics

```yaml
name: secure_vault
description: Cross-platform secrets manager
version: 1.0.0+1        # semver+buildNumber

environment:
  sdk: '>=3.4.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.0.0
  riverpod: ^2.5.0
  # add more here

dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.0

flutter:
  uses-material-design: true
```

---

Next: [01 — Flutter Fundamentals](./01_fundamentals/README.md)
