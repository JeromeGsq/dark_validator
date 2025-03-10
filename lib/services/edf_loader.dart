import 'package:dark_validator/packages/edf_reader_dart/edf_data.dart';
import 'package:dark_validator/packages/edf_reader_dart/edf_plus_reader.dart';
import 'package:dark_validator/utils/file.dart';
import 'package:dark_validator/utils/logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edf_loader.g.dart';

@Riverpod(keepAlive: true)
class EdfFileLoader extends _$EdfFileLoader {
  @override
  FutureOr<EdfData<Offset>?> build({required String? path}) async {
    if (path == null) {
      return null;
    }

    if (path.contains('assets')) {
      path = await getFilePath(path);
    }

    await loadEdfFile(path);

    return state.value;
  }

  Future<void> pickAndLoadFile() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['edf'],
      );

      if (result != null) {
        final filePath = result.files.single.path!;
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
}
