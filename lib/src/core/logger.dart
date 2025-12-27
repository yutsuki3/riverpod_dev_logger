import 'dart:async';
import 'log_event.dart';
import 'log_level.dart';
import '../context/context_detector.dart';
import '../formatters/formatter.dart';
import '../formatters/console_formatter.dart';

class Logger {
  final LogFormatter _formatter;
  final List<String> _tags;

  Logger({
    LogFormatter? formatter,
    List<String> tags = const [],
  })  : _formatter = formatter ?? ConsoleFormatter(),
        _tags = tags;

  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, error: error, stackTrace: stackTrace);
  }

  void info(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, error: error, stackTrace: stackTrace);
  }

  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, error: error, stackTrace: stackTrace);
  }

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }

  void fatal(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.fatal, message, error: error, stackTrace: stackTrace);
  }

  void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final context = ContextDetector.currentContext;
    final event = LogEvent(
      level: level,
      message: message,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
    
    final formatted = _formatter.format(event, tags: _tags);
    for (final line in formatted) {
      // For now, just print to console. 
      // In a real package, we might want to support multiple outputs.
      print(line);
    }
  }

  Logger child(String tag) {
    return Logger(
      formatter: _formatter,
      tags: [..._tags, tag],
    );
  }
}
