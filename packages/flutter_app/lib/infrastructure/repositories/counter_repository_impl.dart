import '../../domain/entities/counter.dart';
import '../../domain/repositories/counter_repository.dart';
import '../data_sources/counter_data_source.dart';

/// Implementation of CounterRepository
class CounterRepositoryImpl implements CounterRepository {
  final CounterDataSource _dataSource;

  const CounterRepositoryImpl(this._dataSource);

  @override
  Future<Counter> getCounter() async {
    return await _dataSource.getCounter();
  }

  @override
  Future<void> saveCounter(Counter counter) async {
    await _dataSource.saveCounter(counter);
  }

  @override
  Future<Counter> increment() async {
    return await _dataSource.increment();
  }

  @override
  Future<Counter> decrement() async {
    return await _dataSource.decrement();
  }

  @override
  Future<Counter> reset() async {
    return await _dataSource.reset();
  }
}
