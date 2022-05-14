import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:template/misc/extensions.dart';

import 'package:template/resources/styles.dart';
import 'package:template/services/service_locator.dart';
import 'package:template/services/vibration_service.dart';

/// This reusable widget defines how all of the input fields shall look
/// and behave in the app.
class InputField extends StatelessWidget {
  /// The space around the text field. Defaults to `EdgeInsets.zero`
  final EdgeInsets? margin;

  /// A widget to be shown on the left side of the input field
  final Widget? leading;

  /// A widget to be shown on the right side of the input field
  final Widget? action;

  /// A controller to access or manipulate the text in the input field.
  final TextEditingController? controller;

  /// Setting `obscure`to true will replace the characters of the text with '*'.
  /// This is especially useful with passwords.
  final bool obscure;

  /// A focusnode to programmatically focus on the input field.
  final FocusNode? focusNode;

  /// Text that is displayed when the fields is empty and unfocused.
  final String? label;

  /// Text that is displayed on the top of the input field all the time.
  final String? hint;

  /// A callback to be called when the input field value is changed.
  final Function(String?)? onChanged;

  /// A callback to be called when the input field is tapped.
  final Function()? onTap;

  /// A callback to be called when the input field is focused and user presses enter on the keyboard.
  final Function(String)? onSubmitted;

  /// Setting this to `true` allows the input field to change line. Defaults to `false`.
  final bool multiline;

  /// Provide an `inputFormatter` to format the text as the user types
  final TextInputFormatter? inputFormatter;

  /// Specify which type of keyboard to use (numeric etc.).
  final TextInputType? inputType;

  /// A list of strings that helps the autofill service identify the type of this text input.
  /// Setting this to `null` will disable autofill for this input field. Defaults to an empty list.
  final Iterable<String> autofillHints;

  /// A max length of characters for this input field.
  final int? maxLength;

  /// Optional text to place below the line as a character count.
  final String? counterText;

  const InputField({
    Key? key,
    this.margin,
    this.inputType,
    this.inputFormatter,
    this.leading,
    this.action,
    this.obscure = false,
    this.label,
    this.hint,
    this.focusNode,
    this.controller,
    this.multiline = false,
    this.onChanged,
    this.onSubmitted,
    this.autofillHints = const [],
    this.maxLength,
    this.counterText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = textStyleBody.copyWith(
      decoration: TextDecoration.none,
      decorationColor: Colors.transparent,
      color: context.pallette.surface,
    );

    return Container(
      constraints: BoxConstraints(
        minHeight: 44,
        maxHeight: multiline ? double.infinity : 44,
      ),
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          7.0,
        ),
        color: context.pallette.surface,
      ),
      child: Row(
        children: [
          if (leading != null) leading!,
          Expanded(
            child: TextField(
              autofillHints: autofillHints,
              maxLength: maxLength,
              inputFormatters: [
                if (inputFormatter != null) inputFormatter!,
              ],
              obscureText: obscure,
              controller: controller,
              focusNode: focusNode,
              style: textStyle,
              maxLines: multiline ? null : 1,
              keyboardType:
                  inputType ?? (multiline ? TextInputType.multiline : null),
              cursorColor: context.pallette.onSurface,
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                counterText: counterText,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                labelStyle: textStyle,
                border: InputBorder.none,
                hintStyle: textStyle.copyWith(color: const Color(0xffa1a1a1)),
              ),
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              onTap: () {
                locator<VibrationService>().selectionClick();
                if (onTap != null) onTap!();
              },
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
