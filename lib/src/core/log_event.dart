import 'log_level.dart';
import '../context/provider_context.dart';

class LogEvent {
  final LogLevel level;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final ProviderContext? context;
  final DateTime time;

  LogEvent({
    required this.level,
    required this.message,
    this.error,
    this.stackTrace,
    this.context,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}
