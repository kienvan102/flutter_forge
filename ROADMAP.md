# 🗺️ Flutter Forge — Learning Roadmap

> Estimated total time: **8–12 weeks** at ~8–10 hrs/week (backend engineers move faster on logic-heavy parts, slower on layout/UI)

---

## Phase 0 — Dart Tour (Week 1)
**Goal:** Dart feels as natural as your primary language.

- [ ] Types, variables, null safety
- [ ] Functions, closures, arrow syntax
- [ ] Classes, mixins, extensions, interfaces
- [ ] Collections: List, Map, Set, Iterable
- [ ] Async/await, Future, then/catch
- [ ] Streams (similar to RxJava / Go channels)
- [ ] Generics
- [ ] Dart isolates (like goroutines / threads)

🏁 **Checkpoint:** Complete all `dart_tour/` exercises without peeking at solutions.

---

## Phase 1 — Flutter Fundamentals (Week 1–2)
**Goal:** Understand Flutter's rendering model and widget tree.

- [ ] Widget tree mental model
- [ ] StatelessWidget vs StatefulWidget
- [ ] Basic layouts: Column, Row, Stack, Flex
- [ ] Common widgets: Text, Container, Image, Icon, Button
- [ ] Hot reload vs hot restart
- [ ] BuildContext and widget lifecycle
- [ ] Theme and styling

🏁 **SecureVault milestone:** App shell with placeholder screens and bottom nav.

---

## Phase 2 — State Management (Week 2–3)
**Goal:** Manage app state properly with Riverpod.

- [ ] Why setState doesn't scale
- [ ] Provider pattern (conceptual)
- [ ] Riverpod: StateProvider, NotifierProvider, FutureProvider
- [ ] AsyncValue and loading/error states
- [ ] Code generation with riverpod_generator
- [ ] Separation of UI and business logic

> 💡 **Backend Lens:** Riverpod providers ≈ dependency injection containers (Spring beans, Go wire, etc.)

🏁 **SecureVault milestone:** Vault items list with reactive state and a fake in-memory data layer.

---

## Phase 3 — Navigation & Routing (Week 3)
**Goal:** Multi-screen navigation that works everywhere.

- [ ] Navigator 2.0 vs GoRouter
- [ ] GoRouter: routes, params, query strings
- [ ] Nested navigation (shell routes)
- [ ] Redirect guards (auth check)
- [ ] Deep linking (web URLs, mobile app links)
- [ ] Platform-specific navigation patterns

> 💡 **Backend Lens:** GoRouter ≈ Express/Gin routing with middleware guards.

🏁 **SecureVault milestone:** Login screen → Vault list → Item detail with proper route guards.

---

## Phase 4 — Data & Storage (Week 4–5)
**Goal:** Persist data and call APIs like a backend engineer.

- [ ] Drift (SQLite ORM): models, DAOs, queries
- [ ] Isar vs Hive vs Drift trade-offs
- [ ] Dio: HTTP client, interceptors, retry
- [ ] REST API integration pattern
- [ ] json_serializable + Freezed for immutable models
- [ ] Repository pattern (keep UI clean)

> 💡 **Backend Lens:** Drift DAOs ≈ GORM/Hibernate repositories. Dio interceptors ≈ HTTP middleware.

🏁 **SecureVault milestone:** Vault items persisted to local SQLite, full CRUD working.

---

## Phase 5 — Security 🔐 (Week 5–6)
**Goal:** Build apps that handle sensitive data correctly.

- [ ] OWASP Mobile Top 10 — what each means in Flutter
- [ ] `flutter_secure_storage`: OS keychain/keystore integration
- [ ] AES-256 encryption with the `encrypt` package
- [ ] Key derivation (PBKDF2 / Argon2)
- [ ] Biometric authentication with `local_auth`
- [ ] PIN / passcode fallback
- [ ] Certificate pinning with Dio
- [ ] Obfuscation and code shrinking
- [ ] No secrets in code: `--dart-define` and `.env` patterns
- [ ] Jailbreak / root detection considerations
- [ ] Secure clipboard handling
- [ ] Auto-lock on background

🏁 **SecureVault milestone:** All vault data AES-encrypted at rest, biometric + PIN login, auto-lock on backgrounding, certificate pinning on all API calls.

---

## Phase 6 — Cross-Platform (Week 7)
**Goal:** One codebase, beautiful on all six platforms.

- [ ] Responsive layout with `LayoutBuilder` and `MediaQuery`
- [ ] Adaptive widgets (`AdaptiveScaffold`)
- [ ] Platform detection (`kIsWeb`, `Platform.isIOS`, etc.)
- [ ] Desktop-specific UX: keyboard shortcuts, window sizing, menu bar
- [ ] Web-specific: PWA manifest, SEO, URL routing
- [ ] Platform channels (native code when Flutter can't)
- [ ] `flutter_adaptive_scaffold` from Material 3

🏁 **SecureVault milestone:** Identical feature set working beautifully on mobile, web, and desktop with proper responsive layouts.

---

## Phase 7 — Testing (Week 8)
**Goal:** Test with the confidence of a backend engineer.

- [ ] Unit tests for business logic and repositories
- [ ] Widget tests with `WidgetTester`
- [ ] Mocking with `mocktail`
- [ ] Golden tests (screenshot regression)
- [ ] Integration tests with `flutter_test` driver
- [ ] Test coverage configuration

> 💡 **Backend Lens:** Widget tests ≈ integration tests against a UI component. Golden tests ≈ snapshot testing.

🏁 **SecureVault milestone:** >80% test coverage, golden tests for core screens.

---

## Phase 8 — Deployment (Week 9–10)
**Goal:** Ship to all platforms with CI/CD.

- [ ] GitHub Actions workflow for Flutter
- [ ] Android: keystore signing, Play Store
- [ ] iOS: certificates, provisioning, App Store
- [ ] Web: Firebase Hosting / Netlify deploy
- [ ] macOS/Windows/Linux: packaging and notarization
- [ ] Flavors: dev / staging / prod environments
- [ ] Crashlytics + analytics integration

🏁 **SecureVault milestone:** Automated builds for all 6 platforms on every push to `main`.

---

## Optional Deep Dives

- **Animations:** `AnimationController`, `Hero`, `Lottie`
- **Isolates & concurrency:** Background processing, `compute()`
- **WebSockets & SSE:** Real-time data in Flutter
- **Custom painters:** `CustomPainter` for charts / drawings
- **Firebase:** Auth, Firestore, Storage (if you want a backend-as-a-service)
- **Flavors & white-labeling:** Multi-tenant apps

---

*Check off items as you go. Momentum beats perfection.* ✅
