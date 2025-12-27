import 'package:riverpod/riverpod.dart';
import '../core/logger.dart';

typedef Logger = RiverpodDevLogger;

extension RiverpodDevLoggerRefX on Ref {
  Logger get logger {
    String? providerName;
    try {
      // Accessing provider name if available on the element
      // ignore: avoid_dynamic_calls
      providerName = (this as dynamic).provider.name;
    } catch (_) {}
    
    return RiverpodDevLogger().bind(extra: {
      'provider': providerName ?? runtimeType.toString(),
    });
  }
}
