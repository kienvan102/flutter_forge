import '../../domain/models/vault_item.dart';

/// Abstract repository interface — the vault feature works through this contract.
/// Swap implementations without touching any UI code.
abstract class VaultRepository {
  Stream<List<VaultItem>> watchItems();
  Future<List<VaultItem>> searchItems(String query);
  Future<VaultItem?> getItemById(String id);
  Future<void> addItem(VaultItem item);
  Future<void> updateItem(VaultItem item);
  Future<void> deleteItem(String id);
  Future<void> toggleFavorite(String id);
}

/// In-memory implementation — used until Module 04 adds Drift
class InMemoryVaultRepository implements VaultRepository {
  final _items = <VaultItem>[];
  final _controller = _StreamController<List<VaultItem>>();

  @override
  Stream<List<VaultItem>> watchItems() => _controller.stream;

  @override
  Future<List<VaultItem>> searchItems(String query) async {
    final q = query.toLowerCase();
    return _items
        .where((i) =>
            i.title.toLowerCase().contains(q) ||
            (i.url?.toLowerCase().contains(q) ?? false) ||
            (i.username?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  @override
  Future<VaultItem?> getItemById(String id) async =>
      _items.where((i) => i.id == id).firstOrNull;

  @override
  Future<void> addItem(VaultItem item) async {
    _items.add(item);
    _notify();
  }

  @override
  Future<void> updateItem(VaultItem item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
      _notify();
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    _items.removeWhere((i) => i.id == id);
    _notify();
  }

  @override
  Future<void> toggleFavorite(String id) async {
    final index = _items.indexWhere((i) => i.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(isFavorite: !_items[index].isFavorite);
      _notify();
    }
  }

  void _notify() => _controller.add(List.unmodifiable(_items));
}

// Minimal stream wrapper
class _StreamController<T> {
  final _listeners = <void Function(T)>[];
  T? _lastValue;

  Stream<T> get stream => Stream<T>.multi((controller) {
        if (_lastValue != null) controller.add(_lastValue as T);
        final fn = controller.add;
        _listeners.add(fn);
        controller.onCancel = () => _listeners.remove(fn);
      });

  void add(T value) {
    _lastValue = value;
    for (final l in List.of(_listeners)) {
      l(value);
    }
  }
}
