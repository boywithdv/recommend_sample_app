import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/counter_providers.dart';

/// Widget that provides counter control buttons
/// This demonstrates the ref.read pattern for mutations from the sequence diagram
class CounterControls extends ConsumerWidget {
  const CounterControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This demonstrates the Mutation pattern from the sequence diagram
    final counterNotifier = ref.watch(counterNotifierProvider.notifier);
    final counterState = ref.watch(counterNotifierProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Increment button
          FloatingActionButton(
            onPressed: counterState.isLoading
                ? null
                : () async {
                    await counterNotifier.increment();
                  },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 20),

          // Decrement button
          FloatingActionButton(
            onPressed: counterState.isLoading
                ? null
                : () async {
                    await counterNotifier.decrement();
                  },
            tooltip: 'Decrement',
            backgroundColor: Colors.orange,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 20),

          // Reset button
          FloatingActionButton(
            onPressed: counterState.isLoading
                ? null
                : () async {
                    await counterNotifier.reset();
                  },
            tooltip: 'Reset',
            backgroundColor: Colors.red,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 20),

          // Refresh button
          FloatingActionButton(
            onPressed: counterState.isLoading
                ? null
                : () async {
                    await counterNotifier.refresh();
                  },
            tooltip: 'Refresh',
            backgroundColor: Colors.green,
            child: const Icon(Icons.sync),
          ),

          // 常に一定の余白を確保
          const SizedBox(height: 20),

          // Loading indicator area with fixed height
          Container(
            height: 64, // より大きな高さを確保
            alignment: Alignment.center,
            child: counterState.isLoading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Processing...', style: TextStyle(fontSize: 14)),
                    ],
                  )
                : null,
          ),

          // Error display
          if (counterState.hasError) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Error: ${counterState.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
