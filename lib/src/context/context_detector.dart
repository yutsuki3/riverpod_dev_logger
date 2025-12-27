import 'dart:async';
import 'provider_context.dart';

class ContextDetector {
  static const _zoneKey = #riverpod_dev_logger_context;

  static ProviderContext? get currentContext {
    return Zone.current[_zoneKey] as ProviderContext?;
  }

  static R runWithContext<R>(ProviderContext context, R Function() action) {
    return runZoned(
      action,
      zoneValues: {_zoneKey: context},
    );
  }
}
