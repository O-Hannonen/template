import 'package:flutter/material.dart';
import 'package:template/generated/l10n.dart';

extension ContextShortcuts on BuildContext {
  /// A shortcut to get the current themes ColorScheme object
  ColorScheme get pallette => Theme.of(this).colorScheme;

  /// A shortcut to get localizations object
  L get local => L.of(this);

  /// A shortcut to get localizations object
  L get localizations => L.of(this);

  /// A shortcut to get localizations object
  L get l => L.of(this);
}
