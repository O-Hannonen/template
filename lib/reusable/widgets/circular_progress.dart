import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:template/misc/extensions.dart';

/// This reusable widget defines how every single circular progress indicator
/// in the app should look. For customizing the appearance, see https://pub.dev/packages/flutter_spinkit
class CircularProgress extends StatelessWidget {
  /// Color of the progress indicator. Defaults to `DynamicTheme.instance.primaryColor`
  final Color? color;

  const CircularProgress({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 60.0,
        maxHeight: 60.0,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SpinKitCircle(
          color: color ?? context.pallette.primary,
        ),
      ),
    );
  }
}
