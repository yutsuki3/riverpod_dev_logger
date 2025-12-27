import '../core/log_event.dart';

abstract class LogFormatter {
  List<String> format(LogEvent event, {List<String> tags = const []});
}
