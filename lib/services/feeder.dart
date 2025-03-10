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
