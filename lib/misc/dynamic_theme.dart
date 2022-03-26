import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/misc/logger.dart';

/// This abstract class that contains all of the color names used in the app. The actual implementation of
/// the colors is handled by `_DarkPallette` and `_LightPallette`, and the implementation of dynamic theming
/// is handled by `DynamicTheme`.
/// Note: To add new colors to your app, add the abstract definitions in to this class and your editor will
/// tell you where you should add the implementations.
abstract class _ColorPallette {
  /// The primary color that makes the app stand out. This color is used in buttons etc.
  Color get primaryColor;

  /// The color used as the background color.
  Color get backgroundColor;

  /// The color used as the background color for an element that needs to be visually separated from the actual background.
  Color get secondaryBackgroundColor;

  /// The text color that is used when text is displayed on top of `primaryColor`.
  Color get primaryTextColor;

  /// The text color that is used when text is displayed on top of `backgroundColor`.
  Color get backgroundTextColor;

  /// The text color that is used when text is displayed on top of `secondaryBackgroundColor`.
  Color get secondaryBackgroundTextColor;

  /// The color displayed behind dialogs etc.
  Color get barrierColor;
}

extension ThemeExtension on BuildContext {
  /// Provides an alternative way of accessing the color theme of the app. With this extension, developers can
  /// call `context.dynamicTheme` to retrieve the instance of `DynamicTheme`. Thus, calling `context.dynamicTheme`
  /// is the same as calling `DynamicTheme.instance`.
  DynamicTheme get dynamicTheme => DynamicTheme.instance;
}

/// `DynamicTheme` is a way to access the color pallette of the app. It changes
/// automatically the theme based on the devices theme. Colors can be accessed
/// through `DynamicTheme.instance`.
class DynamicTheme extends _ColorPallette {
  _ColorPallette _pallette = _DarkPallette();
  static DynamicTheme instance = DynamicTheme._();

  DynamicTheme._() {
    _refresh();
    WidgetsBinding.instance!.window.onPlatformBrightnessChanged = _refresh;
  }

  void _refresh() {
    logger.d('Refreshing color!');
    var brightness = WidgetsBinding.instance!.window.platformBrightness;
    if (brightness == Brightness.dark) {
      logger.d('Using dark pallette');
      _pallette = _DarkPallette();
    } else {
      logger.d('Using light pallette');
      _pallette = _LightPallette();
    }
  }

  @override
  Color get primaryColor => _pallette.primaryColor;

  @override
  Color get backgroundColor => _pallette.backgroundColor;

  @override
  Color get secondaryBackgroundColor => _pallette.secondaryBackgroundColor;

  @override
  Color get primaryTextColor => _pallette.primaryTextColor;

  @override
  Color get backgroundTextColor => _pallette.backgroundTextColor;

  @override
  Color get secondaryBackgroundTextColor => _pallette.secondaryBackgroundTextColor;

  @override
  Color get barrierColor => _pallette.barrierColor;
}

/// This defines how the colors of the app should look when the device is in dark mode.
class _DarkPallette implements _ColorPallette {
  @override
  Color get primaryColor => const Color.fromARGB(255, 67, 201, 221);

  @override
  Color get backgroundColor => Colors.grey[900]!;

  @override
  Color get secondaryBackgroundColor => Colors.grey[800]!;

  @override
  Color get primaryTextColor => const Color.fromARGB(255, 49, 49, 49);

  @override
  Color get backgroundTextColor => Colors.white;

  @override
  Color get secondaryBackgroundTextColor => Colors.white;

  @override
  Color get barrierColor => const Color(0x99000000);
}

/// This defines how the colors of the app should look when the device is in light mode.
class _LightPallette implements _ColorPallette {
  @override
  Color get primaryColor => const Color.fromRGBO(45, 131, 144, 1.0);

  @override
  Color get backgroundColor => Colors.white;

  @override
  Color get secondaryBackgroundColor => const Color.fromRGBO(238, 238, 238, 1.0);

  @override
  Color get primaryTextColor => Colors.white;

  @override
  Color get backgroundTextColor => Colors.black;

  @override
  Color get secondaryBackgroundTextColor => Colors.black;

  @override
  Color get barrierColor => const Color(0x99000000);
}
