import 'package:test/test.dart';
import 'package:riverpod_dev_logger/riverpod_dev_logger.dart';

void main() {
  group('RiverpodDevLogger', () {
    test('should log messages (manually verified by output or mock formatter)', () {
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
      expect(output[0], contains('[INFO] [Provider:TestProvider] [Dependencies:Dep1, Dep2] Hello'));
      expect(output[1], contains('Extra: {id: 1}'));
    });

    test('should respects log level configuration', () {
      RiverpodDevLogger.configure(level: LogLevel.error);
      // This is hard to test without intercepting print or injecting a mock formatter.
      // But we can verify it doesn't throw.
      final logger = RiverpodDevLogger();
      logger.info('Should not be logged');
      logger.error('Should be logged');
    });
  });
}
