import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ImageProcessor {
  /// Find bounding box of all non-null points
  static Rect _getBoundingBox(List<Offset?> points) {
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final point in points) {
      if (point != null) {
        minX = point.dx < minX ? point.dx : minX;
        minY = point.dy < minY ? point.dy : minY;
        maxX = point.dx > maxX ? point.dx : maxX;
        maxY = point.dy > maxY ? point.dy : maxY;
      }
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  /// Captures drawing from points and returns a 28x28 ui.Image
  /// Centers and normalizes the digit like MNIST
  static Future<ui.Image> captureDrawing(
    List<Offset?> points,
    double canvasSize,
  ) async {
    // 1. Find bounding box of the drawing
    final bbox = _getBoundingBox(points);

    // Add some padding to the bounding box (stroke width consideration)
    const double strokePadding = 10.0;
    final paddedBbox = Rect.fromLTRB(
      bbox.left - strokePadding,
      bbox.top - strokePadding,
      bbox.right + strokePadding,
      bbox.bottom + strokePadding,
    );

    // 2. Calculate scaling to fit in 20x20 (leaving 4px padding on each side for 28x28)
    const double targetSize = 20.0;
    const double padding = 4.0;

    final double bboxWidth = paddedBbox.width;
    final double bboxHeight = paddedBbox.height;
    final double maxDimension = bboxWidth > bboxHeight ? bboxWidth : bboxHeight;

    // Scale factor to fit the digit into 20x20
    final double scale = maxDimension > 0 ? targetSize / maxDimension : 1.0;

    // 3. Calculate offset to center the digit
    final double scaledWidth = bboxWidth * scale;
    final double scaledHeight = bboxHeight * scale;
    final double offsetX =
        padding + (targetSize - scaledWidth) / 2 - paddedBbox.left * scale;
    final double offsetY =
        padding + (targetSize - scaledHeight) / 2 - paddedBbox.top * scale;

    // 4. Create a recorder
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // 5. Fill background with black
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 28, 28),
      Paint()..color = Colors.black,
    );

    // 6. Draw white strokes (centered and scaled)
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth =
          2.5 // Good thickness for 28x28
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        // Transform points: scale and center
        final p1 = Offset(
          points[i]!.dx * scale + offsetX,
          points[i]!.dy * scale + offsetY,
        );
        final p2 = Offset(
          points[i + 1]!.dx * scale + offsetX,
          points[i + 1]!.dy * scale + offsetY,
        );
        canvas.drawLine(p1, p2, paint);
      }
    }

    // 7. End recording and create image
    final picture = recorder.endRecording();
    final image = await picture.toImage(28, 28);

    return image;
  }

  /// Converts ui.Image to Float32List shaped [1, 28, 28, 1]
  static Future<Float32List> imageToInputArray(ui.Image image) async {
    // Get raw RGBA byte data
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final pixels = byteData!.buffer.asUint8List();

    // Create Float32List for model input (28 * 28 = 784)
    final Float32List inputArray = Float32List(28 * 28);

    // Extract grayscale values (every 4 bytes: R, G, B, A - use R channel)
    for (int i = 0; i < 28 * 28; i++) {
      // Get R value (grayscale, so R=G=B)
      final int r = pixels[i * 4];
      // Normalize to 0-1 range (divide by 255)
      inputArray[i] = r / 255.0;
    }

    return inputArray;
  }

  /// Full pipeline: points -> model input
  static Future<Float32List> processDrawing(
    List<Offset?> points,
    double canvasSize,
  ) async {
    final image = await captureDrawing(points, canvasSize);
    final inputArray = await imageToInputArray(image);
    return inputArray;
  }
}
