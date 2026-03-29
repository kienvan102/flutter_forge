# 🦋 Flutter Forge

> A self-paced Flutter course designed for **backend engineers** who already know how to code — built to skip the boring parts and get you shipping real cross-platform apps (web · mobile · desktop) fast.

---

## 🧠 Who This Is For

- You're a mid–senior backend engineer
- You understand OOP, async, HTTP, databases, and basic security concepts
- You want to build frontends **by yourself**, without relying on a frontend team
- You learn best by **doing tiny things first**, letting them compound

---

## 🗺️ Course Structure

```
flutter-forge/
├── dart_tour/          ← Interactive Dart playground (like Go Tour)
├── docs/               ← Module guides, concept explanations, tips
│   ├── 00_setup.md
│   ├── 01_fundamentals/
│   ├── 02_state_management/
│   ├── 03_navigation/
│   ├── 04_data_storage/
│   ├── 05_security/        ← 🔐 Deep security coverage
│   ├── 06_cross_platform/
│   ├── 07_testing/
│   └── 08_deployment/
└── secure_vault/       ← Evolving project (updated after every module)
```

---

## 🎯 The Evolving Project: SecureVault

Throughout the course you build **SecureVault** — a cross-platform secrets & credentials manager (think: a minimal, self-hosted Bitwarden clone).

Why this project?
- You already understand what it should *do* (credentials, auth, encryption)
- It naturally demands **security best practices** from day one
- It grows in complexity in parallel with your Flutter knowledge
- It runs on **iOS, Android, Web, macOS, Windows, Linux** — all platforms

| Module Completed | What SecureVault gains |
|---|---|
| 01 Fundamentals | App shell, navigation skeleton |
| 02 State Management | Vault items list with reactive state |
| 03 Navigation | Multi-screen routing (GoRouter) |
| 04 Data & Storage | Local encrypted SQLite database |
| 05 Security | AES encryption, biometric lock, secure storage |
| 06 Cross-Platform | Responsive layout for all platforms |
| 07 Testing | Full unit + widget + integration test suite |
| 08 Deployment | CI/CD pipeline, signed builds for all platforms |

---

## 🚀 Quick Start

### Prerequisites

```bash
# Install Flutter SDK
# https://docs.flutter.dev/get-started/install

flutter --version   # ≥ 3.22
dart --version      # ≥ 3.4
```

### Start with the Dart Tour

```bash
cd dart_tour
dart run --enable-asserts 01_basics/main.dart
```

### Run SecureVault

```bash
cd secure_vault
flutter pub get
flutter run -d chrome         # Web
flutter run -d macos          # Desktop
flutter run                   # Mobile (needs simulator/device)
```

---

## 📚 Learning Path

**Recommended order:**

1. `dart_tour/` → Get comfortable with Dart fast
2. `docs/00_setup.md` → Flutter environment
3. `docs/01_fundamentals/` → Widgets, layouts, hot reload
4. Build `secure_vault` step by step alongside each docs module
5. `docs/05_security/` → Do NOT skip this — security-first mindset

**Backend engineer shortcuts:** Each module has a `> 💡 Backend Lens` callout mapping Flutter concepts to backend equivalents you already know.

---

## 🔐 Security Philosophy

This course treats security as a **first-class citizen**, not an afterthought:

- OWASP Mobile Top 10 applied throughout
- Secure storage instead of SharedPreferences for sensitive data
- Certificate pinning for API calls
- Biometric + PIN authentication
- AES-256 encryption at rest
- No secrets in source code (environment-based config)

---

## 📂 Module Index

| # | Module | Key Concepts |
|---|--------|-------------|
| — | [Dart Tour](./dart_tour/README.md) | Dart syntax, null safety, async, streams |
| 00 | [Setup](./docs/00_setup.md) | Flutter install, IDE, first run |
| 01 | [Fundamentals](./docs/01_fundamentals/) | Widgets, StatelessWidget, StatefulWidget, layouts |
| 02 | [State Management](./docs/02_state_management/) | Riverpod, providers, reactive UI |
| 03 | [Navigation](./docs/03_navigation/) | GoRouter, deep links, guards |
| 04 | [Data & Storage](./docs/04_data_storage/) | Drift (SQLite), Dio (HTTP), json_serializable |
| 05 | [Security](./docs/05_security/) | 🔐 Encryption, biometric, secure storage, OWASP |
| 06 | [Cross-Platform](./docs/06_cross_platform/) | Responsive UI, adaptive widgets, platform channels |
| 07 | [Testing](./docs/07_testing/) | Unit, widget, integration tests |
| 08 | [Deployment](./docs/08_deployment/) | GitHub Actions, signing, store submission |

---

*Built for engineers who ship.* 🚢
