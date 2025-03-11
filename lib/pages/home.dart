import 'package:dark_validator/main.dart';
import 'package:dark_validator/services/core.dart';
import 'package:dark_validator/widgets/arrow_value.dart';
import 'package:dark_validator/widgets/chart.dart';
import 'package:dark_validator/widgets/chart_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    core.run();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(tickProvider);

    return Scaffold(
      floatingActionButton: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _TimePaddingButton(),
          _ZoomButton(),
          _SpeedButton(),
        ],
      ),
      body: Column(
        children: [
          ChartStream(
            label: '1',
            chartData: ChartData(data: breathingFeeder.value?.buffer ?? []),
          ),
          Container(height: 1, color: Colors.white),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  ChartStream(
                    label: 'sin',
                    chartData: ChartData(data: sinFeeder.value?.buffer ?? []),
                  ),
                  ChartStream(
                    label: 'sum',
                    chartData: ChartData(data: sumSinBreath.buffer),
                  ),
                  ChartStream(
                    label: 'rampUp',
                    chartData: ChartData(data: rampUpBreath.buffer),
                  ),
                  const Gap(1024),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ArrowValue<double>(
      label: 'Vitesse',
      initialValue: config.speed,
      value: config.speed.toString(),
      reset: (_) => config.speed == 0 ? config.speed = 1 : config.speed = 0,
      lower: () => config.updateSpeed(4),
      upper: () => config.updateSpeed(-4),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ArrowValue<int>(
      label: 'Zoom',
      initialValue: config.zoom,
      value: (config.zoom / 100).toStringAsFixed(0),
      reset: (_) => config.zoom = 100,
      lower: () => config.updateZoom(100),
      upper: () => config.updateZoom(-100),
    );
  }
}

class _TimePaddingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ArrowValue<int>(
      label: 'Padding',
      initialValue: config.timePadding,
      value: (-config.timePadding).toStringAsFixed(0),
      reset: (_) => config.timePadding = 0,
      lower: () => config.updateTimePadding(50),
      upper: () => config.updateTimePadding(-50),
    );
  }
}
