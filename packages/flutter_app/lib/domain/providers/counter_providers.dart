import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infrastructure/data_sources/counter_data_source.dart';
import '../../infrastructure/repositories/counter_repository_impl.dart';
import '../entities/counter.dart';
import '../repositories/counter_repository.dart';

part 'counter_providers.g.dart';

/// Provider for CounterDataSource
/// This is a singleton provider to maintain state
@Riverpod(keepAlive: true)
CounterDataSource counterDataSource(Ref ref) {
  developer.log('Creating CounterDataSource instance');
  return CounterDataSource();
}

/// Provider for CounterRepository
@Riverpod(keepAlive: true)
CounterRepository counterRepository(Ref ref) {
  final dataSource = ref.watch(counterDataSourceProvider);
  return CounterRepositoryImpl(dataSource);
}

/// FutureProvider for getting counter value
/// This demonstrates Query/Subscription pattern
@riverpod
Future<Counter> counter(Ref ref) async {
  developer.log('counter provider called');
  final notifierValue = await ref.watch(counterNotifierProvider.future);
  developer.log('counter value: ${notifierValue.value}');
  return notifierValue;
}

/// Provider for counter increment operation
/// This demonstrates Mutation pattern
@Riverpod(keepAlive: true)
class CounterNotifier extends _$CounterNotifier {
  @override
  Future<Counter> build() async {
    developer.log('CounterNotifier build called');
    final repository = ref.read(counterRepositoryProvider);
    final counter = await repository.getCounter();
    developer.log('CounterNotifier initial value: ${counter.value}');
    return counter;
  }

  /// Increment counter value
  Future<void> increment() async {
    developer.log('increment called');
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(counterRepositoryProvider);
      final newCounter = await repository.increment();
      developer.log('new counter value after increment: ${newCounter.value}');
      state = AsyncValue.data(newCounter);
      ref.notifyListeners();
    } catch (error, stackTrace) {
      developer.log('increment error: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Decrement counter value
  Future<void> decrement() async {
    developer.log('decrement called');
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(counterRepositoryProvider);
      final newCounter = await repository.decrement();
      developer.log('new counter value after decrement: ${newCounter.value}');
      state = AsyncValue.data(newCounter);
      ref.notifyListeners();
    } catch (error, stackTrace) {
      developer.log('decrement error: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Reset counter value
  Future<void> reset() async {
    developer.log('reset called');
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(counterRepositoryProvider);
      final newCounter = await repository.reset();
      developer.log('new counter value after reset: ${newCounter.value}');
      state = AsyncValue.data(newCounter);
      ref.notifyListeners();
    } catch (error, stackTrace) {
      developer.log('reset error: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh counter value
  Future<void> refresh() async {
    developer.log('refresh called');
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(counterRepositoryProvider);
      final newCounter = await repository.getCounter();
      developer.log('new counter value after refresh: ${newCounter.value}');
      state = AsyncValue.data(newCounter);
      ref.notifyListeners();
    } catch (error, stackTrace) {
      developer.log('refresh error: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
