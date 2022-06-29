import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/misc/extensions.dart';

/// This can be used to show a basic message popup at the top of the screen.
void showSnackbar({
  /// The title of the snackbar (short text).
  required String title,

  /// The text of the snackbar (long text).
  required String text,

  /// How long the snackbar will be visible before closing automatically. Defaults to `const Duration(seconds: 3)`
  Duration duration = const Duration(seconds: 3),

  /// An optional callback which is called when the user taps the snackbar.
  Function()? onTap,
}) {
  final pallette = Get.context!.pallette;
  Get.snackbar(
    title,
    text,
    titleText: Container(),
    duration: duration,
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.only(
      left: 15.0,
      right: 15.0,
      top: 10.0,
    ),
    boxShadows: const [
      BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 15.0,
        spreadRadius: 3.0,
        color: Colors.black45,
      )
    ],
    isDismissible: true,
    onTap: (_) {
      if (onTap != null) {
        onTap();
      }
    },
    snackPosition: SnackPosition.TOP,
    backgroundColor: pallette.inverseSurface,
    borderRadius: 25,
    snackStyle: SnackStyle.FLOATING,
    colorText: pallette.onInverseSurface,
  );
}
