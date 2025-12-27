import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_dev_logger/riverpod_dev_logger.dart';

class MockLogger extends Mock implements Logger {}

void main() {
  group('RiverpodLoggerObserver', () {
    late MockLogger mockLogger;
    late RiverpodLoggerObserver observer;

    setUp(() {
      mockLogger = MockLogger();
      observer = RiverpodLoggerObserver(logger: mockLogger);
    });

    test('logs when provider is added', () {
      final container = ProviderContainer(observers: [observer]);
      final provider = Provider((ref) => 'Hello');

      container.read(provider);

      verify(() => mockLogger.debug(any(that: contains('Provider initialized')))).called(1);
    });

    test('logs when provider is updated', () {
      final container = ProviderContainer(observers: [observer]);
      final provider = StateProvider((ref) => 0);

      container.read(provider.notifier).state = 1;

      verify(() => mockLogger.debug(any(that: contains('Provider updated')))).called(1);
    });

    test('logs when provider fails', () {
      final container = ProviderContainer(observers: [observer]);
      final provider = Provider<String>((ref) => throw Exception('error'));

      try {
        container.read(provider);
      } catch (_) {}

      verify(() => mockLogger.error(any(), error: any(named: 'error'), stackTrace: any(named: 'stackTrace'))).called(1);
    });
  });
}
