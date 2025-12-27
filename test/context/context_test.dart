import 'dart:async';
import 'package:test/test.dart';
import 'package:riverpod_dev_logger/riverpod_dev_logger.dart';
import 'package:riverpod_dev_logger/src/context/context_detector.dart';

void main() {
  group('ContextDetector', () {
    test('should return null when no context is set', () {
      expect(ContextDetector.currentContext, isNull);
    });

    test('should return context when run in runWithContext', () {
      const context = ProviderContext(
        providerName: 'TestProvider',
        providerType: 'String',
      );

      ContextDetector.runWithContext(context, () {
        expect(ContextDetector.currentContext, equals(context));
      });
    });

    test('should handle nested contexts', () {
      const context1 = ProviderContext(
        providerName: 'Provider1',
        providerType: 'Type1',
      );
      const context2 = ProviderContext(
        providerName: 'Provider2',
        providerType: 'Type2',
      );

      ContextDetector.runWithContext(context1, () {
        expect(ContextDetector.currentContext, equals(context1));
        ContextDetector.runWithContext(context2, () {
          expect(ContextDetector.currentContext, equals(context2));
        });
        expect(ContextDetector.currentContext, equals(context1));
      });
    });

    test('should propagate context across async boundaries', () async {
      const context = ProviderContext(
        providerName: 'AsyncProvider',
        providerType: 'Future',
      );

      await ContextDetector.runWithContext(context, () async {
        expect(ContextDetector.currentContext, equals(context));
        await Future.delayed(Duration.zero);
        expect(ContextDetector.currentContext, equals(context));
      });
    });
  });
}
