import 'log_level.dart';
import '../context/provider_context.dart';

/// Represents a single log entry.
class LogEvent {
  /// The severity [LogLevel] of the event.
  final LogLevel level;

  /// The log message.
  final String message;

  /// An optional error object.
  final Object? error;

  /// An optional stack trace.
  final StackTrace? stackTrace;

  /// The [ProviderContext] captured at the time of logging.
  final ProviderContext? context;

  /// Additional structured metadata.
  final Map<String, dynamic>? extra;

  /// The timestamp when the event occurred.
  final DateTime time;

  /// Creates a [LogEvent].
  LogEvent({
    required this.level,
    required this.message,
    this.error,
    this.stackTrace,
    this.context,
    this.extra,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}
