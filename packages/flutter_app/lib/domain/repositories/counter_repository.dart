import '../entities/counter.dart';

/// Repository interface for Counter operations
abstract class CounterRepository {
  /// Get current counter value
  Future<Counter> getCounter();

  /// Save counter value
  Future<void> saveCounter(Counter counter);

  /// Increment counter value
  Future<Counter> increment();

  /// Decrement counter value
  Future<Counter> decrement();

  /// Reset counter value
  Future<Counter> reset();
}
