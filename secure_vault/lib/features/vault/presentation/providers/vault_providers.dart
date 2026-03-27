import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/vault_repository.dart';
import '../../domain/models/vault_item.dart';

part 'vault_providers.g.dart';

// ── Repository Provider ───────────────────────────────────────────────────────
// Module 04: Override with LocalVaultRepository(drift)
@riverpod
VaultRepository vaultRepository(VaultRepositoryRef ref) {
  return InMemoryVaultRepository();
}

// ── Vault Items Stream ────────────────────────────────────────────────────────
@riverpod
Stream<List<VaultItem>> vaultItems(VaultItemsRef ref) {
  return ref.watch(vaultRepositoryProvider).watchItems();
}

// ── Search Query ──────────────────────────────────────────────────────────────
@riverpod
class VaultSearch extends _$VaultSearch {
  @override
  String build() => '';

  void update(String query) => state = query;
  void clear() => state = '';
}

// ── Filtered Items (search applied) ──────────────────────────────────────────
@riverpod
AsyncValue<List<VaultItem>> filteredVaultItems(FilteredVaultItemsRef ref) {
  final allItems = ref.watch(vaultItemsProvider);
  final query = ref.watch(vaultSearchProvider);

  if (query.isEmpty) return allItems;

  return allItems.whenData((items) {
    final q = query.toLowerCase();
    return items
        .where((i) =>
            i.title.toLowerCase().contains(q) ||
            (i.url?.toLowerCase().contains(q) ?? false) ||
            (i.username?.toLowerCase().contains(q) ?? false))
        .toList();
  });
}

// ── Vault Notifier (CRUD) ─────────────────────────────────────────────────────
@riverpod
class VaultNotifier extends _$VaultNotifier {
  VaultRepository get _repo => ref.read(vaultRepositoryProvider);

  @override
  void build() {}

  Future<void> addItem(VaultItem item) => _repo.addItem(item);
  Future<void> updateItem(VaultItem item) => _repo.updateItem(item);
  Future<void> deleteItem(String id) => _repo.deleteItem(id);
  Future<void> toggleFavorite(String id) => _repo.toggleFavorite(id);
}
