import 'package:test/test.dart';
import 'package:riverpod_dev_logger/riverpod_dev_logger.dart';

void main() {
  group('ContextDetector', () {
    test('currentContext returns null if not in context', () {
      expect(ContextDetector.currentContext, isNull);
    });

    test('runWithContext propagates context', () {
      const context = ProviderContext(providerName: 'TestProvider');
      
      ContextDetector.runWithContext(context, () {
        expect(ContextDetector.currentContext, equals(context));
        expect(ContextDetector.currentContext?.providerName, 'TestProvider');
      });
    });

    test('nested context works correctly', () {
      const context1 = ProviderContext(providerName: 'Provider1');
      const context2 = ProviderContext(providerName: 'Provider2');

      ContextDetector.runWithContext(context1, () {
        expect(ContextDetector.currentContext, equals(context1));
        
        ContextDetector.runWithContext(context2, () {
          expect(ContextDetector.currentContext, equals(context2));
        });

        expect(ContextDetector.currentContext, equals(context1));
      });
    });
  });
}
