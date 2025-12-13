// Controller
import 'package:flutter/material.dart';

/// This class used to control animations, using methods like hide or show
class WeSlideController extends ValueNotifier<bool> {
  bool _disposed = false;

  /// WeSlideController Construction
  // ignore: avoid_positional_boolean_parameters
  WeSlideController({bool initial = false}) : super(initial);

  /// show WeSlide Panel
  void show() {
    if (!_disposed) {
      value = true;
    }
  }

  /// hide WeSlide Panel
  void hide() {
    if (!_disposed) {
      value = false;
    }
  }

  /// Returns if the WeSlide Panel is opened or not
  bool get isOpened => value;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
