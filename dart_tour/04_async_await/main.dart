/// 🎯 Dart Tour — 04: Async / Await
///
/// Topics: Future, async/await, Future.wait, Future.delayed,
///         error handling with try/catch, then/catchError chaining,
///         FutureOr.
///
/// Run: dart run --enable-asserts 04_async_await/main.dart
///
/// ─── CONCEPTS ─────────────────────────────────────────────────────────────
/// async — marks a function as asynchronous; its return type becomes Future<T>
///         Future<String> fetchUser(int id) async { ... }
/// await — pauses the current function until the Future completes:
///         final user = await fetchUser(1);   // suspends here, then resumes
/// Future<T> — a value that is not yet available; resolves to T or throws
/// Future.delayed(duration) — a Future that completes after the given duration
///
/// Future.wait([f1, f2, f3]) — starts ALL Futures at once (parallel), returns
///         List<T> when ALL complete.  eagerError: true (default) throws on first
///         failure; eagerError: false waits for all and collects every error.
///
/// .then((value) => ...)    — callback executed when the Future succeeds
/// .catchError((e) => ...)  — callback executed when the Future throws
/// try { await f } catch(e) — preferred style; reads like synchronous code
///
/// FutureOr<T> — a type that accepts either T or Future<T>;
///         useful for writing APIs that work in both sync and async contexts

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
  final user = 'REPLACE_ME'; // replace — use await

  // TODO: Await fetchUser(2) and store in `user2`
  final user2 = 'REPLACE_ME'; // replace

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
  // try {
  //   await fetchUser(99);
  // } catch (e) {
  //   errorMsg = e.toString();
  // }

  // TODO: Use Future.catchError style (chaining) to get the same result
  final errorMsg2 = await fetchUser(99)
      .then((v) => '')
      .catchError((e) => 'REPLACE_ME'); // return e.toString()

  assert(errorMsg.contains('99'),
      '❌ Ex2: errorMsg should contain "99" — use try/catch to capture the error message');
  assert(errorMsg2.contains('99') && errorMsg == errorMsg2,
      '❌ Ex2: errorMsg2 should equal errorMsg — use .catchError((e) => e.toString())');
  // Lenient check — either approach works
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
  final results = <String>[]; // replace with await Future.wait([...])

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
  return fetchUser(id).then((name) => 'REPLACE_ME'); // transform name to uppercase
}

Future<void> _exercise4_futureChaining() async {
  final name = await getDisplayName(1);
  assert(name == 'ALICE', '❌ Ex4: getDisplayName(1) should return "ALICE"');
  print('✅ Exercise 4: Future Chaining');
}
