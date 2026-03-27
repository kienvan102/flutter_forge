/// Solutions — 01: Basics (only peek after trying!)

void main() {
  _exercise1_variables();
  _exercise2_functions();
  _exercise3_strings();
  _exercise4_controlFlow();
  print('\n🏁 All exercises passed!');
}

void _exercise1_variables() {
  var name = 'Flutter';
  final version = 3.22;
  const maxRetries = 3;

  assert(name == 'Flutter');
  assert(version == 3.22);
  assert(maxRetries == 3);
  print('✅ Exercise 1: Variables');
}

int add(int a, int b) => a + b;
String greet(String name) => 'Hello, $name!';
String repeat(String s, {int times = 2}) => s * times;

void _exercise2_functions() {
  assert(add(3, 4) == 7);
  assert(greet('Van') == 'Hello, Van!');
  assert(repeat('hi') == 'hihi');
  assert(repeat('go', times: 3) == 'gogogo');
  print('✅ Exercise 2: Functions');
}

void _exercise3_strings() {
  const lang = 'Dart';
  const year = 2011;
  final sentence = '$lang was created in $year';
  final multiLine = 'Hello\nWorld';

  assert(sentence == 'Dart was created in 2011');
  assert(multiLine.split('\n').length == 2);
  print('✅ Exercise 3: Strings');
}

String classify(int n) => switch (n) {
      < 0 => 'negative',
      0 => 'zero',
      <= 9 => 'small',
      _ => 'big',
    };

void _exercise4_controlFlow() {
  assert(classify(-5) == 'negative');
  assert(classify(0) == 'zero');
  assert(classify(7) == 'small');
  assert(classify(42) == 'big');
  print('✅ Exercise 4: Control Flow');
}
