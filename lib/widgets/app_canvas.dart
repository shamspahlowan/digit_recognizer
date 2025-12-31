import 'package:digit_recognizer/drawing/painter.dart';
import 'package:digit_recognizer/models/stroke_model.dart';
import 'package:digit_recognizer/provider/stroke_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Fixed canvas size - use this everywhere
const double kCanvasSize = 280.0;

class AppCanvas extends ConsumerStatefulWidget {
  const AppCanvas({super.key});

  @override
  ConsumerState<AppCanvas> createState() => _AppCanvasState();
}

class _AppCanvasState extends ConsumerState<AppCanvas> {
  @override
  Widget build(BuildContext context) {
    final points = ref.watch(drawingProvider);
    return Container(
      width: kCanvasSize,
      height: kCanvasSize,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (details) {
          ref.read(drawingProvider.notifier).addPoint(details.localPosition);
        },
        onPanUpdate: (details) {
          ref.read(drawingProvider.notifier).addPoint(details.localPosition);
        },
        onPanEnd: (details) {
          ref.read(drawingProvider.notifier).endStroke();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CustomPaint(
            painter: Painter(points: points, settings: const StrokeSettings()),
            size: const Size(kCanvasSize, kCanvasSize),
          ),
        ),
      ),
    );
  }
}
