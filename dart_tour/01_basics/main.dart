/// 🎯 Dart Tour — 01: Basics
///
/// Topics: var, final, const, type inference, string interpolation,
///         functions, arrow syntax, named/optional parameters.
///
/// Instructions: Fill in every section marked TODO, then run:
///   dart run --enable-asserts 01_basics/main.dart
///
/// Expected output: all lines print ✅

void main() {
  _exercise1_variables();
  _exercise2_functions();
  _exercise3_strings();
  _exercise4_controlFlow();
  print('\n🏁 All exercises passed!');
}

// ─── Exercise 1: Variables & Types ───────────────────────────────────────────
void _exercise1_variables() {
  // TODO: Declare a variable `name` using type inference (var) with value "Flutter"
  // var name = ???;
  var name = 'Flutter';

  // TODO: Declare a final variable `version` with value 3.22
  // final version = ???;
  final version = 3.22;

  // TODO: Declare a compile-time constant `maxRetries` = 3
  // const maxRetries = ???;
  const maxRetries = 3;

  // Assertions — do not modify
  assert(name == 'Flutter', '❌ Ex1: name should be "Flutter"');
  assert(version == 3.22, '❌ Ex1: version should be 3.22');
  assert(maxRetries == 3, '❌ Ex1: maxRetries should be 3');
  print('✅ Exercise 1: Variables');
}

// ─── Exercise 2: Functions ────────────────────────────────────────────────────
// TODO: Implement `add` — returns the sum of two integers
int add(int a, int b) {
  return a + b; // replace
}

// TODO: Implement `greet` using arrow syntax (=>)
// It should return "Hello, <name>!" — e.g., greet("Van") → "Hello, Van!"
String greet(String name) => 'Hello, $name!';

// TODO: Implement `repeat` with a named optional parameter `times` (default = 2)
// It should return the string repeated `times` times — e.g., repeat("hi") → "hihi"
String repeat(String s, {int times = 2}) {
  return s * times;
}

void _exercise2_functions() {
  assert(add(3, 4) == 7, '❌ Ex2: add(3,4) should be 7');
  assert(greet('Van') == 'Hello, Van!', '❌ Ex2: greet("Van") should be "Hello, Van!"');
  assert(repeat('hi') == 'hihi', '❌ Ex2: repeat("hi") should be "hihi"');
  assert(repeat('go', times: 3) == 'gogogo', '❌ Ex2: repeat("go", times:3) should be "gogogo"');
  print('✅ Exercise 2: Functions');
}

// ─── Exercise 3: String Interpolation ────────────────────────────────────────
void _exercise3_strings() {
  const lang = 'Dart';
  const year = 2011;

  // TODO: Use string interpolation to build:
  // "Dart was created in 2011"
  final sentence = '$lang was created in $year';  // replace

  // TODO: Use a multi-line string (triple-quote) to create exactly:
  // line1: "Hello"
  // line2: "World"
  final multiLine = '''Hello
World'''; // replace

  assert(sentence == 'Dart was created in 2011', '❌ Ex3: sentence mismatch');
  assert(multiLine.split('\n').length == 2, '❌ Ex3: multiLine should have 2 lines');
  assert(multiLine.contains('Hello') && multiLine.contains('World'),
      '❌ Ex3: multiLine should contain Hello and World');
  print('✅ Exercise 3: Strings');
}

// ─── Exercise 4: Control Flow ─────────────────────────────────────────────────
// TODO: Implement `classify` — returns:
//   "negative" if n < 0
//   "zero"     if n == 0
//   "small"    if 1 <= n <= 9
//   "big"      if n >= 10
String classify(int n) {
  if (n < 0) {
    return 'negative';
  } else if (n == 0) {
    return 'zero';
  } else if (n >= 1 && n <= 9) {
    return 'small';
  } else {
    return 'big';
  }
}

void _exercise4_controlFlow() {
  assert(classify(-5) == 'negative', '❌ Ex4: -5 → negative');
  assert(classify(0) == 'zero', '❌ Ex4: 0 → zero');
  assert(classify(7) == 'small', '❌ Ex4: 7 → small');
  assert(classify(42) == 'big', '❌ Ex4: 42 → big');
  print('✅ Exercise 4: Control Flow');
}
