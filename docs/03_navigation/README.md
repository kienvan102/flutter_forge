# 03 — Navigation & Routing with GoRouter

> Time: ~3–4 days | Goal: Multi-screen routing with auth guards and deep links

---

## Why GoRouter?

Flutter's built-in `Navigator` (v1 and v2) is powerful but verbose. GoRouter gives you:
- **Declarative, URL-based routing** (works on web AND mobile)
- **Route guards** (redirect unauthenticated users)
- **Nested navigation** (tabs + sub-routes)
- **Deep linking** out of the box
- **Type-safe** route parameters

> 💡 **Backend Lens:** GoRouter ≈ Express.js/Gin/FastAPI router. Route paths, params, query strings, middleware guards — same concepts, Flutter syntax.

---

## Setup

```yaml
dependencies:
  go_router: ^14.0.0
```

---

## Basic Routing

```dart
// router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/vault',
        builder: (context, state) => const VaultListScreen(),
        routes: [
          // Nested route: /vault/:id
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return VaultItemDetailScreen(itemId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
```

```dart
// main.dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
```

---

## Navigation Commands

```dart
// Navigate to a route (replaces current history entry on web)
context.go('/vault');

// Push onto the stack (back button returns here)
context.push('/vault/item-123');

// Go back
context.pop();

// Navigate with params
context.go('/vault/item-123');

// Navigate with query params
context.go('/vault?filter=passwords');

// Navigate with extra data (not in URL, passed in memory)
context.push('/vault/new', extra: {'template': 'login'});
```

---

## Route Guards (Auth Redirect)

This is the equivalent of Express middleware / Spring Security filters.

```dart
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  // Listen to auth state — router rebuilds when auth changes
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/vault',
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isGoingToLogin = state.matchedLocation == '/login';

      // Not logged in and not heading to login → redirect to login
      if (!isLoggedIn && !isGoingToLogin) return '/login';

      // Already logged in and heading to login → redirect to vault
      if (isLoggedIn && isGoingToLogin) return '/vault';

      // No redirect needed
      return null;
    },
    routes: [...],
  );
}
```

---

## Shell Routes (Tab Navigation)

```dart
ShellRoute(
  builder: (context, state, child) => AppShell(child: child),
  routes: [
    GoRoute(path: '/vault', builder: (_, __) => const VaultListScreen()),
    GoRoute(path: '/generator', builder: (_, __) => const GeneratorScreen()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
  ],
),
```

```dart
// AppShell — persistent bottom nav
class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexFromLocation(location),
        onDestinationSelected: (i) => context.go(_locationFromIndex(i)),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.lock), label: 'Vault'),
          NavigationDestination(icon: Icon(Icons.password), label: 'Generator'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  int _indexFromLocation(String loc) {
    if (loc.startsWith('/vault')) return 0;
    if (loc.startsWith('/generator')) return 1;
    return 2;
  }

  String _locationFromIndex(int i) => ['/vault', '/generator', '/settings'][i];
}
```

---

## Type-Safe Routes (GoRouter + Code Gen)

For larger apps, use `go_router_builder` to get compile-time safe routes:

```bash
flutter pub add go_router_builder --dev
```

```dart
@TypedGoRoute<VaultItemRoute>(path: '/vault/:id')
class VaultItemRoute extends GoRouteData {
  const VaultItemRoute({required this.id});
  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return VaultItemDetailScreen(itemId: id);
  }
}

// Usage — compile-time safe:
VaultItemRoute(id: 'abc123').go(context);
```

---

## Deep Links

```yaml
# android/app/src/main/AndroidManifest.xml — add intent filter
# ios/Runner/Info.plist — add URL schemes
# web — works automatically via URL bar
```

GoRouter handles deep links automatically when the app opens from a URL like `securevault://vault/item-123`.

---

## SecureVault — Milestone 03

- Full routing with GoRouter: `/login`, `/vault`, `/vault/:id`, `/generator`, `/settings`
- Auth redirect guard (checks `authStateProvider`)
- `AppShell` with `NavigationBar` (bottom nav)
- On desktop: `NavigationRail` instead of bottom nav (preview of Module 06)
- Transition animations between routes

Next: [04 — Data & Storage](../04_data_storage/README.md)
