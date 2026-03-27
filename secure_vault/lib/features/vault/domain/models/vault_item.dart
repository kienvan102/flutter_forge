// Module 04: Replace this hand-written model with Freezed
// dart run build_runner build

/// A single credential/secret entry in the vault.
///
/// IMPORTANT: `password` stored here is ALWAYS the ENCRYPTED ciphertext.
/// Decryption happens in the UI layer only when explicitly requested by user.
class VaultItem {
  const VaultItem({
    required this.id,
    required this.title,
    this.username,
    required this.encryptedPassword,
    this.url,
    this.notes,
    this.category = 'login',
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final String? username;
  final String encryptedPassword;  // ← never store plaintext!
  final String? url;
  final String? notes;
  final String category;           // 'login' | 'card' | 'note' | 'identity'
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;

  VaultItem copyWith({
    String? id,
    String? title,
    String? username,
    String? encryptedPassword,
    String? url,
    String? notes,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
  }) {
    return VaultItem(
      id: id ?? this.id,
      title: title ?? this.title,
      username: username ?? this.username,
      encryptedPassword: encryptedPassword ?? this.encryptedPassword,
      url: url ?? this.url,
      notes: notes ?? this.notes,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is VaultItem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Category labels + icons
enum VaultCategory {
  login('login', 'Login'),
  card('card', 'Payment Card'),
  note('note', 'Secure Note'),
  identity('identity', 'Identity');

  const VaultCategory(this.value, this.label);
  final String value;
  final String label;

  static VaultCategory fromValue(String value) =>
      VaultCategory.values.firstWhere(
        (c) => c.value == value,
        orElse: () => VaultCategory.login,
      );
}
