import 'dart:math';

import 'package:dark_validator/main.dart';
import 'package:dark_validator/packages/edf_reader_dart/edf_plus_reader.dart';
import 'package:dark_validator/services/computer.dart';
import 'package:dark_validator/utils/file.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

AsyncValue<Feeder> breathingFeeder = const AsyncLoading();
AsyncValue<Feeder> heartRateFeeder = const AsyncLoading();

AsyncValue<Feeder> sinFeeder = const AsyncLoading();
final sumSinBreath = SumSinBreath();
final rampUpBreath = RampUpBreath();

class Core {
  int tick = 0;

  // Callback to update tick in the provider
  Function(int)? onTickChanged;

  Future<void> init() async {
    final signals = (await EDFPlusReader(await getFilePath('assets/raw/20240613_215311_DDT.edf')).read<Offset>()).signals;
    breathingFeeder = AsyncData(Feeder(input: signals[0].samples));
    heartRateFeeder = AsyncData(Feeder(input: signals[1].samples));

    sinFeeder = AsyncData(Feeder(input: List.generate(signals[0].samples.length, (index) => Offset(index.toDouble(), sin(index * 0.1)))));
  }

  void _update() {
    breathingFeeder.value?.update();
    heartRateFeeder.value?.update();
    sinFeeder.value?.update();
    sumSinBreath.update();
    rampUpBreath.update();
  }

  Future<void> run() async {
    // Initialize if needed
    await init();

    while (true) {
      tick++;

      // Call the callback if set
      if (onTickChanged != null) {
        onTickChanged!(tick);
      }

      // Skip frame
      if (config.speed != 0.0) {
        // Wait
        _update();

        await Future.delayed(Duration(milliseconds: (40 / config.speed).round()));
      } else {
        await Future.delayed(const Duration(milliseconds: 16));
      }
    }
  }
}

class Feeder {
  Feeder({required List<Offset> input}) : _input = input.toList();

  final List<Offset> _input;
  final List<Offset> buffer = [];

  void update() {
    if (_input.isNotEmpty) {
      buffer.add(Offset(buffer.length.toDouble(), _input.removeAt(0).dy));
    }
  }
}

class Config {
  double speed = 1;
  int zoom = 100;
  int timePadding = 0;

  void updateSpeed(double value) {
    speed -= value;
    speed = speed.clamp(0, 100.0);
  }

  void updateZoom(int value) {
    zoom -= value;
    zoom = zoom.clamp(100, 10000);
  }

  Future<void> updateTimePadding(int value) async {
    final start = timePadding;
    final end = (timePadding + value).clamp(0, 128 * 128);
    final steps = value.abs();

    for (int i = 0; i < steps; i++) {
      timePadding = start + ((end - start) * i / steps).round();
      await Future.delayed(const Duration(milliseconds: 2));
    }

    timePadding = end;
  }
}
