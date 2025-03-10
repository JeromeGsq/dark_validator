import 'dart:io';

import 'package:dark_validator/utils/logger.dart';

String findFile(
  String pathWithWildcard,
  String wildcard, {
  bool recursive = false,
}) {
  final Directory directory = Directory(pathWithWildcard);
  if (!directory.existsSync()) {
    throw Exception('Directory does not exist');
  }

  final fileList = directory.listSync(recursive: recursive);
  for (var file in fileList) {
    if (file is File) {
      if (file.path.contains(wildcard)) {
        return file.path;
      }
    }
  }

  logError('No file found with wildcard: $pathWithWildcard/*$wildcard');
  throw Exception('No file found with wildcard: $pathWithWildcard/*$wildcard');
}

List<String> findFiles(
  String pathWithWildcard,
  String wildcard, {
  bool recursive = false,
}) {
  final Directory directory = Directory(pathWithWildcard);
  if (!directory.existsSync()) {
    throw Exception('Directory does not exist');
  }

  final fileList = directory.listSync(recursive: recursive);
  final listFiles = <String>[];
  for (var file in fileList) {
    if (file is File) {
      if (file.path.contains(wildcard)) {
        listFiles.add(file.path);
      }
    }
  }

  if (listFiles.isEmpty) {
    logError('No file found with wildcard: $pathWithWildcard/*$wildcard');
    return [];
  }

  return listFiles;
}
