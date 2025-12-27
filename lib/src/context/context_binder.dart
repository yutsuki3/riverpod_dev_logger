import 'package:riverpod/riverpod.dart';
import '../core/logger.dart';

/// Typedef for [RiverpodDevLogger].
typedef Logger = RiverpodDevLogger;

/// Extension on [Ref] to provide easy access to a [RiverpodDevLogger] bound with provider context.
extension RiverpodDevLoggerRefX on Ref {
  /// Returns a [Logger] instance configured with the current provider's name.
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
