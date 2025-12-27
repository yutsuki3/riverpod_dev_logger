import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_dev_logger/riverpod_dev_logger.dart';

class MockFormatter extends Mock implements LogFormatter {}

void main() {
  group('Logger', () {
    late Logger logger;
    late MockFormatter mockFormatter;

    setUp(() {
      mockFormatter = MockFormatter();
      logger = Logger(formatter: mockFormatter);
      
      registerFallbackValue(LogEvent(level: LogLevel.info, message: ''));
    });

    test('logs message with correct level', () {
      when(() => mockFormatter.format(any(), tags: any(named: 'tags')))
          .thenReturn(['Log line']);

      logger.info('Test message');

      verify(() => mockFormatter.format(
            any(that: predicate<LogEvent>((e) => e.level == LogLevel.info && e.message == 'Test message')),
            tags: [],
          )).called(1);
    });

    test('child logger adds tags', () {
      when(() => mockFormatter.format(any(), tags: any(named: 'tags')))
          .thenReturn(['Log line']);

      final childLogger = logger.child('Child');
      childLogger.debug('Child message');

      verify(() => mockFormatter.format(
            any(that: predicate<LogEvent>((e) => e.level == LogLevel.debug && e.message == 'Child message')),
            tags: ['Child'],
          )).called(1);
    });
  });
}
