// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$counterDataSourceHash() => r'e19519888740a45f11796902dae5f9107493cc74';

/// Provider for CounterDataSource
///
/// Copied from [counterDataSource].
@ProviderFor(counterDataSource)
final counterDataSourceProvider =
    AutoDisposeProvider<CounterDataSource>.internal(
      counterDataSource,
      name: r'counterDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$counterDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CounterDataSourceRef = AutoDisposeProviderRef<CounterDataSource>;
String _$counterRepositoryHash() => r'ac87e82b4b5f6e9b311df3b22260e588c8bb4540';

/// Provider for CounterRepository
///
/// Copied from [counterRepository].
@ProviderFor(counterRepository)
final counterRepositoryProvider =
    AutoDisposeProvider<CounterRepository>.internal(
      counterRepository,
      name: r'counterRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$counterRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CounterRepositoryRef = AutoDisposeProviderRef<CounterRepository>;
String _$counterHash() => r'cf64b94e678d47647d9b18b39656de56f0850a9f';

/// FutureProvider for getting counter value
/// This demonstrates Query/Subscription pattern
///
/// Copied from [counter].
@ProviderFor(counter)
final counterProvider = AutoDisposeFutureProvider<Counter>.internal(
  counter,
  name: r'counterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$counterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CounterRef = AutoDisposeFutureProviderRef<Counter>;
String _$counterNotifierHash() => r'a851d74980518745c322fc281b0bf3b4cf1d597f';

/// Provider for counter increment operation
/// This demonstrates Mutation pattern
///
/// Copied from [CounterNotifier].
@ProviderFor(CounterNotifier)
final counterNotifierProvider =
    AutoDisposeAsyncNotifierProvider<CounterNotifier, Counter>.internal(
      CounterNotifier.new,
      name: r'counterNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$counterNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CounterNotifier = AutoDisposeAsyncNotifier<Counter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
