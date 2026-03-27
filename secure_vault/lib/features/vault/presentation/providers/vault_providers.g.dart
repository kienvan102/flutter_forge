// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vaultRepositoryHash() => r'50df50540f2ec7edee74a2e92d98f575f257ec66';

/// See also [vaultRepository].
@ProviderFor(vaultRepository)
final vaultRepositoryProvider = AutoDisposeProvider<VaultRepository>.internal(
  vaultRepository,
  name: r'vaultRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vaultRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VaultRepositoryRef = AutoDisposeProviderRef<VaultRepository>;
String _$vaultItemsHash() => r'b57effe78e136a4de1e74c2347874d00691fb8d0';

/// See also [vaultItems].
@ProviderFor(vaultItems)
final vaultItemsProvider = AutoDisposeStreamProvider<List<VaultItem>>.internal(
  vaultItems,
  name: r'vaultItemsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$vaultItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VaultItemsRef = AutoDisposeStreamProviderRef<List<VaultItem>>;
String _$filteredVaultItemsHash() =>
    r'ae2b24434287f865bfb7911bcff098e0ec231110';

/// See also [filteredVaultItems].
@ProviderFor(filteredVaultItems)
final filteredVaultItemsProvider =
    AutoDisposeProvider<AsyncValue<List<VaultItem>>>.internal(
  filteredVaultItems,
  name: r'filteredVaultItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredVaultItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredVaultItemsRef
    = AutoDisposeProviderRef<AsyncValue<List<VaultItem>>>;
String _$vaultSearchHash() => r'9ed0f6bf73b3f6800f836dce16909f3bec50fd17';

/// See also [VaultSearch].
@ProviderFor(VaultSearch)
final vaultSearchProvider =
    AutoDisposeNotifierProvider<VaultSearch, String>.internal(
  VaultSearch.new,
  name: r'vaultSearchProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$vaultSearchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VaultSearch = AutoDisposeNotifier<String>;
String _$vaultNotifierHash() => r'f6470500e9e8d048e3711237d60771b657977c52';

/// See also [VaultNotifier].
@ProviderFor(VaultNotifier)
final vaultNotifierProvider =
    AutoDisposeNotifierProvider<VaultNotifier, void>.internal(
  VaultNotifier.new,
  name: r'vaultNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vaultNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VaultNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
