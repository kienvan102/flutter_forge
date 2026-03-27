# 04 — Data & Storage

> Time: ~1 week | Goal: Persist data locally and talk to APIs like a backend engineer

---

## Stack for This Module

| Concern | Package | Backend Equivalent |
|---------|---------|-------------------|
| Local SQL database | `drift` | GORM / Hibernate / sqlx |
| HTTP client | `dio` | Axios / OkHttp / Go `net/http` |
| JSON serialization | `freezed` + `json_serializable` | Jackson / serde |
| Secure key-value | `flutter_secure_storage` | (see Module 05) |

---

## Part 1: Local Database with Drift

Drift is a type-safe SQLite ORM for Flutter/Dart. It generates query code from your schema.

### Setup

```yaml
dependencies:
  drift: ^2.18.0
  sqlite3_flutter_libs: ^0.5.0
  path_provider: ^2.1.0
  path: ^1.9.0

dev_dependencies:
  drift_dev: ^2.18.0
  build_runner: ^2.4.0
```

### Define Tables

```dart
// data/local/tables/vault_items_table.dart
import 'package:drift/drift.dart';

class VaultItems extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get username => text().nullable()();
  TextColumn get encryptedPassword => text()();    // always encrypted!
  TextColumn get url => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get category => text().withDefault(const Constant('login'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Database Class

```dart
// data/local/app_database.dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'app_database.g.dart';  // generated

@DriftDatabase(tables: [VaultItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Migrations — just like Flyway/Alembic
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(vaultItems, vaultItems.isFavorite);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'vault.db'));
    return NativeDatabase.createInBackground(file);
  });
}
```

### DAO (Data Access Object)

```dart
// data/local/daos/vault_items_dao.dart
part of '../app_database.dart';

extension VaultItemsDao on AppDatabase {
  // SELECT all
  Future<List<VaultItem>> getAllItems() => select(vaultItems).get();

  // SELECT with watch (reactive stream — updates UI automatically)
  Stream<List<VaultItem>> watchAllItems() => select(vaultItems).watch();

  // SELECT by id
  Future<VaultItem?> getItemById(String id) =>
      (select(vaultItems)..where((t) => t.id.equals(id))).getSingleOrNull();

  // INSERT
  Future<void> insertItem(VaultItemsCompanion entry) =>
      into(vaultItems).insert(entry);

  // UPDATE
  Future<bool> updateItem(VaultItemsCompanion entry) =>
      update(vaultItems).replace(entry);

  // DELETE
  Future<int> deleteItem(String id) =>
      (delete(vaultItems)..where((t) => t.id.equals(id))).go();

  // SEARCH
  Future<List<VaultItem>> searchItems(String query) =>
      (select(vaultItems)
        ..where((t) => t.title.contains(query) | t.url.contains(query)))
          .get();
}
```

---

## Part 2: Immutable Models with Freezed

Freezed generates immutable data classes with `copyWith`, `==`, `hashCode`, and JSON support.

> 💡 **Backend Lens:** Freezed classes ≈ Kotlin data classes / Rust structs. `copyWith` ≈ Kotlin's `.copy()`.

```yaml
dependencies:
  freezed_annotation: ^2.4.0
  json_annotation: ^4.9.0

dev_dependencies:
  freezed: ^2.4.0
  json_serializable: ^6.8.0
```

```dart
// domain/models/vault_item.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'vault_item.freezed.dart';
part 'vault_item.g.dart';

@freezed
class VaultItem with _$VaultItem {
  const factory VaultItem({
    required String id,
    required String title,
    String? username,
    required String encryptedPassword,
    String? url,
    String? notes,
    @Default('login') String category,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isFavorite,
  }) = _VaultItem;

  factory VaultItem.fromJson(Map<String, dynamic> json) =>
      _$VaultItemFromJson(json);
}
```

```bash
dart run build_runner build --delete-conflicting-outputs
```

Usage:

```dart
final item = VaultItem(
  id: uuid.v4(),
  title: 'GitHub',
  username: 'van@example.com',
  encryptedPassword: encryptedStr,
  url: 'https://github.com',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// copyWith — immutable update
final updated = item.copyWith(title: 'GitHub (work)', isFavorite: true);

// JSON
final json = item.toJson();
final fromJson = VaultItem.fromJson(json);
```

---

## Part 3: HTTP with Dio

```yaml
dependencies:
  dio: ^5.4.0
  pretty_dio_logger: ^1.3.0    # dev-only logging
```

```dart
// core/network/dio_client.dart
@riverpod
Dio dioClient(DioClientRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,       // from --dart-define
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  // Auth interceptor — attaches JWT to every request
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await ref.read(tokenStorageProvider).getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // 401 → refresh token → retry
        if (error.response?.statusCode == 401) {
          await ref.read(authServiceProvider).refreshToken();
          handler.resolve(await _retry(dio, error.requestOptions));
          return;
        }
        handler.next(error);
      },
    ),
  );

  return dio;
}
```

> 💡 **Backend Lens:** Dio interceptors ≈ HTTP middleware (Express middleware, Go middleware chain, Spring filters). Same pattern, Flutter.

---

## Part 4: Repository Pattern

Keep your UI and business logic completely unaware of whether data comes from local DB, remote API, or cache.

```dart
// data/repositories/vault_repository.dart
abstract class VaultRepository {
  Stream<List<VaultItem>> watchItems();
  Future<VaultItem?> getItemById(String id);
  Future<void> addItem(VaultItem item);
  Future<void> updateItem(VaultItem item);
  Future<void> deleteItem(String id);
}

// Implementation using Drift
class LocalVaultRepository implements VaultRepository {
  final AppDatabase _db;
  LocalVaultRepository(this._db);

  @override
  Stream<List<VaultItem>> watchItems() =>
      _db.watchAllItems().map((rows) => rows.map(_fromRow).toList());

  // ... other methods
}
```

---

## SecureVault — Milestone 04

- `AppDatabase` with `VaultItems` table
- `VaultItem` Freezed model with JSON support
- `LocalVaultRepository` replacing the fake in-memory repo
- Full CRUD working with persistence across app restarts
- Dio client (even if there's no real API yet — set up the scaffolding)

Next: [05 — Security 🔐](../05_security/README.md)
