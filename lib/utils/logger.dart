// ignore_for_file: avoid_print

/// Enable logging in the console and write to a file.
/*
```dart
Future<void> main() async {
  await Logger.instance.initialize();

  runApp(
    const YourMaterialApp(),
  );
}
```
*/

import 'package:flutter/foundation.dart';

class Logger {
  // Singleton
  Logger._();
  static final Logger instance = Logger._();

  void log(Object object, {String? status, Object? who}) {
    // Configure string
    final _status = status == null ? '' : '$status ';
    final _who = who == null
        ? ''
        : who is String
            ? '[$who]: '
            : '[${who.runtimeType}]: ';
    final _text = '$object';

    if (kDebugMode) {
      print('$_status$_who$_text');
    }

    // Wri
  }
}

void log(Object object, {Object? who}) {
  Logger.instance.log(object, who: who);
}

void logInfo(Object object, {Object? who}) {
  Logger.instance.log(object, status: '🔵 Info   ', who: who);
}

void logSuccess(Object object, {Object? who}) {
  Logger.instance.log(object, status: '🟢 OK     ', who: who);
}

void logWarning(Object object, {Object? who}) {
  Logger.instance.log(object, status: '🟡 Warn   ', who: who);
}

void logError(Object object, {Object? who}) {
  Logger.instance.log(object, status: '❌ Error  ', who: who);
}

void logPriority(Object object, {Object? who}) {
  Logger.instance.log(
    '',
    status: '💡 ================================================================================',
  );
  Logger.instance.log(object, status: '💡 Priority', who: who);
  Logger.instance.log(
    '',
    status: '💡 ================================================================================',
  );
}
