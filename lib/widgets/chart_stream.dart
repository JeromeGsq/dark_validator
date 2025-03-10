import 'package:dark_validator/packages/charts/static_custom_painter.dart';
import 'package:dark_validator/packages/charts/static_line_chart/static_line_chart.dart';
import 'package:dark_validator/utils/list.dart';
import 'package:dark_validator/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chart_stream.g.dart';

@Riverpod(keepAlive: true)
class ChartStreamZoom extends _$ChartStreamZoom {
  @override
  int build() {
    return 200;
  }

  void update(int value) {
    state = state + value;
  }
}

class ChartStream extends ConsumerWidget {
  const ChartStream({
    super.key,
    required this.chartData,
    this.label,
  });

  final ChartData chartData;
  final String? label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final values = chartData.data.safeSublist(chartData.data.length - ref.watch(chartStreamZoomProvider), chartData.data.length);

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
            minValue: chartData.minValue,
            maxValue: chartData.maxValue,
            textDirection: TextDirection.ltr,
            textScaler: 1,
          ),
        );
      },
    );
  }
}
