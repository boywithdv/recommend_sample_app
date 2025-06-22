import 'dart:developer' as developer;

import '../../domain/entities/counter.dart';

/// Data source for Counter operations
/// This simulates API calls and local storage
class CounterDataSource {
  // Singleton instance
  static final CounterDataSource _instance = CounterDataSource._internal();
  factory CounterDataSource() => _instance;
  CounterDataSource._internal();

  // Simulate local storage
  int _currentValue = 0;

  /// Get current counter value from data source
  Future<Counter> getCounter() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    developer.log('CounterDataSource.getCounter: $_currentValue');
    return Counter(value: _currentValue);
  }

  /// Save counter value to data source
  Future<void> saveCounter(Counter counter) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    _currentValue = counter.value;
    developer.log('CounterDataSource.saveCounter: $_currentValue');
  }

  /// Increment counter value in data source
  Future<Counter> increment() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 400));
    _currentValue++;
    developer.log('CounterDataSource.increment: $_currentValue');
    return Counter(value: _currentValue);
  }

  /// Decrement counter value in data source
  Future<Counter> decrement() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 400));
    _currentValue--;
    developer.log('CounterDataSource.decrement: $_currentValue');
    return Counter(value: _currentValue);
  }

  /// Reset counter value in data source
  Future<Counter> reset() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));
    _currentValue = 0;
    developer.log('CounterDataSource.reset: $_currentValue');
    return Counter(value: _currentValue);
  }
}
