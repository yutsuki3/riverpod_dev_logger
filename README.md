# riverpod_dev_logger

A developer-focused logging package for Riverpod 3.0+ that automatically detects and logs Provider execution context using Dart Zones.

## Features

- **Automatic Provider Context Detection**: Logs automatically include the name and type of the provider that emitted them.
- **Riverpod 3.0 Compatible**: Built to work with the latest Riverpod features.
- **Clean Console Output**: Organized logs with level, provider, dependencies, and message.
- **Extensible**: Custom formatters and child loggers for extra context.

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
