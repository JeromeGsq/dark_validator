import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/widgets.dart' as widgets;
import 'package:jpeg_encode/jpeg_encode.dart';

const _quality = 68;

abstract class StaticAndDynamicPainter {
  Image saveStaticCanvas(Size size) {
    final recorder = PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)),
    );

    staticPaint(canvas, size);

    final picture = recorder.endRecording();
    return picture.toImageSync(size.width.toInt(), size.height.toInt());
  }

  Future<Uint8List?> screenshot({
    required Size size,
    Color backgroundColor = const Color(0xFFFFFFFF),
    bool flipX = false,
  }) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)),
    );

    if (flipX) {
      canvas.translate(size.width, 0);
      canvas.scale(-1, 1);
    }

    canvas.drawRect(
      Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)),
      Paint()..color = backgroundColor,
    );

    staticPaint(canvas, size);
    dynamicPaint(canvas, size);

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.width.toInt(), size.height.toInt());

    final byteData = await image.toByteData(format: ImageByteFormat.rawRgba);
    return JpegEncoder().compress(byteData!.buffer.asUint8List(), image.width, image.height, _quality);
  }

  /// Will paint once.
  ///
  /// You should override the dynamicPaint() method if you want dynamic painting.
  void staticPaint(Canvas canvas, Size size);

  /// Will paint every time the widget is rebuilt.
  ///
  /// You should override the staticPaint() method if you want dynamic painting.
  void dynamicPaint(Canvas canvas, Size size);
}

/// A custom painter that draw the staticPaint thanks to staticPaintScreenshot once and dynamicPaint mutiple times
class StaticAndDynamicCustomPainter extends widgets.CustomPainter {
  StaticAndDynamicCustomPainter({
    required this.painter,
    required this.staticPaintScreenshot,
  });

  final StaticAndDynamicPainter painter;

  final Image? staticPaintScreenshot;

  @override
  void paint(Canvas canvas, Size size) {
    if (staticPaintScreenshot != null) {
      canvas.drawImage(staticPaintScreenshot!, const Offset(0, 0), Paint());
    }

    painter.staticPaint(canvas, size);
    painter.dynamicPaint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant widgets.CustomPainter oldDelegate) => true;
}

class StaticCustomPaint extends widgets.StatefulWidget {
  const StaticCustomPaint({
    super.key,
    required this.painter,
    required this.size,
  });

  /// Provide a class that extends [StaticAndDynamicPainter], that override [static] and [dynamic] methods
  /// It should expose [screenshotCanvas] to save the staticPaint content
  final StaticAndDynamicPainter painter;

  /// Provide the size of the future canvas
  final Size size;

  @override
  widgets.State<StaticCustomPaint> createState() => _StaticCustomPaintState();
}

class _StaticCustomPaintState extends widgets.State<StaticCustomPaint> {
  Image? screenshot;

  @override
  void initState() {
    super.initState();
    // Screenshot the staticPaint to be static
    // Uncomment this line if you need to improve performances
    // It will screenshot the staticPaint once and use the same screenshot
    // when the widget is rebuilt.
    // Don't forget to use the screenshot in the [StaticAndDynamicCustomPainter.staticPaintScreenshot]
    // screenshot = widget.painter.saveStaticCanvas(widget.size);
  }

  @override
  widgets.Widget build(widgets.BuildContext context) {
    return widgets.CustomPaint(
      painter: StaticAndDynamicCustomPainter(
        painter: widget.painter,
        staticPaintScreenshot: screenshot,
      ),
      size: widget.size,
    );
  }
}
