import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Password Generator screen.
/// A good standalone exercise: add entropy calculation and zxcvbn scoring.
class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  int _length = 20;
  bool _uppercase = true;
  bool _lowercase = true;
  bool _digits = true;
  bool _symbols = true;
  String _generated = '';

  static const _upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const _lower = 'abcdefghijklmnopqrstuvwxyz';
  static const _digits = '0123456789';
  static const _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    final charset = StringBuffer();
    if (_uppercase) charset.write(_upper);
    if (_lowercase) charset.write(_lower);
    if (_digits) charset.write(_GeneratorScreenState._digits);
    if (_symbols) charset.write(_GeneratorScreenState._symbols);

    if (charset.isEmpty) {
      setState(() => _generated = '(select at least one character type)');
      return;
    }

    final chars = charset.toString();
    final rng = Random.secure();
    final pw = List.generate(_length, (_) => chars[rng.nextInt(chars.length)])
        .join();
    setState(() => _generated = pw);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Password Generator')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Generated password display
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(
                  _generated,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontFamily: 'monospace',
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _generate,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Regenerate'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filled(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _generated));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Text('Length: $_length', style: theme.textTheme.labelLarge),
              Slider(
                value: _length.toDouble(),
                min: 8,
                max: 64,
                divisions: 56,
                label: _length.toString(),
                onChanged: (v) {
                  setState(() => _length = v.round());
                  _generate();
                },
              ),
              const SizedBox(height: 16),

              _Toggle('Uppercase (A-Z)', _uppercase, (v) {
                setState(() => _uppercase = v);
                _generate();
              }),
              _Toggle('Lowercase (a-z)', _lowercase, (v) {
                setState(() => _lowercase = v);
                _generate();
              }),
              _Toggle('Digits (0-9)', _digits, (v) {
                setState(() => _digits = v);
                _generate();
              }),
              _Toggle('Symbols (!@#...)', _symbols, (v) {
                setState(() => _symbols = v);
                _generate();
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle(this.label, this.value, this.onChanged);
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}
