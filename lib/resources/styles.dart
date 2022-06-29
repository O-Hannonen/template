import 'package:flutter/material.dart';

/// This file is for storing your apps styles (fonts, themes etc)
/// To add custom font style, import the family to pubspec.yaml and add the font family name
/// as string here, like so:
/// const _fontFamily = 'Jost';
const _fontFamily = null;

/// Change these to apply different color pallettes to the app. You can use the following tool to generate pallettes:
/// https://material-foundation.github.io/material-theme-builder/#/dynamic
const seed = Color(0xFF6750A4);
final lightColorScheme = ColorScheme.fromSeed(
  seedColor: seed,
  brightness: Brightness.light,
);
final darkColorScheme = ColorScheme.fromSeed(
  seedColor: seed,
  brightness: Brightness.dark,
);

const textStyleH1 = TextStyle(
  fontFamily: _fontFamily,
  fontWeight: FontWeight.w700,
  fontSize: 28.0,
);

const textStyleH2 = TextStyle(
  fontFamily: _fontFamily,
  fontWeight: FontWeight.w700,
  fontSize: 24.0,
);

const textStyleH3 = TextStyle(
  fontFamily: _fontFamily,
  fontWeight: FontWeight.w700,
  fontSize: 20.0,
);

const textStyleBody = TextStyle(
  fontFamily: _fontFamily,
  fontWeight: FontWeight.w400,
  fontSize: 18.0,
);

const textStyleBold = TextStyle(
  fontFamily: _fontFamily,
  fontWeight: FontWeight.w900,
  fontSize: 18.0,
);

const textStyleSemiBold = TextStyle(
  fontFamily: _fontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 18.0,
);

const textStyleItalic = TextStyle(
  fontFamily: _fontFamily,
  fontWeight: FontWeight.w400,
  fontStyle: FontStyle.italic,
  fontSize: 18.0,
);
