import 'package:flutter/material.dart';

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
