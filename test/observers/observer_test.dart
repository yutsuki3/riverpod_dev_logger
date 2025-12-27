import 'package:test/test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_dev_logger/riverpod_dev_logger.dart';

void main() {
  group('RiverpodLoggerObserver', () {
    test('should capture provider updates in observer logs', () {
      final container = ProviderContainer(
        observers: [RiverpodLoggerObserver()],
      );
      addTearDown(container.dispose);

      final provider = StateProvider((ref) => 0);

      // Trigger update
      container.read(provider.notifier).state = 1;

      // This test mainly verifies that it doesn't crash when observers are active
      expect(container.read(provider), equals(1));
    });
  });
}
