import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';

class ClassifierService {
  Interpreter? _interpreter;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  /// Load the TFLite model
  Future<void> loadModel() async {
    if (_isLoaded) return;

    try {
      _interpreter = await Interpreter.fromAsset('assets/mnist_cnn.tflite');
      _isLoaded = true;
      print('Model loaded successfully');
    } catch (e) {
      print('Error loading model: $e');
      rethrow;
    }
  }

  /// Predict digit from input array
  /// Input: Float32List of 784 values (28x28)
  /// Returns: predicted digit (0-9)
  int predict(Float32List input) {
    if (!_isLoaded || _interpreter == null) {
      throw Exception('Model not loaded. Call loadModel() first.');
    }

    // Reshape input to [1, 28, 28, 1]
    final inputReshaped = input.reshape([1, 28, 28, 1]);

    // Output: [1, 10] for 10 digit classes
    final output = List.filled(10, 0.0).reshape([1, 10]);

    // Run inference
    _interpreter!.run(inputReshaped, output);

    // Find the digit with highest probability
    final List<double> probabilities = output[0];
    int predictedDigit = 0;
    double maxProb = probabilities[0];

    for (int i = 1; i < probabilities.length; i++) {
      if (probabilities[i] > maxProb) {
        maxProb = probabilities[i];
        predictedDigit = i;
      }
    }

    print('Probabilities: $probabilities');
    print('Predicted digit: $predictedDigit (confidence: $maxProb)');

    return predictedDigit;
  }

  /// Clean up resources
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isLoaded = false;
  }
}
