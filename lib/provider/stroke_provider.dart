import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple notifier that manages a list of points
class DrawingNotifier extends Notifier<List<Offset?>> {
  @override
  List<Offset?> build() => []; // Initial empty list

  /// Add a point while drawing
  void addPoint(Offset point) {
    state = [...state, point];
  }

  /// Add null to break the line (when finger lifts)
  void endStroke() {
    state = [...state, null];
  }

  /// Clear the canvas
  void clear() {
    state = [];
  }
}

/// Provider: access points anywhere
final drawingProvider = NotifierProvider<DrawingNotifier, List<Offset?>>(
  DrawingNotifier.new,
);
