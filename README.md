# Digit Recognizer

Digit Recognizer is a Flutter application that allows users to draw digits on the screen and recognizes them using a pre-trained MNIST CNN model (TensorFlow Lite). The app demonstrates on-device machine learning inference and interactive drawing capabilities.

## Features
- Draw digits on a canvas
- Real-time digit recognition using a TFLite model
- Clean and intuitive UI
- Cross-platform support (Android, iOS, Web, Windows, macOS, Linux)

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart

### Installation
1. Clone the repository:
	```bash
	git clone https://github.com/shamspahlowan/digit_recognizer.git
	cd digit_recognizer
	```
2. Get dependencies:
	```bash
	flutter pub get
	```
3. Run the app:
	```bash
	flutter run
	```
	You can specify a device or platform as needed.

## Project Structure
- `lib/` - Main application code
  - `main.dart` - Entry point
  - `app.dart`, `home.dart` - App and home screens
  - `drawing/` - Canvas painter
  - `models/` - Data models
  - `provider/` - State management
  - `services/` - ML classifier service
  - `utils/` - Image processing utilities
  - `widgets/` - Custom widgets
- `assets/` - Contains the MNIST TFLite model
- `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/` - Platform-specific files

## Model
- The app uses a pre-trained MNIST CNN model converted to TensorFlow Lite format (`assets/mnist_cnn.tflite`).

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
This project is licensed under the MIT License.

## Acknowledgements
- [Flutter](https://flutter.dev/)
- [TensorFlow Lite](https://www.tensorflow.org/lite)
- [MNIST Dataset](http://yann.lecun.com/exdb/mnist/)
