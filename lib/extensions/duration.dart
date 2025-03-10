import 'package:dark_validator/extensions/num.dart';
import 'package:dark_validator/utils/logger.dart';

extension DurationExtension on Duration {
  // To 11:22 format or 1:22 format, remove the first 0 if it exists
  String toHoursMinutes() {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = (inMinutes % 60).toString().padLeft(2, '0');
    // Remove the first 0
    if (hours.startsWith('0')) {
      return '$hours:$minutes'.substring(1);
    }
    return '$hours:$minutes';
  }

  Duration clamp(Duration min, Duration max) {
    if (this < min) {
      return min;
    }
    if (this > max) {
      return max;
    }
    return this;
  }
}

extension DurationStringExtension on String {
  /// Convert a string to a [Duration].
  ///
  /// Format must be [HH:mm:ss].
  Duration convertToDuration() {
    try {
      final List<String> parts = split(':');
      final List<String> secondsAndMilliseconds = parts[2].split('.');

      return Duration(
        hours: int.parse(parts[0]),
        minutes: int.parse(parts[1]),
        seconds: int.parse(secondsAndMilliseconds[0]),
        milliseconds: int.parse(secondsAndMilliseconds[1]),
      );
    } catch (e) {
      logError('Error converting $this to Duration', who: this);
      return Duration.zero;
    }
  }
}

extension DoubleIterableDurationExtension on Iterable<Duration> {
  Duration computeMean() {
    final result = map((e) => e.inMilliseconds).computeMean();
    return Duration(milliseconds: result.round());
  }

  Duration computeMedian() {
    final result = map((e) => e.inMilliseconds).computeMedian();
    return Duration(milliseconds: result.round());
  }
}
