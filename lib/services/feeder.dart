import 'dart:math';
import 'dart:ui';

import 'package:dark_validator/services/edf_loader.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feeder.g.dart';

@Riverpod(keepAlive: true)
class FeederEdfSignal extends _$FeederEdfSignal {
  final List<Offset> _points = [];
  int _counter = 0;

  @override
  List<Offset> build({required String edfFilePath, int start = 0}) {
    _counter = start;
    return _points;
  }

  Future<void> update() async {
    final edfState = ref.watch(edfFileLoaderProvider(path: edfFilePath));
    final dy = edfState.value?.signals.first.samples[_counter].dy ?? 0;
    _points.add(Offset(_counter.toDouble(), dy));
    _counter++;

    state = _points;
  }
}

@riverpod
class FeederSignal extends _$FeederSignal {
  List<Offset> _points = [];
  int _counter = 0;

  // Breathing simulation parameters
  final double _breathsPerMinute = 15; // Average breathing rate
  final double _baselineValue = 50; // Center line of breathing
  final double _breathAmplitude = 30; // Depth of breath

  @override
  Stream<List<Offset>> build({required String? id}) {
    return Stream.periodic(const Duration(milliseconds: 50)).map(
      // 20 FPS
      (_) {
        final time = _counter * 0.05; // Convert to seconds

        // Create a more natural breathing curve using a combination of sine waves
        final breathValue = _baselineValue + _breathAmplitude * sin(2 * pi * (_breathsPerMinute / 60) * time) * (0.8 + 0.2 * sin(4 * pi * (_breathsPerMinute / 60) * time)); // Add slight variation

        final newPoint = Offset(
          _counter.toDouble(),
          breathValue,
        );

        _points = [..._points, newPoint];

        // Keep last 1000 points (about 50 seconds of data)
        if (_points.length > 1000) {
          _points = _points.sublist(_points.length - 1000);
        }

        _counter++;
        return _points;
      },
    );
  }
}
