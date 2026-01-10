import 'package:test/test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_dev_logger/riverpod_dev_logger.dart';

void main() {
  group('RiverpodLoggerObserver', () {
    test('should capture provider initialization', () {
      final capturedEvents = <LogEvent>[];
      final mockLogger = _MockLogger(capturedEvents);
      final observer = RiverpodLoggerObserver(logger: mockLogger);

      final container = ProviderContainer(
        observers: [observer],
      );
      addTearDown(container.dispose);

      final provider = StateProvider((ref) => 42);

      // Read provider to trigger initialization
      container.read(provider);

      // Verify initialization was logged
      expect(
        capturedEvents.any((e) =>
            e.level == LogLevel.debug &&
            e.message.contains('Provider initialized with: 42')),
        isTrue,
      );
    });

    test('should capture provider updates in observer logs', () {
      final capturedEvents = <LogEvent>[];
      final mockLogger = _MockLogger(capturedEvents);
      final observer = RiverpodLoggerObserver(logger: mockLogger);

      final container = ProviderContainer(
        observers: [observer],
      );
      addTearDown(container.dispose);

      final provider = StateProvider((ref) => 0);

      // Read to initialize
      container.read(provider);
      capturedEvents.clear(); // Clear initialization events

      // Trigger update
      container.read(provider.notifier).state = 1;

      // Verify update was logged
      expect(container.read(provider), equals(1));
      expect(
        capturedEvents.any((e) =>
            (e.level == LogLevel.info || e.level == LogLevel.debug) &&
            (e.message.contains('Provider updated') ||
                e.message.contains('state changes'))),
        isTrue,
      );
    });

    test('should capture provider disposal', () {
      final capturedEvents = <LogEvent>[];
      final mockLogger = _MockLogger(capturedEvents);
      final observer = RiverpodLoggerObserver(logger: mockLogger);

      final container = ProviderContainer(
        observers: [observer],
      );

      final provider = StateProvider((ref) => 0);

      // Read provider to initialize it
      container.read(provider);
      capturedEvents.clear(); // Clear initialization events

      // Dispose container to trigger provider disposal
      container.dispose();

      // Verify disposal was logged
      expect(
        capturedEvents.any((e) =>
            e.level == LogLevel.debug && e.message.contains('Provider disposed')),
        isTrue,
      );
    });

    test('should capture provider errors', () {
      final capturedEvents = <LogEvent>[];
      final mockLogger = _MockLogger(capturedEvents);
      final observer = RiverpodLoggerObserver(logger: mockLogger);

      final container = ProviderContainer(
        observers: [observer],
      );
      addTearDown(container.dispose);

      final errorProvider = Provider<int>((ref) {
        throw Exception('Test error');
      });

      // Try to read provider which will fail
      try {
        container.read(errorProvider);
      } catch (_) {
        // Expected to throw
      }

      // Verify error was logged
      expect(
        capturedEvents.any((e) =>
            e.level == LogLevel.error &&
            e.message.contains('Provider failed') &&
            e.error != null),
        isTrue,
      );
    });

    test('should work with multiple providers', () {
      final capturedEvents = <LogEvent>[];
      final mockLogger = _MockLogger(capturedEvents);
      final observer = RiverpodLoggerObserver(logger: mockLogger);

      final container = ProviderContainer(
        observers: [observer],
      );
      addTearDown(container.dispose);

      final provider1 = StateProvider((ref) => 1);
      final provider2 = StateProvider((ref) => 2);

      // Read both providers
      container.read(provider1);
      container.read(provider2);

      // At least 2 initialization events should be captured
      final initEvents = capturedEvents
          .where((e) => e.message.contains('Provider initialized'))
          .toList();
      expect(initEvents.length, greaterThanOrEqualTo(2));
    });
  });
}

/// Mock logger that captures log events for testing.
class _MockLogger implements RiverpodDevLogger {
  final List<LogEvent> capturedEvents;

  _MockLogger(this.capturedEvents);

  @override
  void debug(String message, [Map<String, dynamic>? extra]) {
    capturedEvents.add(LogEvent(
      level: LogLevel.debug,
      message: message,
      extra: extra,
    ));
  }

  @override
  void info(String message, [Map<String, dynamic>? extra]) {
    capturedEvents.add(LogEvent(
      level: LogLevel.info,
      message: message,
      extra: extra,
    ));
  }

  @override
  void warning(String message, [Map<String, dynamic>? extra]) {
    capturedEvents.add(LogEvent(
      level: LogLevel.warning,
      message: message,
      extra: extra,
    ));
  }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace, Map<String, dynamic>? extra]) {
    capturedEvents.add(LogEvent(
      level: LogLevel.error,
      message: message,
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    ));
  }

  @override
  RiverpodDevLogger bind({Map<String, dynamic>? extra}) {
    return this; // Simple mock - just return self
  }

  @override
  bool get isStateDiffEnabled => false; // Disable diff for simpler testing
}
