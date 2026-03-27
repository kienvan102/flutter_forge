import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/vault_providers.dart';

class VaultItemDetailScreen extends ConsumerWidget {
  const VaultItemDetailScreen({required this.itemId, super.key});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Derive single item from the items stream
    final itemAsync = ref.watch(vaultItemsProvider).whenData(
          (items) => items.where((i) => i.id == itemId).firstOrNull,
        );

    return itemAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) =>
          Scaffold(body: Center(child: Text('Error: $e'))),
      data: (item) {
        if (item == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Item not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(item.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push('/vault/${item.id}/edit'),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context, ref, item.id),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (item.username != null)
                _CopyField(
                  label: 'Username',
                  value: item.username!,
                  icon: Icons.person_outline,
                ),
              // Password field — shows masked, copy reveals
              // TODO (Module 05): decrypt with MasterKeyService before displaying
              _CopyField(
                label: 'Password',
                value: item.encryptedPassword,
                icon: Icons.lock_outline,
                obscure: true,
              ),
              if (item.url != null)
                _CopyField(
                  label: 'URL',
                  value: item.url!,
                  icon: Icons.link,
                ),
              if (item.notes != null && item.notes!.isNotEmpty)
                _CopyField(
                  label: 'Notes',
                  value: item.notes!,
                  icon: Icons.note_outlined,
                  multiline: true,
                ),
              const SizedBox(height: 24),
              Text(
                'Created: ${_formatDate(item.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                'Updated: ${_formatDate(item.updatedAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete item?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(vaultNotifierProvider.notifier).deleteItem(id);
      if (context.mounted) context.pop();
    }
  }
}

class _CopyField extends StatefulWidget {
  const _CopyField({
    required this.label,
    required this.value,
    required this.icon,
    this.obscure = false,
    this.multiline = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool obscure;
  final bool multiline;

  @override
  State<_CopyField> createState() => _CopyFieldState();
}

class _CopyFieldState extends State<_CopyField> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(widget.icon),
        title: Text(widget.label,
            style: Theme.of(context).textTheme.bodySmall),
        subtitle: Text(
          widget.obscure && !_revealed ? '••••••••' : widget.value,
          maxLines: widget.multiline ? null : 1,
          overflow: widget.multiline ? null : TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.obscure)
              IconButton(
                icon: Icon(_revealed ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _revealed = !_revealed),
              ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: widget.value));
                // TODO (Module 05): use ClipboardService for auto-clear
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${widget.label} copied')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
