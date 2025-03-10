import 'dart:math';

import 'package:dark_validator/packages/charts/static_custom_painter.dart';

import 'package:flutter/material.dart';

class StaticChartLinePainter extends StaticAndDynamicPainter {
  StaticChartLinePainter({
    required this.values,
    required this.startZoomablePoint,
    required this.endZoomablePoint,
    required this.subValues,
    required this.title,
    required this.minValue,
    required this.maxValue,
    required this.textDirection,
    required this.textScaler,
    this.pHorizontal = 45.0,
    this.pVertical = 25.0,
    this.milliseconds,
    this.detailedRangeDuration,
    this.animationProgress = 1.0,
    this.onDrawComplete,
  });

  final List<Offset> values;
  final Offset? startZoomablePoint;
  final Offset? endZoomablePoint;
  final List<List<Offset>> subValues;
  final String title;
  double minValue;
  double maxValue;

  final TextDirection textDirection;
  final double textScaler;

  final double pHorizontal;
  final double pVertical;

  final double? milliseconds;
  final Duration? detailedRangeDuration;

  final double? animationProgress;

  final VoidCallback? onDrawComplete;

  @override
  void staticPaint(Canvas canvas, Size size) {
    final tPadding = textScaler == 1 ? 0.0 : 14 * textScaler;
    size = Size(
      size.width - pHorizontal * 2 - (tPadding * 2),
      size.height - pVertical * 2 - (tPadding * 2),
    );

    canvas.save();
    canvas.translate(tPadding * 1.5, 0);
    _drawTitle(canvas, size);
    canvas.translate(0, tPadding);

    _drawLabelX(canvas, size);
    _drawLabelY(canvas, size);

    _drawBackground(canvas, size);
    _drawX(canvas, size);
    _drawY(canvas, size);

    _drawLinesChart(canvas, size);
    _drawSubValues(canvas, size);

    canvas.restore();

    onDrawComplete?.call();
  }

  @override
  void dynamicPaint(Canvas canvas, Size size) {}

