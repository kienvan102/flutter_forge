# 05 — Security 🔐

> Time: ~1 week | Goal: Build apps that handle sensitive data with engineering-grade security

This is the module you won't skip. SecureVault is a secrets manager — every lesson here is load-bearing.

---

## OWASP Mobile Top 10 — Applied to Flutter

| # | Threat | Flutter Mitigation |
|---|--------|--------------------|
| M1 | Improper Credential Usage | `flutter_secure_storage`, no hardcoded secrets |
| M2 | Inadequate Supply Chain Security | Lock `pubspec.lock`, audit dependencies |
| M3 | Insecure Auth/Authorization | Biometric + PIN, short session tokens |
| M4 | Insufficient I/O Validation | Validate all user input before encryption |
| M5 | Insecure Communication | Certificate pinning, HTTPS enforced |
| M6 | Inadequate Privacy Controls | Minimize PII, secure clipboard, auto-lock |
| M7 | Insufficient Binary Protections | Code obfuscation, ProGuard |
| M8 | Security Misconfiguration | No debug flags in release, AndroidManifest hardened |
| M9 | Insecure Data Storage | Encrypted DB, no logs of sensitive data |
| M10 | Insufficient Cryptography | AES-256-GCM, PBKDF2/Argon2 key derivation |

---

## 1. Secure Storage (OS Keychain/Keystore)

**Never** store sensitive data in `SharedPreferences` — it's plaintext on disk.

```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

```dart
// core/storage/secure_storage.dart
@riverpod
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,  // uses Android Keystore
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    mOptions: MacOsOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
}

@riverpod
class TokenStorage extends _$TokenStorage {
  @override
  Future<String?> build() => _storage.read(key: _tokenKey);

  static const _tokenKey = 'auth_token';
  FlutterSecureStorage get _storage => ref.read(secureStorageProvider);

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    ref.invalidateSelf();
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    ref.invalidateSelf();
  }
}
```

> ⚠️ On Android emulators: use `encryptedSharedPreferences: true` but note that on rooted devices the keystore can be extracted. Always layer encryption on top.

---

## 2. AES-256-GCM Encryption at Rest

The vault database stores **encrypted** passwords. The encryption key is derived from the user's master password and stored in the OS keychain.

```yaml
dependencies:
  encrypt: ^5.0.0
  pointycastle: ^3.7.0   # for key derivation
```

### Key Derivation (PBKDF2)

```dart
// core/security/key_derivation.dart
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

Uint8List deriveKey({
  required String password,
  required Uint8List salt,
  int iterations = 100000,  // OWASP recommends ≥ 100k
  int keyLength = 32,        // 256 bits for AES-256
}) {
  final params = Pbkdf2Parameters(salt, iterations, keyLength);
  final pbkdf2 = KeyDerivator('SHA-256/HMAC/PBKDF2')..init(params);
  return pbkdf2.process(Uint8List.fromList(password.codeUnits));
}
```

### Vault Encryption Service

```dart
// core/security/vault_crypto.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

class VaultCrypto {
  /// Encrypt a plaintext password for storage.
  /// Returns base64(iv + ciphertext)
  static String encrypt(String plaintext, Key key) {
    final iv = IV.fromSecureRandom(16);          // random IV every time
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
    final encrypted = encrypter.encrypt(plaintext, iv: iv);

    // Store IV alongside ciphertext (IV is not secret, just unique)
    final combined = Uint8List(16 + encrypted.bytes.length)
      ..setRange(0, 16, iv.bytes)
      ..setRange(16, 16 + encrypted.bytes.length, encrypted.bytes);

    return base64.encode(combined);
  }

  /// Decrypt a stored encrypted password.
  static String decrypt(String encoded, Key key) {
    final bytes = base64.decode(encoded);
    final iv = IV(bytes.sublist(0, 16));
    final ciphertext = Encrypted(bytes.sublist(16));
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
    return encrypter.decrypt(ciphertext, iv: iv);
  }
}
```

### Master Key Lifecycle

```dart
// core/security/master_key_service.dart
@riverpod
class MasterKeyService extends _$MasterKeyService {
  // Key is held in memory ONLY, never serialized
  Key? _masterKey;

  @override
  bool build() => _masterKey != null;  // isUnlocked

  Future<void> unlock(String masterPassword) async {
    final storage = ref.read(secureStorageProvider);

    // Get or create salt
    String? saltBase64 = await storage.read(key: 'vault_salt');
    if (saltBase64 == null) {
      final salt = IV.fromSecureRandom(32).bytes;
      saltBase64 = base64.encode(salt);
      await storage.write(key: 'vault_salt', value: saltBase64);
    }

    final salt = base64.decode(saltBase64);
    final keyBytes = deriveKey(password: masterPassword, salt: salt);
    _masterKey = Key(keyBytes);
    state = true;
  }

  Key get key {
    if (_masterKey == null) throw StateError('Vault is locked');
    return _masterKey!;
  }

  void lock() {
    _masterKey = null;   // GC will wipe it
    state = false;
  }
}
```

---

## 3. Biometric Authentication

```yaml
dependencies:
  local_auth: ^2.3.0
