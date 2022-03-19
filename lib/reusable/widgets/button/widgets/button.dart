import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/misc/dynamic_theme.dart';
import 'package:template/misc/scale.dart';
import 'package:template/resources/styles.dart';
import 'package:template/reusable/widgets/button/cubit/button_cubit.dart';
import 'package:template/services/service_locator.dart';
import 'package:template/services/vibration_service.dart';
import 'package:template/reusable/widgets/svg_icon.dart';

enum ButtonType {
  /// A text contains a given text in the middle. Optionally, it can also display
  /// a icon on the left or right side of the text. Those icons must be specified using
  /// `leftIcon` and `rightIcon`. The height of the button is determined by `height` and
  /// the width is as wide as the text+icon requires.
  text,

  /// An icon contains the given `icon` in the middle. The button is completely round, and
  /// the dimensions are controlled by `iconButtonSize`
  icon,
}

/// This reusable widget defines how all of the buttons shall look
/// and behave in the app.
class Button extends StatefulWidget {
  /// A function that gets called whenever the button is tapped
  final Function() onTap;

  /// The type of the button. Either `ButtonType.text` or `ButtonType.icon`. Default is `ButtonType.text`
  final ButtonType type;

  /// If `type` is `ButtonType.icon`, this is the icon that is displayed in the button.
  final String? icon;

  /// If `type`is `ButtonType.text`, this is the text that is displayed in the button. This must be a path to
  /// a SVG file.
  final String? text;

  /// If `type` is `ButtonType.icon`, this controls the width and height of the button. Defaults to `50.0`
  final double iconButtonSize;

  /// A path to an SVG file to be shown on the left side of the text. Only available, if `type` is `ButtonType.text`.
  final String? leftIcon;

  /// A path to an SVG file to be shown on the right side of the text. Only available, if `type` is `ButtonType.text`.
  final String? rightIcon;

  /// The color of the buttons background. Defaults to `DynamicTheme.instance.primaryColor`
  final Color? buttonColor;

  /// The color of the border. Defaults to `DynamicTheme.instance.primaryTextColor`
  final Color? borderColor;

  /// Padding between outlines of the button and the content. This value is
  /// automatically scaled based on the current screen size. Defaults to
  /// `EdgeInsets.symmetric(horizontal: 22.0)`
  final EdgeInsets? padding;

  /// Margin between outlines of the button and the content outside of it. This value is
  /// automatically scaled based on the current screen size. Defaults to `EdgeInsets.zero`
  final EdgeInsets? margin;

  /// The width and height of the icons used inside this button (`leftIcon`, `rightIcon` and `icon`)
  /// This value is automatically scaled based on the current screen size. Defaults to `22.0`
  final double iconSize;

  /// Height of the button. This value is automatically scaled based on the current screen size.
  /// Defaults to `60.0`.
  final double height;

  /// The spacing between the text and the icons (`leftIcon` and `rightIcon`). This value is
  /// automatically scaled based on the current screen size. Defaults to `8.0`
  final double iconSpacing;

  /// This can be used to disable the button. If this is set to `false`, the button won't
  /// react to any touch events and it will appear inactive. Defaults to `true`.
  final bool enabled;

  /// Whether or not the phone should vibrate when the button is pressed. Defaults to `true`.
  final bool vibrate;

  /// Whether or not the button should cast shadows to the background. Defaults to `true`.
  final bool enableShadow;

  /// Whether or not the button should have borders. Defaults to `false`.
  final bool enableBorders;

  /// The style of the text of the button. This also controls the color of the icons.
  final TextStyle textStyle;

  /// The size of the icons+text row. Defaults to `MainAxisSize.min`.
  final MainAxisSize mainAxisSize;

  /// The alignment of the icon+text row. Defaults to `MainAxisAlignment.spaceAround`.
  final MainAxisAlignment mainAxisAlignment;

  Button({
    Key? key,
    required this.onTap,
    this.text,
    this.leftIcon,
    this.rightIcon,
    this.buttonColor,
    this.borderColor,
    this.padding,
    this.margin,
    this.height = 60.0,
    this.iconButtonSize = 50.0,
    this.iconSize = 22.0,
    this.iconSpacing = 8.0,
    this.enabled = true,
    this.vibrate = true,
    this.enableShadow = true,
    this.enableBorders = false,
    this.textStyle = textStyleBody,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.type = ButtonType.text,
    this.icon,
  }) : super(key: UniqueKey()) {
    if (leftIcon != null) assert(leftIcon!.contains('.svg'));
    if (rightIcon != null) assert(rightIcon!.contains('.svg'));
    if (type == ButtonType.text) {
      assert(text != null);
    } else {
      assert(icon != null);
      assert(icon!.contains('.svg'));
    }
  }

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  final VibrationService? _vibrator = locator<VibrationService>();
  final scale = Scale.instance;
  late ButtonCubit buttonCubit;

  @override
  void initState() {
    buttonCubit = ButtonCubit();
    super.initState();
  }

  @override
  void dispose() {
    buttonCubit.close();
    super.dispose();
  }

  final Color shadowColor = const Color.fromRGBO(0, 0, 0, 0.25);

