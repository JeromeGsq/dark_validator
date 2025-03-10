import 'package:dark_validator/services/edf_loader.dart';
import 'package:file_picker/file_picker.dart';
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
            TextButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['edf'],
                );

                if (result != null) {
                  final String filePath = result.files.single.path!;
                  await ref.read(edfLoaderProvider.notifier).loadEdfFile(filePath);
                }
              },
              child: const Text('Pick EDF File'),
            ),
            // Handle different states
            switch (edfState) {
              EdfLoadInitial() => const Text('Select a file to begin'),
              EdfLoadLoading() => const CircularProgressIndicator(),
              EdfLoadSuccess(data: final _) => const Text('File loaded successfully!'),
              EdfLoadError(message: final message) => Text('Error: $message'),
            },
          ],
        ),
      ),
    );
  }
}
