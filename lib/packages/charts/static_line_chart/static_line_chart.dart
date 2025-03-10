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
  void dynamicPaint(Canvas canvas, Size size) {
    final tPadding = textScaler == 1 ? 0.0 : 14 * textScaler;
    size = Size(
      size.width - pHorizontal * 2 - (tPadding * 2),
      size.height - pVertical * 2 - (tPadding * 2),
    );

    // If the values are the same, we need to set boundaries to 0 and double the value
    if (minValue == maxValue) {
      minValue = 0;
      maxValue = maxValue * 2;
    }

    canvas.save();
    canvas.translate(tPadding * 1.5, tPadding);

    _drawSelectionRange(canvas, size);
    _drawLensSelection(canvas, size);

    canvas.restore();

    canvas.clipRect(Rect.fromLTWH(
      pHorizontal,
      pVertical,
      size.width,
      size.height,
    ));
  }

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
      ),
    )
      ..textDirection = textDirection
      ..layout();

    if (textDirection == TextDirection.rtl) {
      // Flip the x-axis
      canvas.save();
      canvas.scale(-1, 1);

      final textX = -pHorizontal - text.width;
      text.paint(canvas, Offset(textX, 0));
      canvas.restore();
    } else {
      final textX = pHorizontal;
      text.paint(canvas, Offset(textX, 0));
    }
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

      final text = TextPainter(
        text: TextSpan(
          // Start at 12h00 to 12h00
          text: DateTime(0, 0, 0, i + 12, 0).toString(),
        ),
      )
        ..textDirection = textDirection
        ..layout();

      final textY = size.height + pVertical + 10;
      if (textDirection == TextDirection.rtl) {
        // Flip the x-axis
        canvas.save();
        canvas.scale(-1, 1);

        final textX = -(pHorizontal + i * gap * (size.width) + text.width / 2);
        text.paint(canvas, Offset(textX, textY));

        canvas.restore();
      } else {
        final textX = pHorizontal + i * gap * (size.width) - text.width / 2;
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
      final value = legendScale[i];
      final height = size.height;
      final yPos = pVertical + (height * i) / (legendScale.length - 1);

      final text = TextPainter(
        text: TextSpan(
          text: value.toStringAsFixed(2),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final textY = yPos - text.height / 2;

      if (textDirection == TextDirection.rtl) {
        // Flip the x-axis
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

  void _drawLinesChart(Canvas canvas, Size size) {
    if (values.isEmpty) {
      return;
    }

    values.sort((a, b) => a.dx.compareTo(b.dx));

    final start = values.first.dx;
    final end = values.last.dx;
    final valueWidth = size.width / (end - start);
    final diffs = <double>[];

    for (int i = 0; i < values.length - 1; i++) {
      diffs.add(values[i].dx - values[i + 1].dx);
    }
    final space = diffs.reduce((a, b) => a + b) / diffs.length;

    final style = Paint()
      ..color = Colors.blue
      ..isAntiAlias = false
      ..filterQuality = FilterQuality.low
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Calculate how many points we should draw based on animation progress
    final pointsToDraw = (values.length * (animationProgress ?? 1.0)).floor();

    for (int i = 0; i < pointsToDraw - 1; i++) {
      // With the bounds12h, you have empty datas, skip them
      if (values[i].dy == 0.0 || values[i + 1].dy == 0.0) {
        // Skip this iteration, there is no data to draw
        continue;
      }

      final x1 = values[i].dx - start;
      final x2 = values[i + 1].dx - start;

      // Check the space between the two points
      // Skip if the space difference is too large small to prevent drawing gaps between points
      // I must use this approximation because the data are sometimes compressed by simplify()
      if (values[i].dx - values[i + 1].dx <= space) {
        continue;
      }

      final y1 = (maxValue - values[i].dy.toDouble()) / (maxValue - minValue);
      final y2 = (maxValue - values[i + 1].dy.toDouble()) / (maxValue - minValue);
      if (y1.isNaN || y2.isNaN) {
        continue;
      }

      // Optionally fade in the last segment
      if (i == pointsToDraw - 2) {
        final fadeProgress = (values.length * (animationProgress ?? 1.0)) % 1.0;
        final originalColor = style.color;
        style.color = style.color.withAlpha(fadeProgress.toInt());

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

        style.color = originalColor;
      } else {
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

  void _drawSelectionRange(Canvas canvas, Size size) {
    if (milliseconds == 0.0) {
      return;
    }

    if (values.isEmpty) {
      return;
    }

    if (startZoomablePoint == null || endZoomablePoint == null) {
      return;
    }

    final start = values.first.dx;
    final end = values.last.dx;
    final valueWidth = size.width / (end - start);

    // Calculate the selection range positions
    final startX = pHorizontal + (startZoomablePoint!.dx - start) * valueWidth;
    final endX = pHorizontal + (endZoomablePoint!.dx - start) * valueWidth;

    final paint = Paint()
      ..color = Colors.blueGrey.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTRB(
        startX,
        pVertical - 10,
        endX,
        size.height + pVertical,
      ),
      paint,
    );

    /*
    // Add pin on top
    final pinPaint = Paint()
      ..color = Colors.blueGrey.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    const pinWidth = 20.0;
    const pinHeight = 15.0;
    final center = (endX - startX) / 2;

    canvas.drawRect(
      Rect.fromLTWH(
        startX + center - pinWidth / 2,
        pVertical - pinHeight,
        pinWidth,
        pinHeight,
      ),
      pinPaint,
    );
    */
  }

  void _drawLensSelection(Canvas canvas, Size size) {
    if (milliseconds == 0.0) {
      return;
    }

    if (values.isEmpty || startZoomablePoint == null || endZoomablePoint == null) {
      return;
    }

    final _size = Size(size.width - 200, size.height + 50);
    final start = values.first.dx;
    final end = values.last.dx;
    final valueWidth = size.width / (end - start);

    // Calculate the selection range positions
    final startX = pHorizontal + (startZoomablePoint!.dx - start) * valueWidth;
    final endX = pHorizontal + (endZoomablePoint!.dx - start) * valueWidth;

    // Calculate middle point for the lens curve
    final dx = (startX + endX) / 2;

    if (startZoomablePoint == null || endZoomablePoint == null) {
      return;
    }

    // Calculate the selection range positions
    final width = (endX - startX) / 2;

    // Draw rounded shape from top left to Offset "position"
    final backgroundPath = Path()
      ..moveTo(pHorizontal + 200, _size.height + pVertical - 1)
      ..cubicTo(
        pHorizontal + (dx - pHorizontal) / 2,
        _size.height + pVertical - 20,
        dx - width,
        _size.height + 20,
        dx - width,
        _size.height - 25,
      )
      ..cubicTo(
        dx - width,
        _size.height - 25,
        dx + width,
        _size.height - 25,
        dx + width,
        _size.height - 25,
      )
      ..cubicTo(
        dx + width,
        _size.height + 20,
        _size.width - (_size.width - dx - 10) / 2,
        _size.height + pVertical - 25,
        _size.width + pHorizontal,
        _size.height + pVertical,
      );

    final paint = Paint()
      ..color = Colors.blueGrey.withValues(alpha: 0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    canvas.drawPath(
      backgroundPath..close(),
      paint,
    );
  }
}
