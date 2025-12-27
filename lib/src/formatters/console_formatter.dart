import '../core/log_event.dart';
import '../core/log_level.dart';
import 'formatter.dart';

class ConsoleFormatter implements LogFormatter {
  @override
  List<String> format(LogEvent event, {List<String> tags = const []}) {
    final buffer = <String>[];
    final levelStr = event.level.name.toUpperCase().padRight(7);
    final timeStr = event.time.toIso8601String().split('T').last.substring(0, 12);
    
    final tagStr = tags.isEmpty ? '' : '[${tags.join(' > ')}] ';
    final contextStr = event.context != null 
        ? ' (in ${event.context!.providerName}${event.context!.mutation != null ? ' | mutation: ${event.context!.mutation}' : ''})' 
        : '';

    buffer.add('[$timeStr] $levelStr $tagStr${event.message}$contextStr');

    if (event.error != null) {
      buffer.add('Error: ${event.error}');
    }

    if (event.stackTrace != null) {
      buffer.add('StackTrace:\n${event.stackTrace}');
    }

    return buffer;
  }
}
