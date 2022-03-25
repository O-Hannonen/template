import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:template/generated/l10n.dart';
import 'package:template/misc/constants.dart';
import 'package:template/misc/dynamic_theme.dart';
import 'package:template/resources/assets.dart';
import 'package:template/resources/styles.dart';
import 'package:template/startup_logic/cubit/startup_logic_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A basic loading screen. Uses the picture specified in `assets/splash_screen.png` as background (same
/// picture as the native spash screen uses if setup correctly). It also can show loading indicator at the
/// bottom, if specified so with `kShowLoadingINdicatorOnStartup` in `constants.dart`
class LoadingScreen extends StatelessWidget {
  /// Loading progress to be shown at the bottom of the screen (if `kShowLoadingINdicatorOnStartup` is `true`).
  /// Value must be between 0.0 (inclusive) and 100.0 (inclusive).
  final num progress;
  LoadingScreen({
    Key? key,
    required this.progress,
  }) : super(key: key) {
    assert(progress >= 0.0 && progress <= 100.0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            splashScreen,
            fit: BoxFit.fill,
          ),
        ),
        if (kShowLoadingIndicatorOnStartup)
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: FadeIn(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Stack(
                  children: [
                    LinearProgressIndicator(
                      value: progress / 100.0,
                      minHeight: 48,
                      backgroundColor: context.dynamicTheme.backgroundColor,
                      valueColor: AlwaysStoppedAnimation<Color>(context.dynamicTheme.primaryColor.withOpacity(0.33)),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          L.of(context).loadingProgress(progress.toString()),
                          style: textStyleBold.copyWith(
                            fontSize: 12,
                            color: context.dynamicTheme.backgroundTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }
}
