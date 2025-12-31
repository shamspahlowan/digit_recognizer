import 'package:flutter/material.dart';

/// Holds stroke style settings (used by Painter)
class StrokeSettings {
  final Color strokeColor;
  final double strokeWidth;
  final StrokeCap strokeCap;

  const StrokeSettings({
    this.strokeColor = Colors.white,
    this.strokeWidth = 5.0,
    this.strokeCap = StrokeCap.round,
  });
}