  /// This is used to calculate the buttons darker color, when its pressed.
  Color _adjustColor(Color baseColor, double amount) {
    var colors = <String, int>{'r': baseColor.red, 'g': baseColor.green, 'b': baseColor.blue};
    colors = colors.map((key, value) {
      if (value + amount < 0) {
        return MapEntry(key, 0);
      }
      if (value + amount > 255) {
        return MapEntry(key, 255);
      }
      return MapEntry(key, (value + amount).floor());
    });
    return Color.fromRGBO(colors['r']!, colors['g']!, colors['b']!, baseColor.opacity);
  }

  @override
  Widget build(BuildContext context) {
    var _height = scale.wRelative(widget.height);
    var _iconSpacing = scale.wRelative(widget.iconSpacing);
    var _iconButtonSize = scale.wRelative(widget.iconButtonSize);
    var _padding = widget.padding == null
        ? EdgeInsets.symmetric(horizontal: scale.wRelative(22.0))
        : EdgeInsets.only(
            left: scale.wRelative(widget.padding!.left),
            right: scale.wRelative(widget.padding!.right),
            top: scale.hRelative(widget.padding!.top),
            bottom: scale.hRelative(widget.padding!.bottom),
          );

    var _margin = widget.margin == null
        ? EdgeInsets.zero
        : EdgeInsets.only(
            left: scale.wRelative(widget.margin!.left),
            right: scale.wRelative(widget.margin!.right),
            top: scale.hRelative(widget.margin!.top),
            bottom: scale.hRelative(widget.margin!.bottom),
          );

    var _textColor = widget.textStyle.color ?? context.dynamicTheme.primaryTextColor;

    return BlocProvider(
      create: (context) => ButtonCubit(),
      child: BlocBuilder<ButtonCubit, ButtonState>(
        builder: (context, state) {
          return GestureDetector(
            onTapDown: (details) {
              if (!mounted) return;
              buttonCubit.setPressed(true);
            },
            onTapCancel: () {
              if (!mounted) return;
              buttonCubit.setPressed(false);
            },
            onTapUp: (details) async {
              if (!mounted) return;
              if (widget.enabled) {
                _vibrator!.selectionClick();
                widget.onTap();
              }

              await Future.delayed(const Duration(milliseconds: 100));
              buttonCubit.setPressed(false);
            },
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 50),
                height: widget.type == ButtonType.icon ? _iconButtonSize : _height,
                width: widget.type == ButtonType.icon ? _iconButtonSize : null,
                padding: _padding,
                margin: _margin,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_height),
                  color:
                      _adjustColor(widget.buttonColor ?? context.dynamicTheme.primaryColor, state.pressed || !widget.enabled ? -70.0 : 0.0),
                  border: widget.enableBorders
                      ? Border.all(
                          width: 3,
                          color: _adjustColor(
                              widget.borderColor ?? context.dynamicTheme.primaryTextColor, state.pressed || !widget.enabled ? -70.0 : 0.0),
                        )
                      : null,
                  boxShadow: [
                    if (widget.enabled && widget.enableShadow)
                      BoxShadow(
                        color: shadowColor.withOpacity(state.pressed ? 0.5 : 0.7),
                        blurRadius: 4.0,
                        offset: Offset(0, state.pressed ? 0 : 2),
                      ),
                  ],
                ),
                child: widget.type == ButtonType.icon
                    ? SvgIcon(
                        assetName: widget.icon!,
                        color: _adjustColor(_textColor, state.pressed || !widget.enabled ? -70.0 : 0.0),
                        size: widget.iconSize * scale.textScaleFactor,
                      )
                    : Row(
                        mainAxisSize: widget.mainAxisSize,
                        mainAxisAlignment: widget.mainAxisAlignment,
                        children: [
                          if (widget.leftIcon != null) ...[
                            SvgIcon(
                              assetName: widget.leftIcon!,
                              color: _adjustColor(_textColor, state.pressed || !widget.enabled ? -70.0 : 0.0),
                              size: widget.iconSize * scale.textScaleFactor,
                            ),
                            SizedBox(
                              width: _iconSpacing,
                            ),
                          ] else if (widget.rightIcon != null)
                            SizedBox(
                              width: widget.iconSize * scale.textScaleFactor + _iconSpacing,
                            ),
                          if (widget.text != null)
                            Text(
                              widget.text!,
                              textAlign: TextAlign.center,
                              style: widget.textStyle.copyWith(
                                color: _adjustColor(_textColor, state.pressed || !widget.enabled ? -70.0 : 0.0),
                              ),
                            ),
                          if (widget.rightIcon != null) ...[
                            SizedBox(
                              width: _iconSpacing,
                            ),
                            SvgIcon(
                              assetName: widget.leftIcon!,
                              color: _adjustColor(_textColor, state.pressed || !widget.enabled ? -70.0 : 0.0),
                              size: widget.iconSize * scale.textScaleFactor,
                            ),
                          ] else if (widget.leftIcon != null)
                            SizedBox(
                              width: widget.iconSize * scale.textScaleFactor + _iconSpacing,
                            ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
