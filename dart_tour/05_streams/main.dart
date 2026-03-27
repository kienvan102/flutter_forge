/// 🎯 Dart Tour — 05: Streams
///
/// Topics: Stream, StreamController, broadcast streams,
///         await for, stream transformations (map, where, take),
///         StreamBuilder (conceptual preview for Flutter).
///
/// 💡 Backend Lens:
///   Stream<T>        ≈  Go channel (chan T) / RxJava Observable / Node.js Readable
///   StreamController ≈  channel producer / Subject (RxJava)
///   broadcast stream ≈  pub/sub topic (multiple listeners)
///
/// Run: dart run --enable-asserts 05_streams/main.dart

import 'dart:async';

void main() async {
  await _exercise1_basicStream();
  await _exercise2_streamController();
  await _exercise3_streamTransformations();
  await _exercise4_broadcastStream();
  print('\n🏁 All exercises passed!');
}

// ─── Exercise 1: Basic Stream Consumption ────────────────────────────────────
Stream<int> countStream(int max) async* {
  for (var i = 1; i <= max; i++) {
    await Future.delayed(const Duration(milliseconds: 10));
    yield i; // yield = "emit one value"
  }
}

Future<void> _exercise1_basicStream() async {
  final collected = <int>[];

  // TODO: Use `await for` to collect all values from countStream(5)
  // await for (final value in countStream(5)) { collected.add(value); }

  // TODO: Alternatively, use .toList() to collect all values
  // final collected = await countStream(5).toList();

  assert(collected.length == 5, '❌ Ex1: should collect 5 items');
  assert(collected.last == 5, '❌ Ex1: last item should be 5');
  print('✅ Exercise 1: Basic Stream');
}

// ─── Exercise 2: StreamController ────────────────────────────────────────────
Future<void> _exercise2_streamController() async {
  // TODO: Create a StreamController<String>
  final controller = StreamController<String>(); // done — observe

  final received = <String>[];

  // Listen to the stream and collect values
  final subscription = controller.stream.listen((event) {
    received.add(event);
  });

  // TODO: Add three events to the controller: "hello", "world", "dart"
  // controller.add(???);

  // TODO: Close the controller (signals end of stream)
  // await controller.close();

  await subscription.asFuture<void>().timeout(
    const Duration(seconds: 1),
    onTimeout: () {},
  );
  await subscription.cancel();

  assert(received.length == 3, '❌ Ex2: should receive 3 events, got ${received.length}');
  assert(received.contains('hello') && received.contains('dart'),
      '❌ Ex2: should contain hello, world, dart');
  print('✅ Exercise 2: StreamController');
}

// ─── Exercise 3: Stream Transformations ──────────────────────────────────────
Future<void> _exercise3_streamTransformations() async {
  final numbers = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

  // TODO: Get only even numbers from the stream (use .where)
  // Then square them (use .map)
  // Then take only the first 3 results (use .take)
  // Collect to list with .toList()
  final result = await numbers
      .where((n) => false) // replace: n.isEven
      .map((n) => n) // replace: n * n
      .take(0) // replace: 3
      .toList();

  // Expected: [4, 16, 36] (first 3 even numbers squared: 2²=4, 4²=16, 6²=36)
  assert(result.length == 3, '❌ Ex3: should have 3 results, got ${result.length}');
  assert(result[0] == 4, '❌ Ex3: result[0] should be 4 (2²)');
  assert(result[1] == 16, '❌ Ex3: result[1] should be 16 (4²)');
  assert(result[2] == 36, '❌ Ex3: result[2] should be 36 (6²)');
  print('✅ Exercise 3: Stream Transformations');
}

// ─── Exercise 4: Broadcast Stream (multiple listeners) ───────────────────────
Future<void> _exercise4_broadcastStream() async {
  // Regular streams allow only ONE listener.
  // Broadcast streams allow MANY listeners — like a pub/sub topic.

  // TODO: Create a StreamController that is a BROADCAST controller
  // Hint: StreamController<int>.broadcast()
  final controller = StreamController<int>(); // replace with broadcast

  final listener1 = <int>[];
  final listener2 = <int>[];

  // Two listeners on the same stream
  final sub1 = controller.stream.listen((v) => listener1.add(v));
  final sub2 = controller.stream.listen((v) => listener2.add(v));

  controller.add(1);
  controller.add(2);
  controller.add(3);
  await controller.close();

  await sub1.cancel();
  await sub2.cancel();

  // Both listeners should receive all values
  assert(listener1.length == 3, '❌ Ex4: listener1 should receive 3 events');
  assert(listener2.length == 3, '❌ Ex4: listener2 should receive 3 events');
  assert(listener1[2] == 3 && listener2[2] == 3, '❌ Ex4: last event should be 3');
  print('✅ Exercise 4: Broadcast Stream');
}
