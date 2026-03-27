# 🎯 Dart Tour

> An interactive, exercise-driven Dart playground — like [Go Tour](https://go.dev/tour/) but as runnable files you edit and execute locally.

---

## How to Use

Each exercise is a standalone `main.dart` file. Read the instructions at the top, fill in the `TODO` sections, then run it:

```bash
dart run --enable-asserts 01_basics/main.dart
```

When it prints ✅, you got it. Peek at `solutions/` only after you've tried.

```
dart_tour/
├── 01_basics/          → Variables, types, null safety, functions
├── 02_null_safety/     → ?, !, late, null-aware operators
├── 03_collections/     → List, Map, Set, Iterable, spread, if/for in literals
├── 04_async_await/     → Future, async/await, error handling
├── 05_streams/         → Stream, StreamController, broadcast streams
├── 06_oop/             → Classes, mixins, extensions, interfaces
├── 07_functional/      → map, filter, reduce, closures, higher-order functions
└── solutions/          → Reference implementations (no peeking!)
```

---

## Running All Exercises

```bash
# Run a specific exercise
dart run 01_basics/main.dart

# Check a solution
dart run solutions/01_basics.dart
```

---

## Dart vs Your Language (Quick Map)

| Dart | Go | Java/Kotlin | Python |
|------|-----|-------------|--------|
| `Future<T>` | `chan T` / goroutine | `CompletableFuture<T>` | `asyncio.Future` |
| `Stream<T>` | `chan T` (multi-read) | `Observable<T>` | `AsyncGenerator` |
| `late` | zero value | (no equivalent) | (no equivalent) |
| `?` nullable type | `*T` pointer | `T?` (Kotlin) | `Optional[T]` |
| mixin | embedded struct | interface default | (no equiv) |
| extension | (no equiv) | extension function (Kotlin) | monkey patch |
| `isolate` | goroutine | `Thread` | `Process` |
