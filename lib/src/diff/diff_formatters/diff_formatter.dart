import '../diff_result.dart';

/// Interface for state difference formatters.
abstract class DiffFormatter {
  /// Formats a [DiffResult] into a human-readable string.
  String format(DiffResult result);
}
