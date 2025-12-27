import 'dart:async';
import 'provider_context.dart';

class ContextDetector {
  static const Symbol _contextKey = #riverpod_dev_logger_context;

  static ProviderContext? get currentContext {
    return Zone.current[_contextKey] as ProviderContext?;
  }

  static R runWithContext<R>(ProviderContext context, R Function() action) {
    return runZoned(
      action,
      zoneValues: {
        _contextKey: context,
      },
    );
  }
}
