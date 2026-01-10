import 'package:test/test.dart';
import 'package:riverpod_dev_logger/riverpod_dev_logger.dart';

void main() {
  group('RiverpodDevLogger', () {
    test('should log messages (manually verified by output or mock formatter)',
        () {
      final logger = RiverpodDevLogger();
      // This mainly checks for no crashes
      logger.debug('Debug message');
      logger.info('Info message');
      logger.warning('Warning message');
      logger.error('Error message', Exception('Test'), StackTrace.current);
    });

    test('formatting should match expected format', () {
      final formatter = ConsoleFormatter();
      const context = ProviderContext(
        providerName: 'TestProvider',
        providerType: 'String',
        dependencies: ['Dep1', 'Dep2'],
      );
      final event = LogEvent(
        level: LogLevel.info,
        message: 'Hello',
        context: context,
        extra: {'id': 1},
      );

      final output = formatter.format(event);
      expect(
          output[0],
          contains(
              '[INFO] [Provider:TestProvider] [Dependencies:Dep1, Dep2] Hello'));
      expect(output[1], contains('Extra: {id: 1}'));
    });

    test('should respect log level configuration', () {
      // Create a mock formatter that captures logged events
      final capturedEvents = <LogEvent>[];
      final mockFormatter = _MockFormatter(capturedEvents);

      RiverpodDevLogger.configure(
        level: LogLevel.error,
        formatter: mockFormatter,
      );

      final logger = RiverpodDevLogger();
      logger.debug('Should not be logged');
      logger.info('Should not be logged');
      logger.warning('Should not be logged');
      logger.error('Should be logged');

      // Verify only error level message was logged
      expect(capturedEvents.length, equals(1));
      expect(capturedEvents[0].level, equals(LogLevel.error));
      expect(capturedEvents[0].message, equals('Should be logged'));

      // Reset configuration
      RiverpodDevLogger.configure(level: LogLevel.debug);
    });
  });
}

/// Mock formatter that captures log events for testing.
class _MockFormatter implements LogFormatter {
  final List<LogEvent> capturedEvents;

  _MockFormatter(this.capturedEvents);

  @override
  List<String> format(LogEvent event) {
    capturedEvents.add(event);
    return ['Mock output: ${event.message}'];
  }
}
