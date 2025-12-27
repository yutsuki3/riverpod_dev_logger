import 'package:test/test.dart';
import 'package:riverpod_dev_logger/src/diff/diff_engine.dart';

void main() {
  late DiffEngine engine;

  setUp(() {
    engine = DiffEngine();
  });

  group('Primitive Diff', () {
    test('detects string change', () {
      final diff = engine.diff('old', 'new');
      expect(diff.hasChanges, isTrue);
      expect(diff.changes.length, 1);
      expect(diff.changes.first.oldValue, 'old');
      expect(diff.changes.first.newValue, 'new');
    });

    test('detects int change', () {
      final diff = engine.diff(1, 2);
      expect(diff.changes.first.oldValue, 1);
      expect(diff.changes.first.newValue, 2);
    });

    test('detects bool change', () {
      final diff = engine.diff(true, false);
      expect(diff.changes.first.oldValue, true);
      expect(diff.changes.first.newValue, false);
    });

    test('no change for identical values', () {
      final diff = engine.diff('same', 'same');
      expect(diff.hasChanges, isFalse);
    });
  });

  group('Collection Diff', () {
    test('detects list addition', () {
      final diff = engine.diff([1, 2], [1, 2, 3]);
      expect(diff.added, contains('[2]'));
    });

    test('detects list removal', () {
      final diff = engine.diff([1, 2], [1]);
      expect(diff.removed, contains('[1]'));
    });

    test('detects map addition', () {
      final diff = engine.diff({'a': 1}, {'a': 1, 'b': 2});
      expect(diff.added, contains('b'));
    });

    test('detects map change', () {
      final diff = engine.diff({'a': 1}, {'a': 2});
      expect(diff.changes.first.key, 'a');
      expect(diff.changes.first.oldValue, 1);
      expect(diff.changes.first.newValue, 2);
    });

    test('detects set addition', () {
      final diff = engine.diff({1, 2}, {1, 2, 3});
      expect(diff.added, contains('{3}'));
    });
  });

  group('Nested Object Diff', () {
    test('detects changes in nested map', () {
      final diff = engine.diff(
        {'user': {'name': 'Alice', 'age': 30}},
        {'user': {'name': 'Alice', 'age': 31}},
      );
      expect(diff.changes.first.key, 'user.age');
      expect(diff.changes.first.oldValue, 30);
      expect(diff.changes.first.newValue, 31);
    });
  });

  group('Custom Object Diff (toJson)', () {
    test('diffs objects with toJson', () {
      final obj1 = MockUser('Alice', 30);
      final obj2 = MockUser('Alice', 31);
      final diff = engine.diff(obj1, obj2);
      expect(diff.changes.first.key, 'age');
      expect(diff.changes.first.oldValue, 30);
      expect(diff.changes.first.newValue, 31);
    });
  });

  group('Performance', () {
    test('handles large lists', () {
      final large1 = List.generate(1000, (i) => i);
      final large2 = List.generate(1001, (i) => i);
      final stopwatch = Stopwatch()..start();
      engine.diff(large1, large2);
      stopwatch.stop();
      print('Diff large list (1000 items) took: ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds, lessThan(100)); // Should be fast
    });
  });
}

class MockUser {
  final String name;
  final int age;
  MockUser(this.name, this.age);

  Map<String, dynamic> toJson() => {'name': name, 'age': age};
}
