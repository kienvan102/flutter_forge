# 07 — Testing

> Time: ~1 week | Goal: Test with backend engineer confidence applied to Flutter

---

## Three Test Layers

| Layer | Speed | Scope | Tool |
|-------|-------|-------|------|
| Unit | ⚡ fast | Single function/class | `test` package |
| Widget | 🚶 medium | Single widget in isolation | `flutter_test` |
| Integration | 🐢 slow | Full app on device/emulator | `integration_test` |

> 💡 **Backend Lens:** Widget tests ≈ integration tests against a single HTTP handler. Integration tests ≈ end-to-end tests. Unit tests are the same everywhere.

---

## Setup

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.0          # mocking (like Mockito but null-safe)
  golden_toolkit: ^0.15.0   # screenshot regression
  integration_test:
    sdk: flutter
```

---

## Part 1: Unit Tests

### Testing VaultCrypto

```dart
// test/core/security/vault_crypto_test.dart
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault/core/security/vault_crypto.dart';

void main() {
  group('VaultCrypto', () {
    late Key testKey;

    setUp(() {
      testKey = Key.fromSecureRandom(32);
    });

    test('encrypt then decrypt returns original plaintext', () {
      const plaintext = 'super_secret_password_123!';
      final encrypted = VaultCrypto.encrypt(plaintext, testKey);
      final decrypted = VaultCrypto.decrypt(encrypted, testKey);
      expect(decrypted, equals(plaintext));
    });

    test('same plaintext encrypts to different ciphertext each time (random IV)', () {
      const plaintext = 'password';
      final enc1 = VaultCrypto.encrypt(plaintext, testKey);
      final enc2 = VaultCrypto.encrypt(plaintext, testKey);
      expect(enc1, isNot(equals(enc2)));
    });

    test('decrypt fails with wrong key', () {
      const plaintext = 'secret';
      final encrypted = VaultCrypto.encrypt(plaintext, testKey);
      final wrongKey = Key.fromSecureRandom(32);
      expect(
        () => VaultCrypto.decrypt(encrypted, wrongKey),
        throwsException,
      );
    });
  });
}
```

### Testing a Notifier (Riverpod)

```dart
// test/features/vault/vault_notifier_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_vault/features/vault/domain/vault_item.dart';
import 'package:secure_vault/features/vault/presentation/vault_notifier.dart';

class MockVaultRepository extends Mock implements VaultRepository {}

void main() {
  late ProviderContainer container;
  late MockVaultRepository mockRepo;

  setUp(() {
    mockRepo = MockVaultRepository();
    container = ProviderContainer(
      overrides: [
        vaultRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('VaultNotifier', () {
    test('initial state is empty list', () {
      when(() => mockRepo.watchItems()).thenAnswer((_) => Stream.value([]));
      final notifier = container.read(vaultNotifierProvider.notifier);
      expect(container.read(vaultNotifierProvider), isEmpty);
    });

    test('addItem calls repository and updates state', () async {
      when(() => mockRepo.watchItems()).thenAnswer(
          (_) => Stream.value([testItem]));
      when(() => mockRepo.addItem(any())).thenAnswer((_) async {});

      await container.read(vaultNotifierProvider.notifier).addItem(testItem);

      verify(() => mockRepo.addItem(testItem)).called(1);
    });
  });
}

final testItem = VaultItem(
  id: 'test-1',
  title: 'GitHub',
  encryptedPassword: 'enc_xxx',
  createdAt: DateTime(2024),
  updatedAt: DateTime(2024),
);
```

---

## Part 2: Widget Tests

Widget tests render widgets in a fake Flutter environment (no real device needed, runs in milliseconds).

```dart
// test/features/vault/vault_item_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault/features/vault/presentation/widgets/vault_item_card.dart';

void main() {
  group('VaultItemCard', () {
    testWidgets('displays title and username', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VaultItemCard(
            title: 'GitHub',
            username: 'van@example.com',
            onTap: () {},
          ),
        ),
      );

      expect(find.text('GitHub'), findsOneWidget);
      expect(find.text('van@example.com'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: VaultItemCard(
            title: 'Test',
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(VaultItemCard));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('shows favorite icon when isFavorite is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VaultItemCard(
            title: 'Test',
            isFavorite: true,
            onTap: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}
```

### Testing Riverpod Providers in Widgets

```dart
testWidgets('VaultListScreen shows items from provider', (tester) async {
  final mockItems = [
    VaultItem(id: '1', title: 'GitHub', encryptedPassword: 'enc',
        createdAt: DateTime.now(), updatedAt: DateTime.now()),
  ];

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        // Override the provider with test data
        vaultItemsProvider.overrideWith((_) => AsyncData(mockItems)),
      ],
      child: const MaterialApp(home: VaultListScreen()),
    ),
  );

  expect(find.text('GitHub'), findsOneWidget);
});
```

---

## Part 3: Golden Tests (Screenshot Regression)

Golden tests capture a screenshot and compare it to a saved baseline. Any pixel change fails the test.

```dart
// test/golden/vault_item_card_golden_test.dart
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async => loadAppFonts());

  testGoldens('VaultItemCard looks correct', (tester) async {
    await tester.pumpWidgetBuilder(
      VaultItemCard(title: 'GitHub', username: 'van@example.com', onTap: () {}),
      surfaceSize: const Size(400, 80),
    );
    await screenMatchesGolden(tester, 'vault_item_card');
  });
}
```

```bash
# Generate golden files (first run)
flutter test --update-goldens

# Check against goldens
flutter test
```

---

## Part 4: Integration Tests

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:secure_vault/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full add-item flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Login with test PIN
    await tester.enterText(find.byKey(const Key('pin_field')), '1234');
    await tester.tap(find.byKey(const Key('unlock_button')));
    await tester.pumpAndSettle();

    // Tap FAB to add item
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Fill form
    await tester.enterText(find.byKey(const Key('title_field')), 'Test Login');
    await tester.enterText(find.byKey(const Key('password_field')), 'MyP@ss!');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify item appears in list
    expect(find.text('Test Login'), findsOneWidget);
  });
}
```

```bash
flutter test integration_test/app_test.dart -d macos
```

---

## Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## SecureVault — Milestone 07

- Unit tests: `VaultCrypto`, `deriveKey`, `VaultNotifier`, `ClipboardService`
- Widget tests: `VaultItemCard`, `LoginScreen`, `VaultListScreen`
- Golden tests: `VaultItemCard`, `AppShell` (mobile + desktop)
- Integration test: full add/view/delete flow
- Coverage ≥ 80% on `lib/`

Next: [08 — Deployment](../08_deployment/README.md)
