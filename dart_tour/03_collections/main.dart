/// 🎯 Dart Tour — 03: Collections
///
/// Topics: List, Map, Set, Iterable, spread operator (...),
///         collection if, collection for, where/map/reduce/fold,
///         const collections.
///
/// Run: dart run --enable-asserts 03_collections/main.dart
///
/// ─── CONCEPTS ─────────────────────────────────────────────────────────────
/// List<T> — ordered sequence, duplicates allowed, index-based access
///   .add(v)           — append v to the end
///   .removeAt(i)      — remove element at index i (mutates the list)
///   .sort()           — sort in-place using natural ordering
///   .contains(v)      — true if v is in the list
///   .length           — number of elements
///
/// Map<K, V> — key-value pairs; each key is unique
///   map[key]          — lookup, returns null if key not found
///   map[key] ?? def   — lookup with a fallback default value
///   .entries          — Iterable<MapEntry<K, V>> for iteration
///   .keys / .values   — Iterable of all keys / all values
///
/// Set<T> — unordered collection, no duplicate elements
///   .union(other)        — all elements from both sets
///   .intersection(other) — only elements present in both sets
///   .difference(other)   — elements in this set but not in other
///
/// Iterable<T> — lazy sequence; methods return new Iterables (nothing runs until .toList())
///   .where((v) => cond)    — filter: keep only elements where cond is true
///   .map((v) => expr)      — transform: apply expr to every element
///   .fold(init, (acc, v))  — reduce to one value; init is the starting accumulator
///   .reduce((acc, v))      — like fold but uses first element as initial value
///   .any((v) => cond)      — true if at least one element matches cond
///   .every((v) => cond)    — true if ALL elements match cond
///   .firstWhere((v) => c)  — first matching element; throws StateError if none found
///   .toList()              — materialise the Iterable into a List<T>
///
/// Spread ...  — insert all elements of a collection inline:
///   [...list1, ...list2]
/// Collection if — conditionally include elements:
///   [if (cond) ...extra, ...base]
/// Collection for — generate elements with a loop:
///   [for (var i in [1, 2, 3]) 'item_$i']  →  ['item_1', 'item_2', 'item_3']

void main() {
  _exercise1_list();
  _exercise2_map();
  _exercise3_set();
  _exercise4_iterable();
  _exercise5_collectionLiterals();
  print('\n🏁 All exercises passed!');
}

// ─── Exercise 1: List ─────────────────────────────────────────────────────────
void _exercise1_list() {
  // TODO: Create a List<String> of 3 programming languages you know
  final languages = <String>[]; // replace

  // TODO: Add 'Dart' to the list (use .add)
  // languages.add(???);

  // TODO: Remove the first item from the list (use .removeAt)
  // languages.removeAt(???);

  // TODO: Sort the list alphabetically (in-place)
  // languages.sort();

  // For this exercise to pass:
  // - languages must have exactly 3 items
  // - 'Dart' must be in the list
  // - list must be sorted alphabetically
  assert(languages.length == 3, '❌ Ex1: list should have 3 items');
  assert(languages.contains('Dart'), '❌ Ex1: list should contain "Dart"');
  assert(languages.isSorted, '❌ Ex1: list should be sorted alphabetically');
  print('✅ Exercise 1: List');
}

// ─── Exercise 2: Map ──────────────────────────────────────────────────────────
void _exercise2_map() {
  // TODO: Create a Map<String, int> mapping language → year introduced
  // Include at least: 'Dart' → 2011, 'Go' → 2009, 'Kotlin' → 2011
  final Map<String, int> langYear = {}; // replace

  // TODO: Look up the year for 'Dart' and store in dartYear
  final dartYear = 0; // replace

  // TODO: Get the year for 'Rust', defaulting to -1 if not found (use ?? or putIfAbsent logic)
  final rustYear = 0; // replace — should be -1 since Rust isn't in the map

  // TODO: Get all languages released in or after 2010 (use entries + where)
  final modernLangs = <String>[]; // replace with a filtered list of keys

  assert(dartYear == 2011, '❌ Ex2: dartYear should be 2011');
  assert(rustYear == -1, '❌ Ex2: rustYear should be -1 (not in map)');
  assert(modernLangs.contains('Dart') && modernLangs.contains('Kotlin'),
      '❌ Ex2: modernLangs should include Dart and Kotlin');
  assert(!modernLangs.contains('Go'), '❌ Ex2: Go (2009) should NOT be in modernLangs');
  print('✅ Exercise 2: Map');
}

