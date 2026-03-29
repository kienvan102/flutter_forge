/// 🎯 Dart Tour — 07: Functional Dart
///
/// Topics: closures, first-class functions, higher-order functions,
///         Function typedef, currying, immutability patterns,
///         Iterable pipelines, Records (Dart 3).
///
/// Run: dart run --enable-asserts 07_functional/main.dart
///
/// ─── CONCEPTS ─────────────────────────────────────────────────────────────
/// First-class functions — functions are values in Dart:
///         stored in variables:  final fn = (x) => x * 2;
///         passed as arguments:  list.where(isEven)
///         returned from funcs:  return () => counter++;
///
/// Closure — a function that captures variables from its surrounding scope:
///         makeCounter creates a local variable `n`; the returned function
///         remembers and mutates `n` even after makeCounter has returned
///
/// Higher-order function — a function that takes or returns another function:
///         filterAndTransform(items, predicate, transform)
///
/// Function composition — combine two functions so one feeds the other:
///         compose(f, g)(x) = f(g(x))   →   g runs first, then f
///
/// typedef — type alias for a function signature; improves readability:
///         typedef Predicate<T> = bool Function(T);
///         typedef Transformer<T, R> = R Function(T);
///
/// fold — reduces a collection to a single value using an accumulator:
///         [1, 2, 3].fold(0, (acc, v) => acc + v)  →  6
///         accumulator starts at init, then acc = fn(acc, nextElement)
///
/// Records (Dart 3) — immutable, lightweight value types with named fields:
///         ({int quotient, int remainder}) r = (quotient: 3, remainder: 2);
///         access with r.quotient and r.remainder (no class definition needed)

void main() {
  _exercise1_closures();
  _exercise2_higherOrder();
  _exercise3_functionComposition();
  _exercise4_records();
  print('\n🏁 All exercises passed!');
}

// ─── Exercise 1: Closures ─────────────────────────────────────────────────────
// TODO: Implement `makeCounter`
// Returns a function that, each time it's called, returns an incrementing int
// starting from `start`.
// e.g., final count = makeCounter(0); count() → 1; count() → 2; count() → 3
Function makeCounter(int start) {
  // Hint: use a local variable captured by the closure
  return () => 0; // replace
}

// TODO: Implement `makeAdder`
// Returns a function that adds `n` to its argument
// e.g., final add5 = makeAdder(5); add5(3) → 8
int Function(int) makeAdder(int n) {
  return (x) => 0; // replace
}

void _exercise1_closures() {
  final counter = makeCounter(0);
  assert(counter() == 1, '❌ Ex1: first call should return 1');
  assert(counter() == 2, '❌ Ex1: second call should return 2');
  assert(counter() == 3, '❌ Ex1: third call should return 3');

  final add10 = makeAdder(10);
  assert(add10(5) == 15, '❌ Ex1: add10(5) should be 15');
  assert(add10(0) == 10, '❌ Ex1: add10(0) should be 10');

  print('✅ Exercise 1: Closures');
}

// ─── Exercise 2: Higher-Order Functions ──────────────────────────────────────
typedef Predicate<T> = bool Function(T);
typedef Transformer<T, R> = R Function(T);

// TODO: Implement `filterAndTransform<T, R>`
// Takes a list, a predicate, and a transformer.
// Returns a new list containing only items passing the predicate, transformed.
List<R> filterAndTransform<T, R>(
  List<T> items,
  Predicate<T> predicate,
  Transformer<T, R> transform,
) {
  return []; // replace
}

// TODO: Implement `pipeline<T>`
// Takes a value and a list of transformers, applying them left-to-right
// e.g., pipeline(5, [(x)=>x*2, (x)=>x+1]) → 11
T pipeline<T>(T initial, List<T Function(T)> transforms) {
  return initial; // replace — use fold
}

void _exercise2_higherOrder() {
  final numbers = [1, 2, 3, 4, 5, 6];

  // Filter evens and double them
  final result = filterAndTransform<int, int>(
    numbers,
    (n) => n.isEven,
    (n) => n * 2,
  );
  assert(result.length == 3, '❌ Ex2: should have 3 results (evens: 2,4,6)');
  assert(result[0] == 4, '❌ Ex2: first result should be 4 (2*2)');
  assert(result[2] == 12, '❌ Ex2: last result should be 12 (6*2)');

  final pipeResult = pipeline<int>(5, [(x) => x * 2, (x) => x + 1]);
  assert(pipeResult == 11, '❌ Ex2: pipeline(5, [*2, +1]) should be 11');

  print('✅ Exercise 2: Higher-Order Functions');
}

// ─── Exercise 3: Function Composition ────────────────────────────────────────
// TODO: Implement `compose<T>` — returns a single function that applies
// fn2 after fn1 (right-to-left: f∘g = f(g(x)))
T Function(T) compose<T>(T Function(T) fn1, T Function(T) fn2) {
  return (x) => x; // replace: return (x) => fn1(fn2(x))
}

String sanitize(String s) => s.trim().toLowerCase();
String exclaim(String s) => '$s!';

void _exercise3_functionComposition() {
  final sanitizeAndExclaim = compose(exclaim, sanitize);
  assert(
    sanitizeAndExclaim('  HELLO  ') == 'hello!',
    '❌ Ex3: should trim, lowercase, then add !',
  );
  print('✅ Exercise 3: Function Composition');
}

// ─── Exercise 4: Records (Dart 3) ─────────────────────────────────────────────
// Records = lightweight immutable value tuples with named fields
// Backend lens: like Go's multiple return values, but typed and named

// TODO: Implement `divmod`
// Returns a Record with named fields `quotient` and `remainder`
// e.g., divmod(17, 5) → (quotient: 3, remainder: 2)
({int quotient, int remainder}) divmod(int a, int b) {
  return (quotient: 0, remainder: 0); // replace
}

// TODO: Implement `parseToken`
// Given a JWT-like "header.payload.signature" string,
// return a record with fields: header, payload, signature (all Strings)
// If the format is invalid (not 3 parts), return ('', '', '')
({String header, String payload, String signature}) parseToken(String token) {
  return (header: '', payload: '', signature: ''); // replace
}

void _exercise4_records() {
  final r = divmod(17, 5);
  assert(r.quotient == 3, '❌ Ex4: quotient should be 3');
  assert(r.remainder == 2, '❌ Ex4: remainder should be 2');

  final parsed = parseToken('eyJh.eyJz.sig123');
  assert(parsed.header == 'eyJh', '❌ Ex4: header mismatch');
  assert(parsed.payload == 'eyJz', '❌ Ex4: payload mismatch');
  assert(parsed.signature == 'sig123', '❌ Ex4: signature mismatch');

  final invalid = parseToken('not-a-token');
  assert(invalid.header == '' && invalid.signature == '',
      '❌ Ex4: invalid token should return empty strings');

  print('✅ Exercise 4: Records');
}
