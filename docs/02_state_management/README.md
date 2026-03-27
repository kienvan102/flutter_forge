# 02 — State Management with Riverpod

> Time: ~1 week | Goal: Reactive app state without prop-drilling

---

## Why Not `setState`?

`setState` is fine for **local widget state** (e.g., "is this dropdown open?"). It breaks down when:
- Multiple widgets need the same data
- Business logic leaks into `build()`
- You need async state (loading/error/data)
- You want testability

The evolution: `setState` → `InheritedWidget` → `Provider` → **Riverpod** (what we use).

> 💡 **Backend Lens:** Riverpod providers ≈ a type-safe dependency injection container. You declare what data exists and how to compute it; widgets consume it. Equivalent to Spring's `@Bean` + `@Autowired`, or Go's `wire` package.

---

## Riverpod Core Concepts

### Installation

```yaml
# pubspec.yaml
dependencies:
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0

dev_dependencies:
  riverpod_generator: ^2.3.0   # code gen
  build_runner: ^2.4.0
```

```bash
flutter pub get
```

### Wrap your app

```dart
void main() {
  runApp(
    const ProviderScope(   // ← wraps the whole app, like a DI container
      child: MyApp(),
    ),
  );
}
```

### ConsumerWidget — the Riverpod equivalent of StatelessWidget

```dart
// Instead of StatelessWidget, extend ConsumerWidget
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref is your gateway to providers
    final items = ref.watch(vaultItemsProvider);  // subscribes to changes
    return ListView(children: items.map((i) => Text(i.title)).toList());
  }
}
```

---

## Provider Types

### `@riverpod` — Simple value provider (sync)

```dart
// providers/theme_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'theme_provider.g.dart';  // generated

@riverpod
ThemeMode themeMode(ThemeModeRef ref) => ThemeMode.system;
```

### `@riverpod` — Async provider (FutureProvider)

```dart
@riverpod
Future<List<VaultItem>> vaultItems(VaultItemsRef ref) async {
  final repo = ref.watch(vaultRepositoryProvider);
  return repo.getAllItems();
}
```

Consuming async providers with `AsyncValue`:

```dart
final asyncItems = ref.watch(vaultItemsProvider);

// AsyncValue has three states — like a tagged union:
return switch (asyncItems) {
  AsyncData(:final value) => ItemList(items: value),
  AsyncLoading() => const CircularProgressIndicator(),
  AsyncError(:final error) => Text('Error: $error'),
};
```

### `@riverpod` class — Notifier (like useReducer or a slice)

```dart
// providers/vault_provider.dart
@riverpod
class VaultNotifier extends _$VaultNotifier {
  @override
  List<VaultItem> build() => [];   // initial state

  void addItem(VaultItem item) {
    state = [...state, item];      // immutable update
  }

  void removeItem(String id) {
    state = state.where((i) => i.id != id).toList();
  }

  void updateItem(VaultItem updated) {
    state = [
      for (final item in state)
        if (item.id == updated.id) updated else item,
    ];
  }
}
```

---

## Dependency Between Providers

```dart
@riverpod
VaultRepository vaultRepository(VaultRepositoryRef ref) {
  final db = ref.watch(databaseProvider);  // depends on db provider
  return VaultRepository(db);
}

@riverpod
class VaultNotifier extends _$VaultNotifier {
  @override
  List<VaultItem> build() {
    // Fetch initial state from repo
    ref.watch(vaultRepositoryProvider).getAllItems();
    return [];
  }
}
```

> 💡 Riverpod builds a DAG of providers and handles re-computation when dependencies change. Exactly like a reactive build system (Bazel, Make, etc.).

---

## Watching vs Reading

```dart
// ref.watch — subscribe; widget rebuilds when provider value changes
final items = ref.watch(vaultItemsProvider);

// ref.read — one-time read; no subscription (use in callbacks/handlers)
onPressed: () {
  ref.read(vaultNotifierProvider.notifier).addItem(newItem);
}

// ref.listen — side-effects on change (e.g., show snackbar on error)
ref.listen(vaultItemsProvider, (prev, next) {
  if (next is AsyncError) showErrorSnackbar(context);
});
```

---

## Code Generation

```bash
# Generate the .g.dart files (run once, then watch mode)
dart run build_runner watch --delete-conflicting-outputs
```

This generates the `_$VaultNotifier` base class, the `vaultNotifierProvider` variable, etc.

---

## Architecture Pattern: Feature-First

```
lib/
├── features/
│   ├── auth/
│   │   ├── data/          ← repositories, data sources
│   │   ├── domain/        ← models, entities
│   │   └── presentation/  ← screens, widgets, providers
│   └── vault/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── core/
    ├── network/
    └── storage/
```

---

## SecureVault — Milestone 02

- `VaultNotifier` with add/remove/update
- `VaultItem` model (Freezed immutable data class)
- `HomeScreen` consuming `vaultItemsProvider` with `AsyncValue` handling
- Loading and error states visible in UI
- In-memory fake repository (real DB in Module 04)

Next: [03 — Navigation](../03_navigation/README.md)
