/// Counter domain entity
class Counter {
  final int value;

  const Counter({required this.value});

  /// Create a new Counter with incremented value
  Counter increment() => Counter(value: value + 1);

  /// Create a new Counter with decremented value
  Counter decrement() => Counter(value: value - 1);

  /// Create a new Counter with reset value
  Counter reset() => const Counter(value: 0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Counter &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Counter(value: $value)';
}
