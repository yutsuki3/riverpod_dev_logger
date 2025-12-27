import 'dart:convert';
import '../diff_result.dart';
import 'diff_formatter.dart';

/// A formatter that outputs state differences in JSON format.
class JsonDiffFormatter implements DiffFormatter {
  /// Formats the [result] into a JSON string.
  @override
  String format(DiffResult result) {
    final map = {
      'hasChanges': result.hasChanges,
      'changes': result.changes
          .map((c) => {
                'key': c.key,
                'old': c.oldValue.toString(),
                'new': c.newValue.toString(),
              })
          .toList(),
      'added': result.added,
      'removed': result.removed,
    };

    return jsonEncode(map);
  }
}
