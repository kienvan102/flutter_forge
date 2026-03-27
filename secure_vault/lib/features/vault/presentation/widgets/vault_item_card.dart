import 'package:flutter/material.dart';

import '../../domain/models/vault_item.dart';

class VaultItemCard extends StatelessWidget {
  const VaultItemCard({
    required this.item,
    required this.onTap,
    this.onFavoriteTap,
    super.key,
  });

  final VaultItem item;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;

  IconData get _categoryIcon => switch (item.category) {
        'card' => Icons.credit_card,
        'note' => Icons.note_outlined,
        'identity' => Icons.person_outline,
        _ => Icons.lock_outline,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _categoryIcon,
                  color: colorScheme.onPrimaryContainer,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              // Title & username
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.username != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.username!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Favorite toggle
              if (onFavoriteTap != null)
                IconButton(
                  icon: Icon(
                    item.isFavorite ? Icons.star : Icons.star_border,
                    color: item.isFavorite
                        ? Colors.amber
                        : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: onFavoriteTap,
                  visualDensity: VisualDensity.compact,
                ),

              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
