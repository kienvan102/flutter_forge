/// 🎯 Dart Tour — 06: OOP — Classes, Mixins, Extensions, Interfaces
///
/// Topics: constructors (named, factory), getters/setters, abstract classes,
///         interfaces (implements), mixins, extensions, sealed classes (Dart 3).
///
/// 💡 Backend Lens:
///   mixin     ≈  Go embedded struct (but type-safe) / Ruby module
///   extension ≈  Kotlin extension function / C# extension method
///   sealed    ≈  Rust enum / Kotlin sealed class — exhaustive pattern matching
///
/// Run: dart run --enable-asserts 06_oop/main.dart

void main() {
  _exercise1_classes();
  _exercise2_mixins();
  _exercise3_extensions();
  _exercise4_sealedClasses();
  print('\n🏁 All exercises passed!');
}

// ─── Exercise 1: Classes & Constructors ──────────────────────────────────────
// TODO: Implement the `Credentials` class below
// Requirements:
//   - Fields: `username` (String), `password` (String), `createdAt` (DateTime)
//   - Primary constructor: Credentials(this.username, this.password)
//     → createdAt should default to DateTime.now()
//   - Named constructor: Credentials.withTimestamp(username, password, createdAt)
//   - Factory constructor: Credentials.fromJson(Map<String, dynamic> json)
//     → reads 'username' and 'password' from the map
//   - Getter `maskedPassword`: returns '***' + last 2 chars of password
//   - Override toString(): returns "Credentials($username)"

class Credentials {
  // TODO: implement
  final String username;
  final String password;
  final DateTime createdAt;

  Credentials(this.username, this.password) : createdAt = DateTime.now();

  // TODO: add Credentials.withTimestamp
  Credentials.withTimestamp(this.username, this.password, this.createdAt);

  // TODO: add Credentials.fromJson
  factory Credentials.fromJson(Map<String, dynamic> json) {
    return Credentials('REPLACE_ME', 'REPLACE_ME'); // read from json
  }

  // TODO: implement maskedPassword getter
  String get maskedPassword => 'REPLACE_ME';

  @override
  String toString() => 'REPLACE_ME';
}

void _exercise1_classes() {
  final c = Credentials('alice', 'secret99');
  assert(c.username == 'alice', '❌ Ex1: username should be "alice"');
  assert(c.maskedPassword == '***99', '❌ Ex1: maskedPassword should be "***99"');
  assert(c.toString() == 'Credentials(alice)', '❌ Ex1: toString mismatch');

  final fromJson = Credentials.fromJson({'username': 'bob', 'password': 'pass12'});
  assert(fromJson.username == 'bob', '❌ Ex1: fromJson username should be "bob"');
  assert(fromJson.maskedPassword == '***12', '❌ Ex1: fromJson maskedPassword should be "***12"');

  print('✅ Exercise 1: Classes');
}

// ─── Exercise 2: Mixins ───────────────────────────────────────────────────────
// Mixins let you reuse behavior across unrelated class hierarchies

mixin Loggable {
  // TODO: Add a method `log(String message)` that prints "[ClassName] message"
  // Use runtimeType.toString() to get the class name
  void log(String message) {
    print('REPLACE_ME'); // replace: print('[${runtimeType}] $message')
  }
}

mixin Auditable {
  final List<String> _auditLog = [];

  void audit(String action) {
    _auditLog.add('${DateTime.now().toIso8601String()}: $action');
  }

  List<String> get auditLog => List.unmodifiable(_auditLog);
}

// TODO: Create class `VaultService` that uses BOTH Loggable and Auditable mixins
// It should have a method `addEntry(String key)` that:
//   - calls log('Adding entry: $key')
//   - calls audit('add:$key')
class VaultService with Loggable, Auditable {
  void addEntry(String key) {
    // TODO: call log and audit
  }
}

void _exercise2_mixins() {
  final vault = VaultService();
  vault.addEntry('github_token');
  vault.addEntry('api_key');

  assert(vault.auditLog.length == 2, '❌ Ex2: auditLog should have 2 entries');
  assert(vault.auditLog.first.contains('github_token'),
      '❌ Ex2: first audit entry should mention github_token');
  print('✅ Exercise 2: Mixins');
}

// ─── Exercise 3: Extensions ───────────────────────────────────────────────────
// Extensions add methods to existing types without subclassing

// TODO: Add an extension on String called `StringSecurityExtension`
// with these methods:
//   - `isStrongPassword`: returns true if:
//       length >= 8, has uppercase, has lowercase, has digit, has special char
//   - `redact(int keepLast)`: returns '***' + last `keepLast` chars

extension StringSecurityExtension on String {
  bool get isStrongPassword {
    return false; // TODO: implement
  }

  String redact(int keepLast) {
    return 'REPLACE_ME'; // TODO: implement
  }
}

void _exercise3_extensions() {
  assert('Weak'.isStrongPassword == false, '❌ Ex3: "Weak" should not be strong');
  assert('Str0ng!Pass'.isStrongPassword == true, '❌ Ex3: "Str0ng!Pass" should be strong');
  assert('mySecretToken'.redact(4) == '***oken', '❌ Ex3: redact(4) should show last 4 chars');
  print('✅ Exercise 3: Extensions');
}

// ─── Exercise 4: Sealed Classes (Dart 3) ─────────────────────────────────────
// Sealed classes = exhaustive sum types. The compiler forces you to handle all cases.
// Backend lens: like Rust enums or Kotlin sealed classes

sealed class AuthResult {}
class AuthSuccess extends AuthResult {
  final String token;
  AuthSuccess(this.token);
}
class AuthFailure extends AuthResult {
  final String reason;
  AuthFailure(this.reason);
}
class AuthMfaRequired extends AuthResult {
  final String challengeId;
  AuthMfaRequired(this.challengeId);
}

// TODO: Implement `handleAuth` using a switch expression on the sealed class
// Return:
//   - For AuthSuccess: "Welcome! Token: ${result.token}"
//   - For AuthFailure: "Login failed: ${result.reason}"
//   - For AuthMfaRequired: "MFA required, challenge: ${result.challengeId}"
String handleAuth(AuthResult result) {
  return switch (result) {
    AuthSuccess() => 'REPLACE_ME',
    AuthFailure() => 'REPLACE_ME',
    AuthMfaRequired() => 'REPLACE_ME',
  };
}

void _exercise4_sealedClasses() {
  assert(
    handleAuth(AuthSuccess('tok_abc123')) == 'Welcome! Token: tok_abc123',
    '❌ Ex4: AuthSuccess message mismatch',
  );
  assert(
    handleAuth(AuthFailure('invalid password')) == 'Login failed: invalid password',
    '❌ Ex4: AuthFailure message mismatch',
  );
  assert(
    handleAuth(AuthMfaRequired('ch_xyz')) == 'MFA required, challenge: ch_xyz',
    '❌ Ex4: AuthMfaRequired message mismatch',
  );
  print('✅ Exercise 4: Sealed Classes');
}
