import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'router/app_router.dart';
import 'shared/theme/app_theme.dart';

// Entry points per flavor — see lib/main_dev.dart and lib/main_prod.dart
// Run: flutter run -t lib/main_dev.dart
void main() {
  AppConfig.init(Flavor.dev);
  _runApp();
}

void _runApp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: SecureVaultApp(),
    ),
  );
}

class SecureVaultApp extends ConsumerWidget {
  const SecureVaultApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'SecureVault',
      debugShowCheckedModeBanner: kDebugMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
