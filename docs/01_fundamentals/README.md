# 01 — Flutter Fundamentals

> Time: ~1 week | Goal: Understand the widget tree; build any static UI

---

## The Core Mental Model

Flutter is **not a wrapper around native views**. It owns the entire pixel — it renders everything itself using its Skia/Impeller engine. Think of it like a game engine that happens to make UIs.

```
Your Code (Dart)
    ↓
Widget Tree (your description of the UI)
    ↓
Element Tree (Flutter's live instance tree — you rarely see this)
    ↓
RenderObject Tree (layout & painting)
    ↓
GPU (Skia / Impeller)
```

> 💡 **Backend Lens:** The Widget tree ≈ a React component tree. Widgets are **immutable descriptions** (like a React render function's return value), not live mutable objects. Flutter diffs and reconciles them like React's VDOM.

---

## Stateless vs Stateful Widget

```dart
// StatelessWidget — pure function of its inputs. No internal state.
class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!');
  }
}

// StatefulWidget — has mutable state that can trigger rebuilds.
// The widget itself is still immutable; State holds the mutable data.
class Counter extends StatefulWidget {
  const Counter({super.key});
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;   // mutable state

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Count: $_count'),
      ElevatedButton(
        onPressed: () => setState(() => _count++),
        child: const Text('+'),
      ),
    ]);
  }
}
```

**Rule of thumb:** Use `StatelessWidget` by default. Only reach for `StatefulWidget` when you have truly local, widget-scoped state (e.g., a toggle animation). For app-wide state, use Riverpod (Module 02).

---

## Layouts — Everything is a Widget

```dart
// Column and Row are the workhorses
Column(
  mainAxisAlignment: MainAxisAlignment.center,   // vertical axis
  crossAxisAlignment: CrossAxisAlignment.start,  // horizontal axis
  children: [
    Text('Item 1'),
    Text('Item 2'),
    const SizedBox(height: 16),  // spacer
    Text('Item 3'),
  ],
)

// Row is the horizontal equivalent
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [Icon(Icons.lock), Text('SecureVault'), Icon(Icons.menu)],
)

// Stack — absolute positioning (like CSS position: absolute)
Stack(
  children: [
    Image.network('https://example.com/bg.jpg'),
    Positioned(bottom: 16, right: 16, child: FloatingActionButton(...)),
  ],
)

// Expanded — fills remaining space (like CSS flex: 1)
Row(children: [
  const Text('Label:'),
  Expanded(child: TextField()),  // TextField fills the rest
])
```

---

## Common Widgets Cheatsheet

| Widget | Equivalent | Notes |
|--------|-----------|-------|
| `Text` | `<p>` / `<span>` | style: TextStyle(...) |
| `Container` | `<div>` | padding, margin, decoration |
| `Padding` | CSS padding | wraps any widget |
| `SizedBox` | fixed width/height div | also used as spacer |
| `Image.asset / .network` | `<img>` | |
| `Icon` | icon font | Material or custom |
| `ElevatedButton` | `<button>` | many variants |
| `TextField` | `<input>` | controller pattern |
| `ListView` | `<ul>` / virtualized list | .builder for large lists |
| `Scaffold` | page template | appBar, body, FAB, drawer |
| `AppBar` | `<header>` / navbar | title, actions, leading |
| `Card` | CSS card / shadow box | elevation, shape |
| `Divider` | `<hr>` | |

---

## The `BuildContext`

`context` is passed to every `build()` method. It represents **where this widget is in the tree** and is used to:
- Access theme: `Theme.of(context)`
- Navigate: `GoRouter.of(context).go('/home')`
- Access providers: `ref.watch(myProvider)` (with Riverpod)

> 💡 Think of it as a scoped dependency injector. Never store it past the widget lifecycle.

---

## Widget Lifecycle (StatefulWidget)

```
initState()     → called once, on first mount (= componentDidMount)
build()         → called on every setState(), parent rebuild, or dependency change
didUpdateWidget → called if parent rebuilds with new config
dispose()       → called on unmount (cancel subscriptions here!)
```

---

## Hot Reload vs Hot Restart

| | Hot Reload | Hot Restart |
|--|-----------|------------|
| Shortcut | `r` | `R` |
| Speed | ~300ms | ~2s |
| State preserved | ✅ yes | ❌ no |
| Works for | UI/logic changes | Added global vars, main() changes |

---

## Material 3 vs Cupertino

Flutter has two design system families:
- **Material 3** (Google): `MaterialApp`, `Scaffold`, `ElevatedButton` etc. — cross-platform but feels Android-ish
- **Cupertino** (Apple): `CupertinoApp`, `CupertinoNavigationBar` etc. — iOS look & feel

**Best practice for SecureVault:** Use Material 3 with adaptive widgets so it looks native on all platforms. Module 06 covers this deeply.

---

## Exercises

1. Build a static `LoginScreen` widget with an email field, password field, and login button. No logic yet.
2. Make a `VaultItemCard` widget that takes a `String title` and `String subtitle` prop.
3. Build a `HomeScreen` with a `Scaffold`, `AppBar`, and a `ListView` of 5 hardcoded `VaultItemCard`s.

---

## SecureVault — Milestone 01

After this module, `secure_vault/` should have:
- `main.dart` with `MaterialApp` + `ThemeData`
- A `LoginScreen` (static, no auth yet)
- A `HomeScreen` with hardcoded vault items list
- A `VaultItemCard` widget
- Bottom navigation or navigation drawer placeholder

See `secure_vault/CHANGELOG.md` for the reference commit.

---

Next: [02 — State Management](../02_state_management/README.md)
