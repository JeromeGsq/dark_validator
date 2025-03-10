import 'dart:ui';

import 'package:dark_validator/services/feeder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'algo.g.dart';

@Riverpod(keepAlive: true)
class AlgoSignal extends _$AlgoSignal {
  final List<Offset> _points = [];
  final List<Offset> _buffer = [];

  @override
  List<Offset> build({required String id, int bufferSize = 50}) {
    return _points;
  }

  Future<void> update({
    required FeederEdfSignalProvider feeder,
    required double Function(List<Offset> buffer) compute,
  }) async {
    final inputSignal = ref.watch(feeder);
    final point = inputSignal.lastOrNull;

    if (point == null) {
      return;
    }

    _buffer.add(point);

    if (_buffer.length > bufferSize) {
      _buffer.removeAt(0);
    }

    final value = compute(_buffer);

    _points.add(Offset(point.dx, value));
    state = _points;
  }
}
