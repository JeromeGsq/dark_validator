import 'dart:ui';

import 'package:dark_validator/packages/edf_reader_dart/edf_data.dart';
import 'package:dark_validator/packages/edf_reader_dart/edf_plus_reader.dart';
import 'package:dark_validator/utils/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create the provider
class EdfLoaderNotifier extends StateNotifier<AsyncValue<EdfData<Offset>?>> {
  EdfLoaderNotifier() : super(const AsyncValue.data(null));

  Future<void> pickAndLoadFile() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['edf'],
      );

      if (result != null) {
        final String filePath = result.files.single.path!;
        await loadEdfFile(filePath);
      }
    } catch (e) {
      logError('Failed to pick file: ${e.toString()}', who: this);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> loadEdfFile(String filePath) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final reader = EDFPlusReader(filePath);
      return reader.read<Offset>();
    });
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

// Provider definition
final edfLoaderProvider = StateNotifierProvider<EdfLoaderNotifier, AsyncValue<EdfData<Offset>?>>((ref) {
  return EdfLoaderNotifier();
});
