import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/vault/presentation/screens/vault_list_screen.dart';
import '../features/vault/presentation/screens/vault_item_detail_screen.dart';
import '../features/vault/presentation/screens/vault_item_form_screen.dart';
import '../features/generator/presentation/generator_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../shared/widgets/app_shell.dart';

part 'app_router.g.dart';

// Route path constants — avoids magic strings
abstract class AppRoutes {
  static const login = '/login';
  static const vault = '/vault';
  static const vaultItem = '/vault/:id';
  static const vaultNew = '/vault/new';
  static const generator = '/generator';
  static const settings = '/settings';
}

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  // TODO (Module 03): Add ref.watch(authStateProvider) here for redirect guard
  // final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.vault,  // will redirect to /login when auth added
    debugLogDiagnostics: true,         // remove in prod
    routes: [
      // ── Auth ───────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // ── Main Shell (with persistent navigation) ────────────
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.vault,
            builder: (context, state) => const VaultListScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => const VaultItemFormScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => VaultItemDetailScreen(
                  itemId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.generator,
            builder: (context, state) => const GeneratorScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
