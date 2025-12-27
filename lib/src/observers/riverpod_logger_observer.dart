import 'package:riverpod/riverpod.dart';
import '../core/logger.dart';
import '../context/context_detector.dart';
import '../context/provider_context.dart';
import '../diff/diff_engine.dart';
import '../diff/diff_formatters/console_diff_formatter.dart';

/// A [ProviderObserver] that automatically logs provider lifecycle events using [RiverpodDevLogger].
base class RiverpodLoggerObserver extends ProviderObserver {
  final RiverpodDevLogger _logger;
  final _diffEngine = DiffEngine();
  final _diffFormatter = ConsoleDiffFormatter();

  /// Creates a [RiverpodLoggerObserver].
  ///
  /// An optional [logger] can be provided, otherwise a default instance is used.
  RiverpodLoggerObserver({RiverpodDevLogger? logger})
      : _logger = logger ?? RiverpodDevLogger();

  @override
  // ignore: avoid_renaming_method_parameters
  void didAddProvider(dynamic provider, Object? value,
      [dynamic container, ProviderContainer? _unused]) {
    final (actualProvider, actualContainer) = _resolveContext(provider, value, container);
    final actualValue = _isContext(provider) ? value : container;

    _runInContext(actualProvider, actualContainer, () {
      _logger.debug('Provider initialized with: $actualValue');
    });
  }

  @override
  // ignore: avoid_renaming_method_parameters
  void didUpdateProvider(
    dynamic provider,
    Object? previousValue,
    Object? newValue, [
    dynamic container,
    ProviderContainer? _unused,
  ]) {
    final (actualProvider, actualContainer) =
        _resolveContext(provider, previousValue, container);

    final actualPreviousValue = _isContext(provider) ? previousValue : newValue;
    final actualNewValue = _isContext(provider) ? newValue : container;

    _runInContext(actualProvider, actualContainer, () {
      if (_logger.isStateDiffEnabled) {
        final diff = _diffEngine.diff(actualPreviousValue, actualNewValue);
        if (diff.hasChanges) {
          final formattedDiff = _diffFormatter.format(diff);
          _logger.info(formattedDiff);
        } else {
          _logger.debug('Provider updated (no detected state changes)');
        }
      } else {
        _logger.info('Provider updated: $actualPreviousValue -> $actualNewValue');
      }
    });
  }

  @override
  // ignore: avoid_renaming_method_parameters
  void didDisposeProvider(dynamic provider, [ProviderContainer? container]) {
    final (actualProvider, actualContainer) = _resolveContext(provider, container);

    _runInContext(actualProvider, actualContainer, () {
      _logger.debug('Provider disposed');
    });
  }

  @override
  // ignore: avoid_renaming_method_parameters
  void providerDidFail(
    dynamic provider,
    Object error,
    StackTrace stackTrace, [
    dynamic container,
    ProviderContainer? _unused,
  ]) {
    final (actualProvider, actualContainer) =
        _resolveContext(provider, error, container);

    final actualError = _isContext(provider) ? error : stackTrace;
    final actualStackTrace = _isContext(provider) ? stackTrace : container as StackTrace;

    _runInContext(actualProvider, actualContainer, () {
      _logger.error('Provider failed', actualError, actualStackTrace);
    });
  }

  /// Helper to check if the argument is a Riverpod 3.x [ProviderObserverContext]
  /// without explicitly referencing the type (to support 2.x compilation).
  bool _isContext(dynamic arg) {
    return arg.runtimeType.toString() == 'ProviderObserverContext';
  }

  /// Helper to resolve (provider, container) from either 2.x or 3.x signatures.
  (ProviderBase<Object?>, ProviderContainer) _resolveContext(
    dynamic arg1,
    dynamic arg2, [
    dynamic arg3,
  ]) {
    if (_isContext(arg1)) {
      // In 3.x, arg1 is ProviderObserverContext which has 'provider' and 'container' fields.
      return (arg1.provider as ProviderBase<Object?>,
          arg1.container as ProviderContainer);
    }

    // Fallback to 2.x signature (provider, ..., container)
    final provider = arg1 as ProviderBase<Object?>;

    // Detection based on method:
    // didAdd(provider, value, container) -> arg3
    // didUpdate(provider, prev, next, container) -> arg3 (container is 4th in 2.x, so arg3 here if arg1/2/3)
    // Actually, in our override:
    // didUpdateProvider(provider, prev, next, [container, _unused])
    // arg1=provider, arg2=prev, arg3=container? No, next is positional.
    // Let's refine the detection.

    if (arg3 is ProviderContainer) return (provider, arg3);
    if (arg2 is ProviderContainer) return (provider, arg2);

    // If we only have 2 args (didDispose), arg2 is container.
    return (provider, arg2 as ProviderContainer);
  }

  void _runInContext(
    dynamic provider,
    ProviderContainer container,
    void Function() action,
  ) {
    // Attempt to find dependencies (this is tricky in Riverpod 2.x/3.x without internal access,
    // but we can try to get them if available or just log the provider info)
    final dependencies = <String>[];

    final context = ProviderContext(
      providerName: provider.name ?? provider.runtimeType.toString(),
      providerType: provider.runtimeType.toString(),
      dependencies: dependencies.isEmpty ? null : dependencies,
    );
    ContextDetector.runWithContext(context, action);
  }
}
