/// 🎯 Dart Tour — 04: Async / Await
///
/// Topics: Future, async/await, Future.wait, Future.delayed,
///         error handling with try/catch, then/catchError chaining,
///         FutureOr.
///
/// 💡 Backend Lens:
///   Future<T>  ≈  Promise<T> (JS) / CompletableFuture<T> (Java) / chan T (Go)
///   async/await is identical in concept to JS/Python async/await
///
/// Run: dart run --enable-asserts 04_async_await/main.dart

import 'dart:async';

void main() async {
  await _exercise1_basicFuture();
  await _exercise2_errorHandling();
  await _exercise3_parallelFutures();
  await _exercise4_futureChaining();
  print('\n🏁 All exercises passed!');
}

// ─── Exercise 1: Basic Future & async/await ───────────────────────────────────
// Simulate fetching a user from a "database" (with 50ms delay)
Future<String> fetchUser(int id) async {
  await Future.delayed(const Duration(milliseconds: 50));
  if (id == 1) return 'Alice';
  if (id == 2) return 'Bob';
  throw Exception('User $id not found');
}

Future<void> _exercise1_basicFuture() async {
  // TODO: Await fetchUser(1) and store in `user`
  final user = await fetchUser(1); // replace — use await
  
  // TODO: Await fetchUser(2) and store in `user2`
  final user2 = await fetchUser(2); // replace

  assert(user == 'Alice', '❌ Ex1: user should be "Alice"');
  assert(user2 == 'Bob', '❌ Ex1: user2 should be "Bob"');
  print('✅ Exercise 1: Basic Future');
}

// ─── Exercise 2: Error Handling ───────────────────────────────────────────────
Future<void> _exercise2_errorHandling() async {
  // TODO: Call fetchUser(99) (which throws), catch the exception,
  // and store the error message in `errorMsg`.
  // Use try/catch.
  String errorMsg = '';
  try {
    await fetchUser(99);
  } catch (e) {
    errorMsg = e.toString();
  }

  // TODO: Use Future.catchError style (chaining) to get the same result
  final errorMsg2 = await fetchUser(99)
      .then((v) => '')
      .catchError((e) => e.toString()); // return e.toString()

  assert(errorMsg.contains('99'),
      '❌ Ex2: errorMsg should contain "99" — did you uncomment and fill the try/catch?');
  assert(errorMsg2.contains('99') && errorMsg == errorMsg2,
      '❌ Ex2: errorMsg2 should equal errorMsg — both approaches must produce the same result');
  print('✅ Exercise 2: Error Handling');
}

// ─── Exercise 3: Parallel Futures ─────────────────────────────────────────────
Future<String> fetchPost(int id) async {
  await Future.delayed(Duration(milliseconds: 30 + id * 10));
  return 'Post #$id';
}

Future<void> _exercise3_parallelFutures() async {
  final stopwatch = Stopwatch()..start();

  // TODO: Fetch posts 1, 2, and 3 IN PARALLEL using Future.wait
  // (NOT three separate awaits — that would be sequential)
  final results = await Future.wait([fetchPost(1), fetchPost(2), fetchPost(3)]); // replace with await Future.wait([...])

  stopwatch.stop();

  // All three should complete in ~60ms (max delay), not 30+40+50=120ms
  // We allow 200ms for test environment overhead
  assert(results.length == 3, '❌ Ex3: should have 3 results');
  assert(results.contains('Post #1'), '❌ Ex3: should contain Post #1');
  assert(stopwatch.elapsedMilliseconds < 200,
      '❌ Ex3: parallel fetch should be faster than sequential (took ${stopwatch.elapsedMilliseconds}ms)');
  print('✅ Exercise 3: Parallel Futures (${stopwatch.elapsedMilliseconds}ms)');
}

// ─── Exercise 4: FutureOr and Chaining ───────────────────────────────────────
// FutureOr<T> means: "either a T or a Future<T>" — useful for sync/async APIs

// TODO: Implement `getDisplayName`
// - Fetch user with fetchUser(id)
// - Transform to uppercase
// - Return the uppercase name
// Use .then() chaining (no async/await allowed here, practice the .then style)
Future<String> getDisplayName(int id) {
  return fetchUser(id).then((name) => name.toUpperCase()); // transform name to uppercase
}

Future<void> _exercise4_futureChaining() async {
  final name = await getDisplayName(1);
  assert(name == 'ALICE', '❌ Ex4: getDisplayName(1) should return "ALICE"');
  print('✅ Exercise 4: Future Chaining');
}
