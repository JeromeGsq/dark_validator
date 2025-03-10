import 'package:dark_validator/services/edf_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edfState = ref.watch(edfLoaderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dark Validator'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(edfLoaderProvider.notifier).pickAndLoadFile();
              },
              child: const Text('Sélectionner un fichier EDF'),
            ),
            edfState.when(
              data: (data) => Text('File: ${data?.header.startDate}'),
              error: (error, stackTrace) => Text('Error: ${error.toString()}'),
              loading: () => const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
