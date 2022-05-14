import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/misc/behaviors.dart';
import 'package:template/misc/extensions.dart';

import 'package:template/misc/scale.dart';

/// This reusable dialog defines how a basic dialog should look in the app. It returns a future, that
/// resolves to the value returned by popping the dialog. The dialog can be closed by calling `Get.back()` or
/// `Navigator.of(context).pop()`.
Future<dynamic> displayDialog({
  /// List of children to be displayed in a vertical list inside the dialog
  required List<Widget> children,

  /// Whether or not the dialog can be closed by tapping outside of its bounds. If `hasInputFields` is set to `true`,
  /// this will be ignored.
  bool barrierDismissible = true,

  /// Whether or not the content should be scrollable
  bool scrollable = true,

  /// If the dialog contains any inputfields, this should be set to `true`. This defaults to `false`.
  /// Setting this to `true` will make sure the input fields won't be stuck behind keyboard when activated
  /// (window is resized to make inputfields visible). NOTE: If the dialog does not contain inputfields,
  /// this shall not be manually set to true, since it disables the ability to dismiss the dialog
  /// by tapping outside of it (`barrierDismissible` property will be ignored.).
  bool hasInputFields = false,

  /// Padding of the content inside the dialog, defaults to `EdgeInsets.zero`
  EdgeInsets padding = EdgeInsets.zero,

  /// An optional name for the route, defaults to `/dialog`
  String label = '/dialog',

  /// The color of the dialogs background. Defaults to `DynamicTheme.instance.backgroundColor`
  Color? backgroundColor,
}) async {
  final scale = Scale.instance;
  final pallette = Get.context!.pallette;
  return await Get.to(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: barrierDismissible,
      barrierColor: pallette.shadow,
      barrierLabel: label,
      settings: RouteSettings(name: label),
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, a1, a2, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = a1.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      pageBuilder: (context, a1, a2) {
        Widget child = ScrollConfiguration(
          behavior: NoOverscrollBehavior(),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: scale.textScaleFactor,
            ),
            child: SafeArea(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Material(
                      type: MaterialType.transparency,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: scale.wRelative(33)),
                            padding: padding,
                            constraints: BoxConstraints(
                              maxHeight:
                                  constraints.maxHeight - scale.hRelative(120),
                            ),
                            decoration: BoxDecoration(
                              color: backgroundColor ?? pallette.background,
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: scrollable
                                ? ListView(
                                    shrinkWrap: true,
                                    children: children,
                                  )
                                : SingleChildScrollView(
                                    reverse: true,
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxHeight: constraints.maxHeight -
                                            scale.hRelative(120) -
                                            padding.vertical,
                                      ),
                                      child: Column(
                                        children: children,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
        if (hasInputFields) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: child,
          );
        }
        return child;
      },
    ),
  );
}
