import '../core/log_event.dart';

/// Interface for log formatters.
abstract class LogFormatter {
  /// Formats a [LogEvent] into a list of strings representing the log lines.
  List<String> format(LogEvent event);
}
