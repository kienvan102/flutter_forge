import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Security'),
          ListTile(
            leading: const Icon(Icons.lock_clock),
            title: const Text('Auto-lock timeout'),
            subtitle: const Text('1 minute'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // TODO (Module 05)
          ),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: const Text('Biometric unlock'),
            trailing: Switch(value: false, onChanged: (_) {}), // TODO (Module 05)
          ),
          ListTile(
            leading: const Icon(Icons.content_paste_off),
            title: const Text('Clear clipboard after'),
            subtitle: const Text('30 seconds'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // TODO (Module 05)
          ),
          const Divider(),
          const _SectionHeader('Appearance'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme'),
            subtitle: const Text('System default'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {}, // TODO
          ),
          const Divider(),
          const _SectionHeader('Vault'),
          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text('Lock Vault'),
            onTap: () => context.go('/login'), // TODO (Module 05): also clear key
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About SecureVault'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'SecureVault',
              applicationVersion: '0.1.0',
              applicationLegalese: '© 2024 Flutter Forge Course',
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
