# 06 — Cross-Platform UI

> Time: ~1 week | Goal: One codebase, native feel on web · mobile · desktop

---

## The Responsive Design Spectrum

Flutter targets 6 platforms (iOS, Android, Web, macOS, Windows, Linux) with wildly different screen sizes and input models:

```
Phone      360–428px   touch, no hover, one-handed
Tablet     600–900px   touch, optional keyboard, landscape
Web        800–1920px  mouse, hover, keyboard shortcuts, URL bar
Desktop    900–2560px  mouse, keyboard, window resize, menu bar
```

The goal: **adaptive** UI (different layouts per platform) powered by a **responsive** engine (fluid within each layout).

---

## The Three Tools

### 1. `LayoutBuilder` — Respond to parent constraints

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return const MobileVaultList();   // single column
    } else if (constraints.maxWidth < 1200) {
      return const TabletVaultLayout(); // master-detail
    } else {
      return const DesktopVaultLayout(); // sidebar + content + details
    }
  },
)
```

### 2. `MediaQuery` — Screen info and platform

```dart
final size = MediaQuery.sizeOf(context);
final isLandscape =
    MediaQuery.orientationOf(context) == Orientation.landscape;
final textScale = MediaQuery.textScalerOf(context);
```

### 3. Platform detection

```dart
import 'package:flutter/foundation.dart';

bool get isMobile => !kIsWeb &&
    (Platform.isIOS || Platform.isAndroid);
bool get isDesktop => !kIsWeb &&
    (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
bool get isWeb => kIsWeb;
```

---

## Adaptive Navigation Patterns

| Screen size | Navigation widget |
|-------------|-------------------|
| Mobile (< 600px) | `NavigationBar` (bottom) |
| Tablet (600–900px) | `NavigationRail` (side, compact) |
| Desktop (> 900px) | `NavigationDrawer` or permanent `NavigationRail` (expanded) |

```dart
// widgets/adaptive_navigation.dart
class AdaptiveNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  // destinations data
  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.lock_outline),
        selectedIcon: Icon(Icons.lock), label: 'Vault'),
    NavigationDestination(icon: Icon(Icons.password_outlined),
        selectedIcon: Icon(Icons.password), label: 'Generator'),
    NavigationDestination(icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings), label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile: bottom nav
          return Scaffold(
            body: body,
            bottomNavigationBar: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: _destinations,
            ),
          );
        } else {
          // Tablet/Desktop: side rail or drawer
          return Scaffold(
            body: Row(children: [
              NavigationRail(
                extended: constraints.maxWidth > 1000,
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
                destinations: _destinations
                    .map((d) => NavigationRailDestination(
                          icon: d.icon,
                          selectedIcon: d.selectedIcon ?? d.icon,
                          label: Text(d.label),
                        ))
                    .toList(),
              ),
              const VerticalDivider(width: 1),
              Expanded(child: body),
            ]),
          );
        }
      },
    );
  }
}
```

---

## Master-Detail Layout (Tablet/Desktop)

```dart
// On wide screens, show list + detail side by side
class VaultMasterDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 700) {
        return Row(children: [
          SizedBox(
            width: 320,
            child: VaultListPanel(onItemSelected: (id) => _selectedId = id),
          ),
          const VerticalDivider(),
          Expanded(
            child: _selectedId != null
                ? VaultItemDetailPanel(itemId: _selectedId!)
                : const Center(child: Text('Select an item')),
          ),
        ]);
      }
      return VaultListScreen();  // mobile: full-screen list, push detail
    });
  }
}
```

---

## Desktop-Specific Features

### Window Sizing

```yaml
dependencies:
  window_manager: ^0.3.0
```

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (isDesktop) {
    await windowManager.ensureInitialized();
    await windowManager.setMinimumSize(const Size(800, 600));
    await windowManager.setSize(const Size(1200, 800));
    await windowManager.center();
  }

  runApp(const ProviderScope(child: SecureVaultApp()));
}
```

### Menu Bar (macOS/Windows)

```dart
// macOS native menu bar
PlatformMenuBar(
  menus: [
    PlatformMenu(label: 'SecureVault', menus: [
      PlatformMenuItem(
        label: 'Lock Vault',
        shortcut: const SingleActivator(LogicalKeyboardKey.keyL,
            meta: true),
        onSelected: () => ref.read(masterKeyServiceProvider.notifier).lock(),
      ),
    ]),
  ],
  child: myApp,
)
```

### Keyboard Shortcuts

```dart
Shortcuts(
  shortcuts: {
    LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyN):
        const AddItemIntent(),
    LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyF):
        const SearchIntent(),
  },
  child: Actions(
    actions: {
      AddItemIntent: CallbackAction<AddItemIntent>(
        onInvoke: (_) => context.push('/vault/new'),
      ),
      SearchIntent: CallbackAction<SearchIntent>(
        onInvoke: (_) => ref.read(searchActiveProvider.notifier).toggle(),
      ),
    },
    child: body,
  ),
)
```

---

## Web-Specific

### Hover Effects

On desktop web, users expect hover states:

```dart
MouseRegion(
  cursor: SystemMouseCursors.click,
  onEnter: (_) => setState(() => _isHovered = true),
  onExit: (_) => setState(() => _isHovered = false),
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 150),
    color: _isHovered ? Colors.grey.shade100 : Colors.transparent,
    child: vaultItemTile,
  ),
)
```

### URL Strategy (no `#` in URLs)

```dart
// web/main.dart
import 'package:flutter_web_plugins/url_strategy.dart';
void main() {
  usePathUrlStrategy();  // /vault/item instead of /#/vault/item
  runApp(...);
}
```

---

## Platform-Specific Widgets Summary

| Widget | Mobile | Desktop | Web |
|--------|--------|---------|-----|
| `TextField` | full virtual keyboard | desktop keyboard | browser input |
| `SelectableText` | hold to select | drag to select | text selection |
| `Scrollbar` | auto-hide | always visible | browser scrollbar |
| `Tooltip` | on long-press | on hover | on hover |
| `ContextMenu` | long-press | right-click | right-click |

Use `Theme.of(context).platform` or the `adaptive_components` package to pick the right variant automatically.

---

## SecureVault — Milestone 06

- `AdaptiveNavigation` working on all 6 platforms
- Master-detail layout on tablet/desktop
- Window sizing and minimum size on desktop
- macOS menu bar with Lock Vault shortcut
- `Cmd/Ctrl+N` to add new item, `Cmd/Ctrl+F` to search
- URL strategy configured for web
- Hover states on web/desktop list items

Next: [07 — Testing](../07_testing/README.md)
