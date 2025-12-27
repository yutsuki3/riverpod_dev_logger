import 'package:riverpod/riverpod.dart';
import '../core/logger.dart';
import '../context/context_detector.dart';
import '../context/provider_context.dart';

class RiverpodLoggerObserver extends ProviderObserver {
  final Logger _logger;

  RiverpodLoggerObserver({Logger? logger}) : _logger = logger ?? Logger();

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    final context = ProviderContext(
      providerName: provider.name ?? provider.runtimeType.toString(),
    );

    ContextDetector.runWithContext(context, () {
      _logger.debug('Provider initialized with value: $value');
    });
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final context = ProviderContext(
      providerName: provider.name ?? provider.runtimeType.toString(),
    );

    ContextDetector.runWithContext(context, () {
      _logger.debug('Provider updated: $previousValue -> $newValue');
    });
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    final context = ProviderContext(
      providerName: provider.name ?? provider.runtimeType.toString(),
    );

    ContextDetector.runWithContext(context, () {
      _logger.debug('Provider disposed');
    });
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    final context = ProviderContext(
      providerName: provider.name ?? provider.runtimeType.toString(),
    );

    ContextDetector.runWithContext(context, () {
      _logger.error('Provider failed', error: error, stackTrace: stackTrace);
    });
  }
}
