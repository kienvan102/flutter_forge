import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Login / vault unlock screen.
///
/// Module 01: Static UI shell (what you build first)
/// Module 03: Wires up GoRouter redirect
/// Module 05: Adds biometric + PIN unlock
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _masterPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _masterPasswordController.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    if (!_formKey.currentState!.validate()) return;

    // TODO (Module 05): Replace with MasterKeyService.unlock()
    // await ref.read(masterKeyServiceProvider.notifier)
    //     .unlock(_masterPasswordController.text);

    // For now, navigate directly
    if (mounted) context.go('/vault');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Logo ──────────────────────────────────────
                    Icon(
                      Icons.lock,
                      size: 64,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'SecureVault',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your master password to unlock',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ── Master Password Field ──────────────────────
                    TextFormField(
                      key: const Key('master_password_field'),
                      controller: _masterPasswordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Master Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Please enter your master password';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _unlock(),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 24),

                    // ── Unlock Button ──────────────────────────────
                    FilledButton.icon(
                      key: const Key('unlock_button'),
                      onPressed: _unlock,
                      icon: const Icon(Icons.lock_open),
                      label: const Text('Unlock Vault'),
                    ),
                    const SizedBox(height: 16),

                    // ── Biometric Button (Module 05) ───────────────
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO (Module 05): ref.read(biometricAuthProvider.notifier).authenticate()
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Biometric auth — implement in Module 05'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.fingerprint),
                      label: const Text('Use Biometrics'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
