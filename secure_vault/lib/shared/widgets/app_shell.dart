import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Adaptive navigation shell.
/// - Mobile (< 600px): BottomNavigationBar
/// - Tablet/Desktop (≥ 600px): NavigationRail (compact)
/// - Wide Desktop (≥ 1000px): NavigationRail (extended/labeled)
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  static const _destinations = [
    (
      icon: Icons.lock_outline,
      selectedIcon: Icons.lock,
      label: 'Vault',
      path: '/vault',
    ),
    (
      icon: Icons.password_outlined,
      selectedIcon: Icons.password,
      label: 'Generator',
      path: '/generator',
    ),
    (
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
      path: '/settings',
    ),
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/vault')) return 0;
    if (location.startsWith('/generator')) return 1;
    return 2;
  }

  void _onTap(BuildContext context, int index) {
    context.go(_destinations[index].path);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // ── Mobile ──────────────────────────────────────────────
        if (constraints.maxWidth < 600) {
          return Scaffold(
            body: child,
            bottomNavigationBar: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (i) => _onTap(context, i),
              destinations: _destinations
                  .map((d) => NavigationDestination(
                        icon: Icon(d.icon),
                        selectedIcon: Icon(d.selectedIcon),
                        label: d.label,
                      ))
                  .toList(),
            ),
          );
        }

        // ── Tablet / Desktop ─────────────────────────────────────
        final isWide = constraints.maxWidth >= 1000;
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                extended: isWide,
                selectedIndex: selectedIndex,
                onDestinationSelected: (i) => _onTap(context, i),
                destinations: _destinations
                    .map((d) => NavigationRailDestination(
                          icon: Icon(d.icon),
                          selectedIcon: Icon(d.selectedIcon),
                          label: Text(d.label),
                        ))
                    .toList(),
              ),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}