```

```dart
// features/auth/biometric_service.dart
@riverpod
Future<bool> biometricAvailable(BiometricAvailableRef ref) async {
  final auth = LocalAuthentication();
  return auth.canCheckBiometrics && await auth.isDeviceSupported();
}

@riverpod
class BiometricAuth extends _$BiometricAuth {
  @override
  void build() {}

  Future<bool> authenticate() async {
    final auth = LocalAuthentication();
    try {
      return await auth.authenticate(
        localizedReason: 'Unlock SecureVault',
        options: const AuthenticationOptions(
          stickyAuth: true,       // keeps dialog if user switches apps
          biometricOnly: false,   // allow PIN fallback
        ),
      );
    } on PlatformException {
      return false;
    }
  }
}
```

**Platform config required:**

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
```

```xml
<!-- ios/Runner/Info.plist -->
<key>NSFaceIDUsageDescription</key>
<string>SecureVault uses Face ID to unlock your vault</string>
```

---

## 4. Certificate Pinning

Prevents MITM attacks even on compromised CAs. Essential for a secrets manager.

```dart
// core/network/certificate_pinning.dart
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      // Pinning is handled at the HttpClient level
      handler.next(options);
    },
  ),
);

// In your Dio setup, use a custom HttpClient:
(dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
  final client = HttpClient();
  client.badCertificateCallback = (cert, host, port) {
    // Compare cert's SHA-256 fingerprint to your pinned hash
    final pin = sha256.convert(cert.der).toString();
    return _pinnedFingerprints.contains(pin);
  };
  return client;
};

const _pinnedFingerprints = {
  'YOUR_CERT_SHA256_HEX_HERE',
  'BACKUP_CERT_SHA256_HEX_HERE',   // always pin 2 for rotation
};
```

> ⚠️ Only pin certs for your own APIs. Certificate pinning breaks debugging with proxies like Charles/mitmproxy — disable for debug builds via `kDebugMode`.

---

## 5. Auto-Lock on Background

```dart
// features/auth/app_lifecycle_observer.dart
class AppLifecycleObserver extends ConsumerStatefulWidget { ... }

class _AppLifecycleObserverState
    extends ConsumerState<AppLifecycleObserver>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      // App went to background → lock immediately
      ref.read(masterKeyServiceProvider.notifier).lock();
    }
  }
}
```

---

## 6. No Secrets in Source Code

```dart
// ❌ WRONG
const apiUrl = 'https://api.securevault.com';
const apiKey = 'sk_live_abc123';

// ✅ CORRECT — via --dart-define at build time
class Env {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api-dev.securevault.com',
  );
  static const apiKey = String.fromEnvironment('API_KEY');
}
```

```bash
# Build / run with env vars
flutter run \
  --dart-define=API_BASE_URL=https://api.securevault.com \
  --dart-define=API_KEY=sk_live_abc123

# Or use a .env file + flutter_dotenv package (for development only)
```

---

## 7. Secure Clipboard

Vault apps should clear the clipboard after a timeout.

```dart
// features/vault/clipboard_service.dart
@riverpod
class ClipboardService extends _$ClipboardService {
  Timer? _clearTimer;

  Future<void> copyPassword(String password) async {
    await Clipboard.setData(ClipboardData(text: password));

    // Clear clipboard after 30 seconds
    _clearTimer?.cancel();
    _clearTimer = Timer(const Duration(seconds: 30), () {
      Clipboard.setData(const ClipboardData(text: ''));
    });
  }

  @override
  void build() {}

  @override
  void dispose() {
    _clearTimer?.cancel();
    super.dispose();
  }
}
```

---

## 8. Code Obfuscation & Shrinking

```bash
# Android release build with obfuscation
flutter build apk --release \
  --obfuscate \
  --split-debug-info=./debug-symbols/android

# iOS
flutter build ipa --release \
  --obfuscate \
  --split-debug-info=./debug-symbols/ios
```

Keep the `debug-symbols/` folder safe — you need it to symbolicate crash reports.

---

## 9. Android Security Hardening

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<application
  android:allowBackup="false"      <!-- prevent backup of sensitive data -->
  android:fullBackupContent="false"
  android:networkSecurityConfig="@xml/network_security_config"
  ...>
```

```xml
<!-- android/app/src/main/res/xml/network_security_config.xml -->
<network-security-config>
  <base-config cleartextTrafficPermitted="false">  <!-- HTTPS only -->
    <trust-anchors>
      <certificates src="system"/>
    </trust-anchors>
  </base-config>
</network-security-config>
```

---

## SecureVault — Milestone 05

After this module SecureVault has:
- All passwords AES-256-GCM encrypted at rest (key derived with PBKDF2)
- Master key in OS keychain, never on disk
- Biometric + PIN unlock flow
- Auto-lock on background
- Certificate pinning on all Dio calls
- 30-second clipboard auto-clear
- `kDebugMode` debug flag to bypass pinning in dev
- Obfuscation in release build script

Next: [06 — Cross-Platform](../06_cross_platform/README.md)
