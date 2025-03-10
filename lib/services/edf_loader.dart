import 'dart:ui';

import 'package:dark_validator/packages/edf_reader_dart/edf_data.dart';
import 'package:dark_validator/packages/edf_reader_dart/edf_plus_reader.dart';
import 'package:dark_validator/utils/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the state for the EDF loader
sealed class EdfLoadState {
  const EdfLoadState();
}

class EdfLoadInitial extends EdfLoadState {
  const EdfLoadInitial();
}

class EdfLoadLoading extends EdfLoadState {
  const EdfLoadLoading();
}

class EdfLoadSuccess<T> extends EdfLoadState {
  const EdfLoadSuccess(this.data);
  final EdfData<T> data;
}

class EdfLoadError extends EdfLoadState {
  const EdfLoadError(this.message);
  final String message;
}

// Create the provider
class EdfLoaderNotifier extends StateNotifier<EdfLoadState> {
  EdfLoaderNotifier() : super(const EdfLoadInitial());

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
      state = EdfLoadError(e.toString());
    }
  }

  Future<void> loadEdfFile(String filePath) async {
    try {
      state = const EdfLoadLoading();

      final reader = EDFPlusReader(filePath);
      final data = await reader.read<Offset>();

      state = EdfLoadSuccess(data);
    } catch (e) {
      logError('Failed to load EDF file: ${e.toString()}', who: this);
      state = EdfLoadError(e.toString());
    }
  }

  void reset() {
    state = const EdfLoadInitial();
  }
}

// Provider definition
final edfLoaderProvider = StateNotifierProvider<EdfLoaderNotifier, EdfLoadState>((ref) {
  return EdfLoaderNotifier();
});
