# riverpod_dev_logger

A developer-focused logging package for Riverpod 3.0+ that automatically detects and logs Provider execution context using Dart Zones.

## Features

- **Automatic Provider Context Detection**: No more manual tags! Logs automatically include the name and type of the provider that emitted them via Dart Zones.
- **Riverpod 3.0 Ready**: Built explicitly for the latest Riverpod features and patterns.
- **Structured Console Output**: Beautifully organized logs with level, provider info, dependencies, and extra metadata.
- **Hierarchical Loggers**: Use `.bind()` to create child loggers with additional context like `userId` or `requestId`.
- **Extensible Formatters**: Easily customize how logs are printed or sent to remote services.

## Installation

Add `riverpod_dev_logger` to your `pubspec.yaml`:

```yaml
dependencies:
  riverpod_dev_logger: ^0.0.1
```

## Setup

Initialize the logger and add the observer to your `ProviderScope`:

```dart
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_dev_logger/riverpod_dev_logger.dart';

void main() {
  RiverpodDevLogger.configure(
    level: LogLevel.debug,
    enableContextDetection: true,
  );

  final container = ProviderContainer(
    observers: [
      RiverpodLoggerObserver(),
    ],
  );

  // ...
}
```

## Usage

### In Providers

Use the `ref.logger` extension to log within functional or class-based providers:

```dart
final counterProvider = StateProvider<int>((ref) {
  ref.logger.info('Initializing counter');
  return 0;
}, name: 'CounterProvider');
```

Output:
`[INFO] [Provider:CounterProvider] [Dependencies:none] Initializing counter`

### Child Loggers

Bind extra context like user IDs or session IDs:

```dart
final authenticatedLogger = ref.logger.bind(userId: 'user_123');
authenticatedLogger.info('User action performed');
```

Output:
`[INFO] [Provider:MyProvider] [Dependencies:none] User action performed`
`  Extra: {userId: user_123}`

## License

MIT License - see the [LICENSE](LICENSE) file for details.
