import 'package:flutter/material.dart';
import 'package:template/misc/constants.dart';

extension ScaleExtension on BuildContext {
  /// Provides an alternative way of accessing `Scale`. With this extension, developers can
  /// call `context.scale` to retrieve the instance of `Scale`. Thus, calling `context.scale`
  /// is the same as calling `Scale.instance`.
  Scale get scale => Scale.instance;
}

/// This class can be used to scale stuff to a width/height percentage of the screen
/// or to scale font size according to the screen size.
class Scale {
  static num? _width;
  static num? _height;
  static num? _safeHeight;
  static num? _safeWidth;
  static double? _textScaleFactor;

  /// Singleton instance of this class
  static final Scale _instance = Scale._();

  Scale._() {
    var wb = WidgetsFlutterBinding.ensureInitialized();
    final mq = MediaQueryData.fromWindow(wb.window);

    _width = mq.size.width;
    _height = mq.size.height;
    _safeWidth = _width! - mq.padding.horizontal;
    _safeHeight = _height! - mq.padding.vertical;
    _textScaleFactor = (_width! / kDesignDeviceWidth);
  }

  /// Returns the singleton instance of this class.
  static Scale get instance => _instance;

  /// Returns a width that fills the given percentage of the screen on the horizontal axis.
  /// `percentage` must be between 0.0 (inclusive) and 1.0 (inclusive)
  double wPercentage(double percentage) {
    assert(percentage >= 0.0 && percentage <= 1.0 && _width != null);
    return percentage * _width!;
  }

  /// Returns a height that fills the given percentage of the screen on the vertical axis.
  /// `percentage` must be between 0.0 (inclusive) and 1.0 (inclusive)
  double hPercentage(double percentage) {
    assert(percentage >= 0.0 && percentage <= 1.0 && _height != null);
    return percentage * _height!;
  }

  /// Returns a width that fills the given percentage of the safe area on the horizontal axis.
  /// `percentage` must be between 0.0 (inclusive) and 1.0 (inclusive)
  double swPercentage(double percentage) {
    assert(percentage >= 0.0 && percentage <= 1.0 && _safeWidth != null);
    return percentage * _safeWidth!;
  }

  /// Returns a height that fills the given percentage of the safe area on the vertical axis.
  /// `percentage` must be between 0.0 (inclusive) and 1.0 (inclusive)
  double shPercentage(double percentage) {
    assert(percentage >= 0.0 && percentage <= 1.0 && _safeHeight != null);
    return percentage * _safeHeight!;
  }

  /// Takes the width (pixels) of an element on the design device as input.
  /// Returns the width (pixels) of the element on the current device, so that
  /// the element takes up the same percentage of the screen on both design device
  /// and current device. This calculation uses only the widths of the devices.
  /// In order to scale according to the height, use `Scale.hRelative()`
  double wRelative(double widthOnDesignDevice) {
    return (widthOnDesignDevice / kDesignDeviceWidth) * _width!;
  }

  /// Takes the height (pixels) of an element on the design device as input.
  /// Returns the height (pixels) of the element on the current device, so that
  /// the element takes up the same percentage of the screen on both design device
  /// and current device. This calculation uses only the heights of the devices.
  /// In order to scale according to the width, use `Scale.wRelative()`
  double hRelative(double heightOnDesignDevice) {
    return (heightOnDesignDevice / kDesignDeviceHeight) * _height!;
  }

  /// Multiplier which is used to scale text based on the device's width.
  /// Also disables devices own scale factor, so the app does not look weird
  /// on any device.
  double get textScaleFactor => _textScaleFactor ?? 1.0;
}
