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
      [dynamic container, ProviderContainer? unusedContainer]) {
    final (actualProvider, actualContainer) =
        _resolveContext(provider, value, container);

    // In both 2.x (p, v, c) and 3.x (ctx, v), 'value' is accurately the 2nd param.
    _runInContext(actualProvider, actualContainer, () {
      _logger.debug('Provider initialized with: $value');
    });
  }

  @override
  // ignore: avoid_renaming_method_parameters
  void didUpdateProvider(
    dynamic provider,
    Object? previousValue,
    Object? newValue, [
    dynamic container,
    ProviderContainer? unusedContainer,
  ]) {
    final (actualProvider, actualContainer) =
        _resolveContext(provider, previousValue, container);

    // In both 2.x (p, pv, nv, c) and 3.x (ctx, pv, nv),
    // previousValue and newValue are at indices 1 and 2.
    _runInContext(actualProvider, actualContainer, () {
      if (_logger.isStateDiffEnabled) {
        final diff = _diffEngine.diff(previousValue, newValue);
        if (diff.hasChanges) {
          final formattedDiff = _diffFormatter.format(diff);
          _logger.info(formattedDiff);
        } else {
          _logger.debug('Provider updated (no detected state changes)');
        }
      } else {
        _logger.info('Provider updated: $previousValue -> $newValue');
      }
    });
  }

  @override
  // ignore: avoid_renaming_method_parameters
  void didDisposeProvider(dynamic provider, [ProviderContainer? container]) {
    final (actualProvider, actualContainer) =
        _resolveContext(provider, container);

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
    ProviderContainer? unusedContainer,
  ]) {
    final (actualProvider, actualContainer) =
        _resolveContext(provider, error, container);

    // In both versions, error and stackTrace are at indices 1 and 2.
    _runInContext(actualProvider, actualContainer, () {
      _logger.error('Provider failed', error, stackTrace);
    });
  }

  /// Helper to check if the argument is a Riverpod 3.x [ProviderObserverContext]
  /// without explicitly referencing the type (to support 2.x compilation).
  bool _isContext(dynamic arg) {
    return arg.runtimeType.toString() == 'ProviderObserverContext';
  }

  /// Helper to resolve (provider, container) from either 2.x or 3.x signatures.
  (dynamic, ProviderContainer) _resolveContext(
    dynamic arg1,
    dynamic arg2, [
    dynamic arg3,
  ]) {
    if (_isContext(arg1)) {
      // In 3.x, arg1 is ProviderObserverContext which has 'provider' and 'container' fields.
      return (arg1.provider, arg1.container as ProviderContainer);
    }

    // Fallback to 2.x signature (provider, ..., container)
    // We treat the provider as dynamic to avoid Undefined class errors on pub.dev.
    final provider = arg1;

    // Detection based on method:
    // didAdd(provider, value, container) -> arg3
    // didUpdate(provider, prev, next, container) -> arg3 (container is 4th in 2.x, so arg3 here if arg1/2/3)
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
