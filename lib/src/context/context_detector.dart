import 'dart:async';
import 'provider_context.dart';

/// A utility that uses [Zone] to detect and manage [ProviderContext].
class ContextDetector {
  static const _zoneKey = #riverpod_dev_logger_context;

  /// Returns the [ProviderContext] for the current [Zone], or null if not set.
  static ProviderContext? get currentContext {
    return Zone.current[_zoneKey] as ProviderContext?;
  }

  /// Runs the [action] within a new [Zone] that carries the given [context].
  static R runWithContext<R>(ProviderContext context, R Function() action) {
    return runZoned(
      action,
      zoneValues: {_zoneKey: context},
    );
  }
}
