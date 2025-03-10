import 'package:dark_validator/packages/charts/static_custom_painter.dart';
import 'package:dark_validator/packages/charts/static_line_chart/static_line_chart.dart';
import 'package:dark_validator/services/edf_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChartData {
  ChartData({
    required this.data,
  });

  final List<Offset> data;
  double get minValue {
    if (data.isEmpty) return 0;
    return data.map((e) => e.dy).reduce((a, b) => a < b ? a : b);
  }

  double get maxValue {
    if (data.isEmpty) return 0;
    return data.map((e) => e.dy).reduce((a, b) => a > b ? a : b);
  }
}

class ChartEdf extends ConsumerWidget {
  const ChartEdf({
    super.key,
    required this.path,
    this.start,
    this.end,
  });

  final String path;
  final int? start;
  final int? end;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edfState = ref.watch(edfFileLoaderProvider(path: path));

    return edfState.when(
      error: (_, __) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
      data: (data) {
        if (data == null) return const SizedBox.shrink();

        final chartData = ChartData(
          data: start != null && end != null
              ? data.signals.first.samples.skip(start!).take(end!).toList() // Filter
              : data.signals.first.samples, // Get all
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            return StaticCustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: StaticChartLinePainter(
                values: chartData.data,
                startZoomablePoint: null,
                endZoomablePoint: null,
                subValues: const [],
                title: data.signalHeaders.first.label,
                minValue: chartData.minValue,
                maxValue: chartData.maxValue,
                textDirection: TextDirection.ltr,
                textScaler: 1,
              ),
            );
          },
        );
      },
    );
  }
}
