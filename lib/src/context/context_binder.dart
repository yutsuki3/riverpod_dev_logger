import 'package:riverpod/riverpod.dart';
import '../core/logger.dart';
import 'context_detector.dart';
import 'provider_context.dart';

extension LoggerProviderX on Ref {
  Logger get logger {
    final context = ProviderContext(
      providerName: 'Provider', // We could try to get the actual name if available
    );
    return ContextDetector.runWithContext(context, () => Logger());
  }
}

extension LoggerWidgetRefX on WidgetRef {
  Logger get logger {
    return Logger(tags: ['Widget']);
  }
}
