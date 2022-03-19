import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:template/misc/dynamic_theme.dart';

class SvgIcon extends StatelessWidget {
  /// A path to the SVG asset.
  final String assetName;

  /// The width and height of the icon. Defaults to 22.0
  final double size;

  /// The color of the icon. Defaults to `DynamicTheme.instance.primaryColor`. If `overrideColor` is set to
  /// `true`, this will be the only color of the icon. If `overrideColor` is set to `false`, this will be ignored
  /// and the icon will be displayed with the SVGs original color.
  final Color? color;

  ///If `overrideColor` is set to `true`, `color` will be the only color of the icon. If `overrideColor` is set to
  ///`false`, `color` will be ignored and the icon will be displayed with the SVGs original color.
  final bool overrideColor;

  SvgIcon({
    Key? key,
    required this.assetName,
    this.size = 22.0,
    this.color,
    this.overrideColor = true,
  }) : super(key: key) {
    assert(assetName.contains('.svg'));
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? context.dynamicTheme.primaryColor;
    return SvgPicture.asset(
      assetName,
      color: overrideColor ? iconColor : null,
      width: size,
      height: size,
    );
  }
}
