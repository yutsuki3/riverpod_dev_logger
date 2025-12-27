/// Represents the result of a state difference calculation.
class DiffResult {
  /// List of modified fields and their values.
  final List<FieldChange> changes;

  /// Keys of fields that were added.
  final List<String> added;

  /// Keys of fields that were removed.
  final List<String> removed;

  /// Creates a [DiffResult].
  DiffResult({
    this.changes = const [],
    this.added = const [],
    this.removed = const [],
  });

  /// Returns true if there are any additions, removals, or changes.
  bool get hasChanges =>
      changes.isNotEmpty || added.isNotEmpty || removed.isNotEmpty;
}

/// Represents a change in a specific field.
class FieldChange {
  /// The path or key of the changed field.
  final String key;

  /// The value before the change.
  final Object? oldValue;

  /// The value after the change.
  final Object? newValue;

  /// Creates a [FieldChange].
  FieldChange({
    required this.key,
    required this.oldValue,
    required this.newValue,
  });
}
