import 'package:intl/intl.dart';

extension DateFormatExtension on DateFormat {
  DateTime? tryParseOrNull(String input) {
    try {
      return parse(input);
    } catch (e) {
      return null;
    }
  }
}
