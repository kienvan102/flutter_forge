/// 🎯 Dart Tour — 02: Null Safety
///
/// Topics: nullable types (?), non-nullable, null assertion (!),
///         late, null-aware operators (??, ?., ??=),
///         required named parameters.
///
/// Run: dart run --enable-asserts 02_null_safety/main.dart
///
/// ─── CONCEPTS ─────────────────────────────────────────────────────────────
/// String — non-nullable; compiler guarantees it can NEVER hold null
/// String? — nullable type; can hold a String value OR null
///
/// ! (null assertion operator) — tells Dart "I know this is not null":
///         maybeNull!.length   →  throws if maybeNull actually is null
/// late — deferred initialization; Dart trusts you'll assign before first read:
///         late String connectionString;   set it later in initialize()
///         throws LateInitializationError if read before assigned
///
/// ?? (if-null operator) — returns left if not null, otherwise right:
///         name ?? 'Anonymous'   →  'Anonymous' only when name is null
/// ?. (null-safe access) — calls method/property only if not null:
///         s?.toUpperCase()      →  null when s is null, uppercase otherwise
/// ??= (null-aware assignment) — assigns only if the variable is currently null:
///         value ??= 0;          →  sets value to 0 only when value == null

void main() {
  _exercise1_nullableTypes();
  _exercise2_nullAwareOperators();
  _exercise3_lateVariables();
  _exercise4_patternMatching();
  print('\n🏁 All exercises passed!');
}

// ─── Exercise 1: Nullable Types ───────────────────────────────────────────────
void _exercise1_nullableTypes() {
  // TODO: Declare a nullable String `maybeNull` and assign null to it
  String? maybeNull = 'REPLACE_ME'; // hint: this should be null

  // TODO: Declare a non-nullable String `definitelyHello` = "hello"
  String definitelyHello = 'REPLACE_ME';

  // TODO: Use the null assertion operator (!) to get the length of maybeNull
  // Only valid because we know at this point it's not null after the check below.
  // First assign a value to maybeNull so it's safe to force-unwrap:
  maybeNull = 'dart';
  final len = 0; // replace: use maybeNull!.length

  assert(maybeNull == null || maybeNull == 'dart', '❌ Ex1: maybeNull should be "dart" after reassign');
  assert(definitelyHello == 'hello', '❌ Ex1: definitelyHello should be "hello"');
  assert(len == 4, '❌ Ex1: len should be 4 (length of "dart")');
  print('✅ Exercise 1: Nullable Types');
}

// ─── Exercise 2: Null-Aware Operators ─────────────────────────────────────────
// TODO: Implement `defaultName`
// Return `name` if it's not null, otherwise return "Anonymous"
// Use the ?? operator (do NOT use if/else)
String defaultName(String? name) {
  return 'REPLACE_ME';
}

// TODO: Implement `upperOrNull`
// Return the uppercase version of s if s is not null, otherwise return null
// Use the ?. operator
String? upperOrNull(String? s) {
  return null; // replace
}

// TODO: Implement `ensurePositive`
// If `value` is null, assign 0 to it. Use ??= operator.
// Return the value after the assignment.
int ensurePositive(int? value) {
  // value ??= ???;
  return value ?? -999; // replace this line
}

void _exercise2_nullAwareOperators() {
  assert(defaultName(null) == 'Anonymous', '❌ Ex2: null → "Anonymous"');
  assert(defaultName('Van') == 'Van', '❌ Ex2: "Van" → "Van"');
  assert(upperOrNull(null) == null, '❌ Ex2: upperOrNull(null) → null');
  assert(upperOrNull('hello') == 'HELLO', '❌ Ex2: upperOrNull("hello") → "HELLO"');
  assert(ensurePositive(null) == 0, '❌ Ex2: ensurePositive(null) → 0');
  assert(ensurePositive(5) == 5, '❌ Ex2: ensurePositive(5) → 5');
  print('✅ Exercise 2: Null-Aware Operators');
}

// ─── Exercise 3: late Variables ───────────────────────────────────────────────
// `late` tells Dart: "I promise this will be set before first use"
// Useful for: dependency injection, heavy initialization, circular refs

class DatabaseConnection {
  // TODO: Declare a late String `connectionString`
  // It will be set by `initialize()` before any reads happen
  late String connectionString; // this one is done — observe the pattern

  late int _port; // TODO: also declare a late int `_port`

  void initialize(String host, int port) {
    // TODO: assign connectionString = "postgresql://<host>:<port>"
    connectionString = 'REPLACE_ME';
    _port = port;
  }

  int get port => _port;
}

void _exercise3_lateVariables() {
  final db = DatabaseConnection();
  db.initialize('localhost', 5432);

  assert(db.connectionString == 'postgresql://localhost:5432',
      '❌ Ex3: connectionString mismatch, got: ${db.connectionString}');
  assert(db.port == 5432, '❌ Ex3: port should be 5432');
  print('✅ Exercise 3: late Variables');
}

// ─── Exercise 4: Null Safety + Pattern Matching ───────────────────────────────
// Dart 3 introduced pattern matching. Combined with null safety it's powerful.

// TODO: Implement `describeLength`
// Given a nullable string, return:
//   "no string"  if null
//   "empty"      if length == 0
//   "short"      if length <= 5
//   "long"       otherwise
// Use a switch expression (Dart 3+) or if/else
String describeLength(String? s) {
  return 'REPLACE_ME';
}

void _exercise4_patternMatching() {
  assert(describeLength(null) == 'no string', '❌ Ex4: null → "no string"');
  assert(describeLength('') == 'empty', '❌ Ex4: "" → "empty"');
  assert(describeLength('hi') == 'short', '❌ Ex4: "hi" → "short"');
  assert(describeLength('flutter') == 'long', '❌ Ex4: "flutter" → "long"');
  print('✅ Exercise 4: Null Safety + Pattern Matching');
}
