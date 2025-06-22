import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/counter_providers.dart';
import '../widgets/counter_controls.dart';
import '../widgets/counter_display.dart';

/// Counter page that demonstrates Riverpod architecture
class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Riverpod Counter Example'),
        actions: [
          // Refresh button to demonstrate ref.refresh
          IconButton(
            onPressed: () async {
              // This demonstrates the refresh pattern from the sequence diagram
              // Refreshを実行し、新しい値を待機
              final newValue = await ref.refresh(counterProvider.future);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Counter refreshed: ${newValue.value}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Counter',
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Counter display widget
            CounterDisplay(),
            SizedBox(height: 20),
            // Counter controls widget
            CounterControls(),
          ],
        ),
      ),
    );
  }
}
