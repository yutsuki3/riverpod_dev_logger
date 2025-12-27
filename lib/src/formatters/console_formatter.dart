import '../core/log_event.dart';
import 'formatter.dart';

/// A formatter that outputs logs in a structured console format with provider information.
class ConsoleFormatter implements LogFormatter {
  /// Formats the [event] into a list of strings ready for console output.
  @override
  List<String> format(LogEvent event) {
    final level = event.level.name.toUpperCase();
    String provider = event.context?.providerName ?? 'unknown';

    // Fallback to extra if context is missing
    if (provider == 'unknown' && event.extra != null) {
      provider = event.extra!['provider']?.toString() ?? 'unknown';
    }

    final deps = event.context?.dependencies?.join(', ') ?? 'none';

    final buffer = <String>[];
    buffer.add(
        '[$level] [Provider:$provider] [Dependencies:$deps] ${event.message}');

    if (event.extra != null && event.extra!.isNotEmpty) {
      buffer.add('  Extra: ${event.extra}');
    }

    if (event.error != null) {
      buffer.add('  Error: ${event.error}');
    }
    if (event.stackTrace != null) {
      buffer.add('  StackTrace:\n${event.stackTrace}');
    }

    return buffer;
  }
}
