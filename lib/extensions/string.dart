import 'dart:io';

import 'package:dark_validator/utils/logger.dart';

extension StringNullableExtension on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;

  /// Extract the period from the path
  /// The path must be a folder path
  /// The path must contain a folder with 8 digits from the date
  /// The path must contain a folder with 13 digits from the serial number
  List<String> extractPeriodFromPath() {
    final path = this;
    if (path.isNullOrEmpty) {
      logError('The path is null or empty', who: 'extractPeriodFromPath');
      return [];
    } else {
      path!;
    }

    // Check if the last segment is a unique folder named from the serial number
    if (path.lastSegment.length == 13) {
      logSuccess(
        'A specific folder with serial number has been found in the path: $path | ${path.lastSegment}',
        who: 'extractPeriodFromPath',
      );
      // Create a Directory from the path and list all subfolders
      final subFolders = Directory(path).listSync().map((d) => d.path.unixPath);

      // Ignore .DS_Store files and others
      // Get only folders with 8 char
      // Get only folders with digits
      final dates = subFolders
          .where((p) => !p.lastSegment.contains('.'))
          .where((p) => p.lastSegment.length == 8)
          .where((p) => p.lastSegment.isDigits())
          .map((e) => e.lastSegment)
          .toList();

      dates.sort();

      return dates;
    }

    logWarning(
      'No specific date or serial number has been found in the path: $path',
      who: 'extractPeriodFromPath',
    );

    return [];
  }

  String extractSerialNumberFromPath() {
    final path = this;
    if (path.isNullOrEmpty) {
      logError('The path is null or empty', who: 'extractSerialNumberFromPath');
      return '';
    } else {
      path!;
    }

    // Check if the last segment is a unique folder named from the serial number
    final segments = path.split('/');
    final serialNumber = segments.firstWhere((segment) => segment.length == 13, orElse: () => '');
    if (serialNumber.isNotEmpty) {
      logSuccess(
        'A specific folder with serial number has been found in the path: $path | $serialNumber',
        who: 'extractSerialNumberFromPath',
      );
      return serialNumber;
    }

    logWarning(
      'No specific serial number has been found in the path: $path',
      who: 'extractSerialNumberFromPath',
    );

    return '';
  }

  DateTime? safeParse() {
    if (isNullOrEmpty) {
      return null;
    }
    return DateTime.tryParse(this!) ?? DateTime.now();
  }
}

extension StringExtension on String {
  bool isDigits() {
    for (final element in codeUnits) {
      if (element < 48 || element > 57) {
        return false;
      }
    }
    return true;
  }

  DateTime get fromyyyyMMdd {
    final a = substring(0, 4);
    final b = substring(4, 6);
    final c = substring(6, 8);

    return DateTime(
      int.parse(a),
      int.parse(b),
      int.parse(c),
    );
  }

  DateTime get fromddMMyyyy {
    if (isNullOrEmpty) {
      return DateTime.now();
    }
    final string = replaceAll('/', '').replaceAll('-', '');
    final a = string.substring(0, 2);
    final b = string.substring(2, 4);
    final c = string.substring(4, 8);

    return DateTime(
      int.parse(c),
      int.parse(b),
      int.parse(a),
    );
  }

  // Remove last segment of path
  String get parentPath {
    final segments = split('/');
    return '${segments.getRange(0, segments.length - 1).join('/')}/';
  }

  // Get last segment of path
  String get lastSegment {
    final segments = split('/');
    return segments.last;
  }

  // To unix path
  String get unixPath => replaceAll('\\', '/');

  // To windows path
  String get platformAgnostic {
    return unixPath;
  }

  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';

  DateTime get extractStartTimeFromEvtCsv {
    // From this: 0.00.00_Oct 06 2023_22:17:17 PID=15,5,15
    // to this: DateTime(2023, 10, 06, 22, 17, 17)

    // Extraire la partie de la date et de l'heure
    final List<String> parts = split('_');
    final String datePart = parts[1];
    final String timePart = parts[2].split(' ')[0];

    // Transformer le mois en format numérique
    final Map<String, int> monthMap = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12
    };

    final List<String> dateComponents = datePart.split(' ');
    final int day = int.parse(dateComponents[1]);
    final int month = monthMap[dateComponents[0]]!;
    final int year = int.parse(dateComponents[2]);

    final List<String> timeComponents = timePart.split(':');
    final int hour = int.parse(timeComponents[0]);
    final int minute = int.parse(timeComponents[1]);
    final int second = int.parse(timeComponents[2]);

    final dateTime = DateTime(year, month, day, hour, minute, second);

    return dateTime;
  }
}

extension PathExtension on String? {
  String? get fileName => this?.platformAgnostic.split('/').last;
  String? get fileNameWithoutExtension => fileName?.platformAgnostic.split('.').first;
  String? get fileExtension => fileName?.split('.').last;
  String? get folderName => this?.platformAgnostic.split('/').last;
  String? get folderPath =>
      this?.platformAgnostic.split('/').sublist(0, this!.platformAgnostic.split('/').length - 1).join('/');
}
