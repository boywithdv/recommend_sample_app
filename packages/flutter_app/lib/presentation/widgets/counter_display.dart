import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/counter_providers.dart';

/// Widget that displays the counter value
/// This demonstrates the ref.watch pattern from the sequence diagram
class CounterDisplay extends ConsumerWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This demonstrates the Query/Subscription pattern from the sequence diagram
    final counterAsync = ref.watch(counterNotifierProvider);
    developer.log('CounterDisplay build: ${counterAsync.value?.value}');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'You have pushed the button this many times:',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        counterAsync.when(
          data: (counter) {
            developer.log('CounterDisplay data: ${counter.value}');
            return Text(
              '${counter.value}',
              style: Theme.of(context).textTheme.headlineMedium,
            );
          },
          loading: () {
            final previousValue = counterAsync.value?.value ?? 0;
            developer.log(
              'CounterDisplay loading, previous value: $previousValue',
            );
            return Text(
              '$previousValue',
              style: Theme.of(context).textTheme.headlineMedium,
            );
          },
          error: (error, stackTrace) {
            developer.log('CounterDisplay error: $error');
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 10),
                Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
