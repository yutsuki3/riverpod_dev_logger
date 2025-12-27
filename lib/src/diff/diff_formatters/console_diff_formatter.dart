import '../diff_result.dart';
import 'diff_formatter.dart';

/// A formatter that outputs state differences in a human-readable console format.
class ConsoleDiffFormatter implements DiffFormatter {
  /// Formats the [result] into a structured string showing additions, removals, and changes.
  @override
  String format(DiffResult result) {
    if (!result.hasChanges) return 'No changes detected.';

    final buffer = StringBuffer();
    buffer.writeln('State changed:');

    for (final change in result.changes) {
      final key = change.key.isEmpty ? 'state' : change.key;

      if (result.added.contains(change.key)) {
        buffer.writeln('  + $key: ${change.newValue}');
      } else if (result.removed.contains(change.key)) {
        buffer.writeln('  - $key: ${change.oldValue}');
      } else {
        buffer.writeln('  ~ $key: ${change.oldValue} → ${change.newValue}');
      }
    }

    return buffer.toString().trimRight();
  }
}
