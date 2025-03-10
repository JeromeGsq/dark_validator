// coverage:ignore-file

import 'package:flutter/material.dart';

extension CanvasExtension on Canvas {
  void flipX(double width) {
    final matrix = (Matrix4.identity()
      ..translate(width, 0)
      ..scale(-1.0, 1));

    transform(matrix.storage);
  }
}
