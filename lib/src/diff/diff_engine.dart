import 'diff_result.dart';

/// An engine that calculates differences between two objects, supporting primitives and collections.
class DiffEngine {
  /// Compares [previous] and [next] and returns a [DiffResult] containing the changes.
  DiffResult diff(Object? previous, Object? next) {
    if (identical(previous, next)) {
      return DiffResult();
    }

    final changes = <FieldChange>[];
    final added = <String>[];
    final removed = <String>[];

    _compare(previous, next, '', changes, added, removed);

    return DiffResult(
      changes: changes,
      added: added,
      removed: removed,
    );
  }

  void _compare(
    Object? prev,
    Object? next,
    String path,
    List<FieldChange> changes,
    List<String> added,
    List<String> removed,
  ) {
    if (prev == next) return;

    if (prev is Map && next is Map) {
      _compareMaps(prev, next, path, changes, added, removed);
    } else if (prev is List && next is List) {
      _compareLists(prev, next, path, changes, added, removed);
    } else if (prev is Set && next is Set) {
      _compareSets(prev, next, path, changes, added, removed);
    } else {
      // Handle custom objects by attempting to convert to Map via toJson
      final prevMap = _tryToMap(prev);
      final nextMap = _tryToMap(next);

      if (prevMap != null && nextMap != null) {
        _compareMaps(prevMap, nextMap, path, changes, added, removed);
      } else {
        // Fallback to direct comparison or primitive comparison
        changes.add(FieldChange(key: path, oldValue: prev, newValue: next));
      }
    }
  }

  void _compareMaps(
    Map prev,
    Map next,
    String path,
    List<FieldChange> changes,
    List<String> added,
    List<String> removed,
  ) {
    final allKeys = {...prev.keys, ...next.keys};

    for (final key in allKeys) {
      final currentPath = path.isEmpty ? '$key' : '$path.$key';
      final prevValue = prev[key];
      final nextValue = next[key];

      if (!prev.containsKey(key)) {
        added.add(currentPath);
        changes.add(
            FieldChange(key: currentPath, oldValue: null, newValue: nextValue));
      } else if (!next.containsKey(key)) {
        removed.add(currentPath);
        changes.add(
            FieldChange(key: currentPath, oldValue: prevValue, newValue: null));
      } else {
        _compare(prevValue, nextValue, currentPath, changes, added, removed);
      }
    }
  }

  void _compareLists(
    List prev,
    List next,
    String path,
    List<FieldChange> changes,
    List<String> added,
    List<String> removed,
  ) {
    final maxLength = prev.length > next.length ? prev.length : next.length;

    for (var i = 0; i < maxLength; i++) {
      final currentPath = '$path[$i]';
      if (i >= prev.length) {
        added.add(currentPath);
        changes.add(
            FieldChange(key: currentPath, oldValue: null, newValue: next[i]));
      } else if (i >= next.length) {
        removed.add(currentPath);
        changes.add(
            FieldChange(key: currentPath, oldValue: prev[i], newValue: null));
      } else {
        _compare(prev[i], next[i], currentPath, changes, added, removed);
      }
    }
  }

  void _compareSets(
    Set prev,
    Set next,
    String path,
    List<FieldChange> changes,
    List<String> added,
    List<String> removed,
  ) {
    final removedItems = prev.difference(next);
    final addedItems = next.difference(prev);

    for (final item in removedItems) {
      removed.add('$path{$item}');
      changes.add(
          FieldChange(key: '$path{$item}', oldValue: item, newValue: null));
    }
    for (final item in addedItems) {
      added.add('$path{$item}');
      changes.add(
          FieldChange(key: '$path{$item}', oldValue: null, newValue: item));
    }
  }

  Map? _tryToMap(Object? obj) {
    if (obj == null) return null;
    if (obj is Map) return obj;

    try {
      // Many Dart objects (Freezed, json_serializable) have a toJson method
      final dynamic dynamicObj = obj;
      final result = dynamicObj.toJson();
      if (result is Map) {
        return result;
      }
    } catch (_) {
      // toJson not available or didn't return a Map
    }
    return null;
  }
}
