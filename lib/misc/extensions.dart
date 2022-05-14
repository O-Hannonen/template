import 'package:flutter/material.dart';

extension ThemeShortcut on BuildContext {
  ColorScheme get pallette => Theme.of(this).colorScheme;
}
