import 'package:flutter/material.dart';

/// This file contains custom behaviors to override platform specific ones

class NoOverscrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
