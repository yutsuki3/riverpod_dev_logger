import 'log_level.dart';
import 'log_event.dart';
import '../context/context_detector.dart';
import '../formatters/formatter.dart';
import '../formatters/console_formatter.dart';

/// A developer-focused logger for Riverpod with automatic context detection.
class RiverpodDevLogger {
  final Map<String, dynamic>? _extra;

  RiverpodDevLogger._([this._extra]);

  /// Creates a [RiverpodDevLogger].
  factory RiverpodDevLogger() => RiverpodDevLogger._();

  static LogLevel _level = LogLevel.info;
  static LogFormatter _formatter = ConsoleFormatter();
  static bool _enableContextDetection = true;
  static bool _enableStateDiff = true;

  /// Configures the global logging settings.
  static void configure({
    LogLevel? level,
    LogFormatter? formatter,
    bool? enableContextDetection,
    bool? enableStateDiff,
  }) {
    if (level != null) {
      _level = level;
    }
    if (formatter != null) {
      _formatter = formatter;
    }
    if (enableContextDetection != null) {
      _enableContextDetection = enableContextDetection;
    }
    if (enableStateDiff != null) {
      _enableStateDiff = enableStateDiff;
    }
  }

  /// Whether state diff tracking is enabled globally.
  bool get isStateDiffEnabled => _enableStateDiff;

  /// Logs a [message] at the debug level.
  void debug(String message) => _log(LogLevel.debug, message);

  /// Logs a [message] at the info level.
  void info(String message) => _log(LogLevel.info, message);

  /// Logs a [message] at the warning level.
  void warning(String message) => _log(LogLevel.warning, message);

  /// Logs a [message] at the error level with optional [error] and [stackTrace].
  void error(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.error, message, error: error, stackTrace: stackTrace);

  /// Creates a child logger with additional [userId], [sessionId], or [extra] metadata.
  RiverpodDevLogger bind({
    String? userId,
    String? sessionId,
    Map<String, dynamic>? extra,
  }) {
    final newExtra = <String, dynamic>{
      if (_extra != null) ..._extra!,
      if (userId != null) 'userId': userId,
      if (sessionId != null) 'sessionId': sessionId,
      if (extra != null) ...extra,
    };
    return RiverpodDevLogger._(newExtra);
  }

  void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < _level.index) {
      return;
    }

    final context =
        _enableContextDetection ? ContextDetector.currentContext : null;
    final event = LogEvent(
      level: level,
      message: message,
      error: error,
      stackTrace: stackTrace,
      context: context,
      extra: _extra,
    );

    _formatter.format(event).forEach(print);
  }
}
