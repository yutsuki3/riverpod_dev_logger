import 'package:riverpod/riverpod.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod_dev_logger/riverpod_dev_logger.dart';

// 1. Create a logger instance (optional, logger methods are static or via Ref extension)
final logger = Logger();

// 2. Define providers
final counterProvider = StateProvider<int>((ref) {
  // Use logger from Ref extension
  ref.logger.info('Initializing counter provider');
  return 0;
}, name: 'CounterProvider');

final doubleCounterProvider = Provider<int>((ref) {
  final count = ref.watch(counterProvider);
  ref.logger.info('Calculating double counter: $count * 2');
  return count * 2;
}, name: 'DoubleCounterProvider');

// 3. Define a Notifier
class TodoNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return ['Learn Riverpod', 'Learn Logging'];
  }

  void addTodo(String todo) {
    state = [...state, todo];
    // Custom logging with manual context if needed, but didUpdateProvider handles it
  }
}

final todoProvider = NotifierProvider<TodoNotifier, List<String>>(
    TodoNotifier.new,
    name: 'TodoProvider');

void main() {
  // 4. Configure the logger
  RiverpodDevLogger.configure(
    level: LogLevel.debug,
    enableContextDetection: true,
  );

  // 5. Initialize ProviderContainer with the observer
  final container = ProviderContainer(
    observers: [
      RiverpodLoggerObserver(
        logger: RiverpodDevLogger(),
      ),
    ],
  );

  print('--- Riverpod Dev Logger Example ---\n');

  // Trigger provider initialization
  container.read(counterProvider);
  container.read(doubleCounterProvider);

  // Update state
  print('\nUpdating counter...');
  container.read(counterProvider.notifier).state++;

  // Update notifier state
  print('\nAdding todo...');
  container.read(todoProvider.notifier).addTodo('New Todo');

  print('\nExample finished.');
}
