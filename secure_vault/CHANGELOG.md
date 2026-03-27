# SecureVault — Changelog

This file tracks what gets added to the project after each course module.

---

## [0.1.0] — Module 01: Fundamentals

**Added:**
- `MaterialApp` with Material 3 theme (light + dark)
- `AppTheme` with seed color and consistent card/input styling
- `LoginScreen` — static master password form, biometric placeholder
- `VaultListScreen` — `ListView` with search bar, empty state
- `VaultItemCard` — adaptive card widget with category icon and favorite toggle
- `VaultItemDetailScreen` — field display with copy-to-clipboard and reveal
- `VaultItemFormScreen` — full CRUD form with validation
- `GeneratorScreen` — cryptographically random password generator
- `SettingsScreen` — placeholder settings with future TODOs
- `AppShell` — adaptive nav (BottomNavigationBar on mobile, NavigationRail on desktop)
- `VaultItem` domain model (hand-written, will be Freezed in Module 04)
- `InMemoryVaultRepository` — fake in-memory store for development

---

## [0.2.0] — Module 02: State Management _(upcoming)_

**Will add:**
- Riverpod `ProviderScope` at root
- `VaultNotifier` (Riverpod Notifier) replacing setState in screens
- `vaultItemsProvider` stream
- `filteredVaultItemsProvider` with search
- `AsyncValue` handling (loading / error / data) in `VaultListScreen`
- Code generation with `build_runner`

---

## [0.3.0] — Module 03: Navigation _(upcoming)_

**Will add:**
- `GoRouter` replacing placeholder navigation
- Route constants in `AppRoutes`
- Auth redirect guard (`redirect` callback)
- Deep link support
- Type-safe routes with `go_router_builder`

---

## [0.4.0] — Module 04: Data & Storage _(upcoming)_

**Will add:**
- `Drift` SQLite database (`AppDatabase`, `VaultItems` table)
- `LocalVaultRepository` replacing `InMemoryVaultRepository`
- `VaultItem` replaced with Freezed + json_serializable model
- `Dio` HTTP client with interceptors (no real API yet)
- Repository pattern wired through Riverpod

---

## [0.5.0] — Module 05: Security _(upcoming)_

**Will add:**
- AES-256-GCM encryption via `VaultCrypto`
- PBKDF2 key derivation
- `MasterKeyService` — key in memory only
- `flutter_secure_storage` for salt and future token storage
- `BiometricAuth` with `local_auth`
- Auto-lock on `AppLifecycleState.paused`
- Certificate pinning in Dio
- 30-second clipboard auto-clear via `ClipboardService`
- `--obfuscate` flag in build scripts
- `kDebugMode` guards for dev bypasses

---

## [0.6.0] — Module 06: Cross-Platform _(upcoming)_

**Will add:**
- Master-detail layout on tablet/desktop (≥ 700px)
- `window_manager` sizing and centering on desktop
- macOS menu bar with Lock Vault shortcut
- `Cmd/Ctrl+N` / `Cmd/Ctrl+F` keyboard shortcuts
- `usePathUrlStrategy()` for clean web URLs
- Hover states on list items (web/desktop)

---

## [0.7.0] — Module 07: Testing _(upcoming)_

**Will add:**
- Unit tests: `VaultCrypto`, `deriveKey`, `VaultNotifier`
- Widget tests: `VaultItemCard`, `LoginScreen`, `VaultListScreen`
- Golden tests for key screens
- Integration test: add/view/delete flow
- Coverage ≥ 80%

---

## [0.8.0] — Module 08: CI/CD _(upcoming)_

**Will add:**
- `.github/workflows/ci.yml` — analyze + test + build all platforms
- Signed Android APK/AAB
- iOS IPA
- Web deployed to Firebase Hosting
- macOS build artifact
- Flavor system in CI
