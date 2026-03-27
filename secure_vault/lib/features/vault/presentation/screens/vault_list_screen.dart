import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/vault_providers.dart';
import '../widgets/vault_item_card.dart';

class VaultListScreen extends ConsumerWidget {
  const VaultListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(filteredVaultItemsProvider);
    final searchQuery = ref.watch(vaultSearchProvider);

    return Scaffold(
      appBar: AppBar(
        title: searchQuery.isEmpty
            ? const Text('Vault')
            : TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: (v) =>
                    ref.read(vaultSearchProvider.notifier).update(v),
              ),
        actions: [
          // Search toggle
          IconButton(
            icon: Icon(
                searchQuery.isEmpty ? Icons.search : Icons.search_off),
            onPressed: () {
              if (searchQuery.isEmpty) {
                ref.read(vaultSearchProvider.notifier).update(' ');
              } else {
                ref.read(vaultSearchProvider.notifier).clear();
              }
            },
          ),
          // Sort / filter (future enhancement)
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filters — coming soon')),
              );
            },
          ),
        ],
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading vault: $err'),
            ],
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_open_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(
                    searchQuery.isEmpty
                        ? 'Your vault is empty\nTap + to add your first item'
                        : 'No results for "$searchQuery"',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: VaultItemCard(
                  item: item,
                  onTap: () => context.push('/vault/${item.id}'),
                  onFavoriteTap: () => ref
                      .read(vaultNotifierProvider.notifier)
                      .toggleFavorite(item.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/vault/new'),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }
}
