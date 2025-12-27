class DiffResult {
  final List<FieldChange> changes;
  final List<String> added;
  final List<String> removed;

  DiffResult({
    this.changes = const [],
    this.added = const [],
    this.removed = const [],
  });

  bool get hasChanges => changes.isNotEmpty || added.isNotEmpty || removed.isNotEmpty;
}

class FieldChange {
  final String key;
  final Object? oldValue;
  final Object? newValue;

  FieldChange({
    required this.key,
    required this.oldValue,
    required this.newValue,
  });
}