  void _drawBackground(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(pHorizontal, pVertical, size.width, size.height),
      Paint()..color = Colors.white,
    );
  }

  void _drawTitle(Canvas canvas, Size size) {
    final text = TextPainter(
      text: TextSpan(
        text: title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    )
      ..textDirection = textDirection
      ..layout();

    text.paint(canvas, const Offset(0, 0));
  }

  void _drawX(Canvas canvas, Size size) {
    // We want 24 vertical lines for 24 hours
    const yLines = 24;
    const gap = 1 / yLines;

    final lineStyle = Paint()..color = Colors.grey;

    // Draw vertical grid lines
    for (int i = 0; i <= yLines; i++) {
      final x = i * gap * (size.width);

      canvas.drawLine(
        Offset(pHorizontal + x, pVertical),
        Offset(pHorizontal + x, size.height + pVertical + 5),
        lineStyle,
      );
    }
  }

  void _drawY(Canvas canvas, Size size) {
    // Draw vertical labels & horizontal grid lines
    final legendScale = [0.0, 0.25, 0.5, 0.75, 1.0].map((value) {
      return ((maxValue - minValue) * value) + minValue;
    }).toList();

    for (int i = 0; i < legendScale.length; i++) {
      final height = size.height;
      final yPos = pVertical + (height * i) / (legendScale.length - 1);

      canvas.drawLine(
        Offset(pHorizontal - 5, yPos),
        Offset(size.width + pHorizontal, yPos),
        Paint()
          ..strokeWidth = 0.5
          ..color = Colors.grey,
      );
    }
  }

  void _drawLabelX(Canvas canvas, Size size) {
    // We want 24 vertical lines for 24 hours
    const yLines = 24;
    const gap = 1 / yLines;

    // Draw vertical grid lines
    for (int i = 0; i <= yLines; i++) {
      // If the screen is too small, skip every other line
      if (size.width < 1500 * textScaler) {
        if (i % 2 != 0) {
          continue;
        }
      }

      final x = i * gap * (size.width);

      if (values.isEmpty) {
        continue;
      }

      final text = TextPainter(
        text: TextSpan(
          text: values[(i * (values.length - 1) ~/ 24)].dx.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 12 * textScaler,
            color: Colors.white,
          ),
        ),
        textDirection: textDirection,
      )..layout();

      final textY = size.height + pVertical + 10;

      if (textDirection == TextDirection.rtl) {
        canvas.save();
        canvas.scale(-1, 1);
        final textX = -(pHorizontal + x + text.width / 2);
        text.paint(canvas, Offset(textX, textY));
        canvas.restore();
      } else {
        final textX = pHorizontal + x - text.width / 2;
        text.paint(canvas, Offset(textX, textY));
      }
    }
  }

  void _drawLabelY(Canvas canvas, Size size) {
    // Draw vertical labels & horizontal grid lines
    final legendScale = [0.0, 0.25, 0.5, 0.75, 1.0].map((value) {
      return ((maxValue - minValue) * value) + minValue;
    }).toList();

    for (int i = 0; i < legendScale.length; i++) {
      final value = legendScale[legendScale.length - 1 - i]; // Reverse order for Y-axis
      final height = size.height;
      final yPos = pVertical + (height * i) / (legendScale.length - 1);

      final text = TextPainter(
        text: TextSpan(
          text: _formatYAxisValue(value),
          style: TextStyle(
            fontSize: 12 * textScaler,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final textY = yPos - text.height / 2;

      if (textDirection == TextDirection.rtl) {
        canvas.save();
        canvas.scale(-1, 1);
        final textX = -pHorizontal + 10;
        text.paint(canvas, Offset(textX, textY));
        canvas.restore();
      } else {
        final textX = -text.width + pHorizontal - 10;
        text.paint(canvas, Offset(textX, textY));
      }
    }
  }

  // Helper method to format Y-axis values
  String _formatYAxisValue(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
  }

  void _drawLinesChart(Canvas canvas, Size size) {
    if (values.isEmpty) {
      return;
    }

    values.sort((a, b) => a.dx.compareTo(b.dx));

    final start = values.first.dx;
    final end = values.last.dx;
    final valueWidth = size.width / (end - start);

    final style = Paint()
      ..color = Colors.teal
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < values.length - 1; i++) {
      final x1 = values[i].dx - start;
      final x2 = values[i + 1].dx - start;

      final y1 = (maxValue - values[i].dy.toDouble()) / (maxValue - minValue);
      final y2 = (maxValue - values[i + 1].dy.toDouble()) / (maxValue - minValue);
      if (y1.isNaN || y2.isNaN) {
        continue;
      }

      canvas.drawLine(
        Offset(
          pHorizontal + x1 * valueWidth,
          size.height - (size.height * y1 - pVertical),
        ),
        Offset(
          pHorizontal + x2 * valueWidth,
          size.height - (size.height * y2 - pVertical),
        ),
        style,
      );
    }
  }

  void _drawSubValues(Canvas canvas, Size size) {
    if (values.isEmpty) {
      return;
    }

    final start = values.first.dx;
    final end = values.last.dx;
    final valueWidth = size.width / (end - start);

    // Draw vertical events pins
    for (int x = 0; x < subValues.length; x++) {
      for (int j = 0; j < subValues[x].length; j++) {
        final subValue = subValues[x][j];

        final x1 = subValue.dx - start;
        final subValueDuration = max(subValue.dy * valueWidth, 2);

        // Draw Line
        canvas.drawRect(
          Rect.fromLTWH(
            pHorizontal + x1 * valueWidth,
            pVertical,
            subValueDuration.toDouble(),
            size.height,
          ),
          Paint()
            ..color = [
              Colors.red,
              Colors.green,
              Colors.blue,
            ][x],
        );

        // Draw Pin
        canvas.drawRect(
          Rect.fromLTWH(
            pHorizontal + x1 * valueWidth - 3,
            pVertical,
            1 + 7,
            -5,
          ),
          Paint()
            ..color = [
              Colors.red,
              Colors.green,
              Colors.blue,
            ][x],
        );
      }
    }
  }
}
