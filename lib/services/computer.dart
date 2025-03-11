import 'dart:math';

import 'package:dark_validator/services/core.dart';
import 'package:flutter/services.dart';

class SumSinBreath {
  final List<Offset> buffer = [];

  void update() {
    final breathing = breathingFeeder.value?.buffer;
    final sin = sinFeeder.value?.buffer;
    buffer.add(
      Offset(buffer.length.toDouble(), (breathing?.last.dy ?? 0) + (sin?.last.dy ?? 0)),
    );
  }
}

class RampUpBreath {
  final List<Offset> buffer = [];
  
  // Window size for computing tendency
  final int windowSize = 10; // Consider last 10 values for trend calculation
  
  // Minimum window size required to perform calculation
  final int minWindowSize = 5;
  
  void update() {
    final breathing = breathingFeeder.value?.buffer;
    if (breathing == null || breathing.length < minWindowSize) {
      buffer.add(Offset(buffer.length.toDouble(), 0));
      return;
    }

    // Get last windowSize values or as many as available
    final windowLength = min(windowSize, breathing.length);
    final window = breathing.sublist(breathing.length - windowLength, breathing.length);
    
    // Compute trend using linear regression
    double tendency = _computeTendency(window);
    
    // Return 1 when ramping up (positive tendency), 0 otherwise
    int isRampingUp = tendency > 0 ? 1 : 0;
    
    buffer.add(
      Offset(buffer.length.toDouble(), isRampingUp.toDouble()),
    );
  }
  
  /// Calculates the tendency of values in the given window using linear regression
  /// Returns a value indicating the slope of the trend line
  double _computeTendency(List<Offset> window) {
    if (window.length < minWindowSize) return 0.0;
    
    // Calculate means
    double sumX = 0;
    double sumY = 0;
    
    for (int i = 0; i < window.length; i++) {
      sumX += i;
      sumY += window[i].dy;
    }
    
    double meanX = sumX / window.length;
    double meanY = sumY / window.length;
    
    // Calculate slope using least squares method
    double numerator = 0;
    double denominator = 0;
    
    for (int i = 0; i < window.length; i++) {
      numerator += (i - meanX) * (window[i].dy - meanY);
      denominator += (i - meanX) * (i - meanX);
    }
    
    // If denominator is zero (all x values are the same), return 0
    if (denominator == 0) return 0;
    
    // Return the slope (trend)
    return numerator / denominator;
  }
}
