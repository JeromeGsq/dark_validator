import 'dart:async';

import 'package:dark_validator/packages/charts/static_custom_painter.dart';
import 'package:dark_validator/packages/charts/static_line_chart/static_line_chart.dart';
import 'package:dark_validator/utils/list.dart';
import 'package:dark_validator/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chart_stream.g.dart';

@Riverpod(keepAlive: true)
class ChartStreamTimePadding extends _$ChartStreamTimePadding {
  double _targetValue = 0;
  Timer? _animationTimer;

  @override
  int build() {
    return 0;
  }

  void zoomIn() {
    _targetValue += 50;
    _startLerpAnimation();
  }

  void zoomOut() {
    _targetValue -= 50;
    if (_targetValue < 0) {
      _targetValue = 0;
    }
    _startLerpAnimation();
  }

  void _startLerpAnimation() {
    _animationTimer?.cancel();
    _animationTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      final step = (_targetValue - state) * 0.1; // Adjust this factor to control animation speed

      // If we're very close to target or step is too small, just set the final value
      if (step.abs() < 0) {
        state = _targetValue.round();
        timer.cancel();
        return;
      }

      state = (state + step).round();
    });
  }
}

@Riverpod(keepAlive: true)
class ChartStreamZoom extends _$ChartStreamZoom {
  @override
  int build() {
    return 200;
  }

  void zoomIn() {
    state += 50;
  }

  void zoomOut() {
    state -= 50;
    if (state < 100) {
      state = 100;
    }
  }
}

class ChartStream extends ConsumerWidget {
  const ChartStream({
    super.key,
    required this.chartData,
    this.label,
    this.minValue,
    this.maxValue,
  });

  final ChartData chartData;
  final String? label;
  final double? minValue;
  final double? maxValue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timePadding = ref.watch(chartStreamTimePaddingProvider);
    final zoom = ref.watch(chartStreamZoomProvider);
    final values = chartData.data.safeSublist(chartData.data.length - zoom - timePadding, chartData.data.length - timePadding);

    return LayoutBuilder(
      builder: (context, constraints) {
        return StaticCustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: StaticChartLinePainter(
            values: values..sort((a, b) => a.dx.compareTo(b.dx)),
            startZoomablePoint: null,
            endZoomablePoint: null,
            subValues: const [],
            title: label ?? '',
            minValue: minValue ?? chartData.minValue - 0.1,
            maxValue: maxValue ?? chartData.maxValue + 0.1,
            textDirection: TextDirection.ltr,
            textScaler: 1,
          ),
        );
      },
    );
  }
}
