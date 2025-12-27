import 'package:riverpod/riverpod.dart';
import '../core/logger.dart';
import '../context/context_detector.dart';
import '../context/provider_context.dart';
import '../diff/diff_engine.dart';
import '../diff/diff_formatters/console_diff_formatter.dart';

base class RiverpodLoggerObserver extends ProviderObserver {
  final RiverpodDevLogger _logger;
  final _diffEngine = DiffEngine();
  final _diffFormatter = ConsoleDiffFormatter();

  RiverpodLoggerObserver({RiverpodDevLogger? logger})
      : _logger = logger ?? RiverpodDevLogger();

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    _runInContext(context.provider, context.container, () {
      _logger.debug('Provider initialized with: $value');
    });
  }

  @override
  void didUpdateProvider(
      ProviderObserverContext context, Object? previousValue, Object? newValue) {
    _runInContext(context.provider, context.container, () {
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
  void didDisposeProvider(ProviderObserverContext context) {
    _runInContext(context.provider, context.container, () {
      _logger.debug('Provider disposed');
    });
  }

  @override
  void providerDidFail(
      ProviderObserverContext context, Object error, StackTrace stackTrace) {
    _runInContext(context.provider, context.container, () {
      _logger.error('Provider failed', error, stackTrace);
    });
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
