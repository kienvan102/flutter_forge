import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_vault/features/vault/domain/models/vault_item.dart';
import 'package:secure_vault/features/vault/presentation/widgets/vault_item_card.dart';

void main() {
  final testItem = VaultItem(
    id: 'test-1',
    title: 'GitHub',
    username: 'van@example.com',
    encryptedPassword: 'enc_placeholder',
    url: 'https://github.com',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  Widget buildCard({VoidCallback? onFavoriteTap}) => MaterialApp(
        home: Scaffold(
          body: VaultItemCard(
            item: testItem,
            onTap: () {},
            onFavoriteTap: onFavoriteTap,
          ),
        ),
      );

  group('VaultItemCard', () {
    testWidgets('displays title and username', (tester) async {
      await tester.pumpWidget(buildCard());

      expect(find.text('GitHub'), findsOneWidget);
      expect(find.text('van@example.com'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VaultItemCard(
              item: testItem,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VaultItemCard));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('shows star_border when not favorite', (tester) async {
      await tester.pumpWidget(buildCard(onFavoriteTap: () {}));
      expect(find.byIcon(Icons.star_border), findsOneWidget);
    });

    testWidgets('shows star when favorite', (tester) async {
      final favItem = testItem.copyWith(isFavorite: true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VaultItemCard(
              item: favItem,
              onTap: () {},
              onFavoriteTap: () {},
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('calls onFavoriteTap when star tapped', (tester) async {
      var favTapped = false;
      await tester.pumpWidget(buildCard(onFavoriteTap: () => favTapped = true));

      await tester.tap(find.byIcon(Icons.star_border));
      await tester.pump();
      expect(favTapped, isTrue);
    });
  });
}