// ─── Exercise 3: Set ──────────────────────────────────────────────────────────
void _exercise3_set() {
  final a = {'flutter', 'dart', 'firebase'};
  final b = {'dart', 'firebase', 'supabase'};

  // TODO: Get the intersection of a and b (items in both)
  final intersection = <String>{}; // replace

  // TODO: Get the union of a and b (all items)
  final union = <String>{}; // replace

  // TODO: Get items in a but NOT in b (difference)
  final onlyInA = <String>{}; // replace

  assert(intersection.length == 2, '❌ Ex3: intersection should have 2 items');
  assert(intersection.containsAll(['dart', 'firebase']),
      '❌ Ex3: intersection should contain dart and firebase');
  assert(union.length == 4, '❌ Ex3: union should have 4 items');
  assert(onlyInA.length == 1 && onlyInA.contains('flutter'),
      '❌ Ex3: onlyInA should be {"flutter"}');
  print('✅ Exercise 3: Set');
}

// ─── Exercise 4: Iterable operations ─────────────────────────────────────────
void _exercise4_iterable() {
  final numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // TODO: Get all even numbers (use .where)
  final evens = <int>[]; // replace

  // TODO: Square each number (use .map), return a List<int>
  final squares = <int>[]; // replace

  // TODO: Sum all numbers (use .fold or .reduce)
  final sum = 0; // replace

  // TODO: Check if any number is greater than 9 (use .any)
  final hasLarge = false; // replace

  // TODO: Find the first number > 5 (use .firstWhere)
  final firstLarge = 0; // replace

  assert(evens.length == 5 && evens.every((n) => n.isEven),
      '❌ Ex4: evens should be [2,4,6,8,10]');
  assert(squares.length == 10 && squares[2] == 9,
      '❌ Ex4: squares[2] should be 9 (3²)');
  assert(sum == 55, '❌ Ex4: sum should be 55');
  assert(hasLarge == true, '❌ Ex4: hasLarge should be true');
  assert(firstLarge == 6, '❌ Ex4: firstLarge should be 6');
  print('✅ Exercise 4: Iterable');
}

// ─── Exercise 5: Collection Literals (spread, if, for) ───────────────────────
void _exercise5_collectionLiterals() {
  final base = [1, 2, 3];
  final extra = [4, 5];
  final includeExtra = true;

  // TODO: Use spread operator (...) to combine base and extra into one list
  final combined = <int>[]; // replace — use [...base, ...extra]

  // TODO: Use collection-if to conditionally include extra
  // If includeExtra is true, include extra, otherwise just base
  final conditional = <int>[]; // replace — use [if (includeExtra) ...extra, ...base]

  // TODO: Use collection-for to build ["item_1", "item_2", "item_3"]
  final items = <String>[]; // replace — use [for (var i in [1,2,3]) 'item_$i']

  assert(combined.length == 5, '❌ Ex5: combined should have 5 items');
  assert(conditional.length == 5, '❌ Ex5: conditional (includeExtra=true) should have 5 items');
  assert(items.length == 3 && items[1] == 'item_2',
      '❌ Ex5: items should be ["item_1","item_2","item_3"]');
  print('✅ Exercise 5: Collection Literals');
}

// ─── Helper ───────────────────────────────────────────────────────────────────
extension _SortedList on List<String> {
  bool get isSorted {
    for (var i = 0; i < length - 1; i++) {
      if (this[i].compareTo(this[i + 1]) > 0) return false;
    }
    return true;
  }
}
