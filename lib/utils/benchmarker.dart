import 'package:dark_validator/utils/logger.dart';

class Benchmarker {
  // Singleton
  Benchmarker._();
  static final Benchmarker i = Benchmarker._();

  String? _name;
  Stopwatch? _stopwatch;

  List<(String label, int duration)> _timestamps = [];

  int get elapsedMilliseconds => _stopwatch?.elapsedMilliseconds ?? 0;

  void start(String name) {
    _name = name;
    _stopwatch = Stopwatch()..start();
    _timestamps = [];

    track('⏯️ Start Benchmarker');
  }

  void track(String label) {
    if (_stopwatch == null) {
      logWarning('Trying to track "$label" but no benchmark was started', who: 'Benchmarker');
      return;
    }

    logInfo('$label: ${_stopwatch!.elapsedMilliseconds}ms', who: 'Benchmarker');

    _timestamps.add((label, _stopwatch!.elapsedMilliseconds));
  }

  void stop() {
    if (_stopwatch == null) {
      logWarning('Trying to stop benchmark but none was started', who: 'Benchmarker');
      return;
    }

    _stopwatch!.stop();

    track('⏹️ Stop Benchmarker');
    _printReport();
  }

  void _printReport() {
    final maxDuration = _timestamps.last.$2;

    String formatDuration(int ms) => Duration(milliseconds: ms).toString();

    logInfo('--------------------------------', who: 'Benchmarker');
    logInfo('📊 Benchmark report for: $_name', who: 'Benchmarker');
    logInfo('Detailed Timeline:', who: 'Benchmarker');
    for (int i = 0; i < _timestamps.length; i++) {
      final entry = _timestamps[i];
      final key = entry.$1.length > 60 ? entry.$1.substring(0, 60) : entry.$1.padRight(60);

      final duration = i == 0 ? entry.$2 : entry.$2 - _timestamps[i - 1].$2;
      final durationStr = (Duration(milliseconds: duration).inMilliseconds / 1000).toStringAsFixed(3);

      logInfo('$key ${formatDuration(entry.$2)} | ${durationStr}s', who: 'Benchmarker');
    }
    logInfo('--------------------------------', who: 'Benchmarker');

    logPriority('Total duration: ${formatDuration(maxDuration)}', who: 'Benchmarker');
    logInfo('--------------------------------', who: 'Benchmarker');
  }
}
