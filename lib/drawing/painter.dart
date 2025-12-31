import 'package:digit_recognizer/models/stroke_model.dart';
import 'package:flutter/material.dart';

class Painter extends CustomPainter {
  final List<Offset?> points;
  final StrokeSettings settings;

  Painter({required this.points, required this.settings});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = settings.strokeColor
      ..strokeWidth = settings.strokeWidth
      ..strokeCap = settings.strokeCap
      ..style = PaintingStyle.stroke;

    // Draw lines between consecutive non-null points
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant Painter oldDelegate) {
    return oldDelegate.points != points;
  }
}
