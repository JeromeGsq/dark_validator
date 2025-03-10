import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getFilePath(String assetPath) async {
  final bytes = await rootBundle.load(assetPath);

  final filePath = await getTemporaryDirectory();
  final file = File('${filePath.path}/${Random().nextInt(1000000000)}');
  await file.writeAsBytes(bytes.buffer.asUint8List());

  return file.path;
}
