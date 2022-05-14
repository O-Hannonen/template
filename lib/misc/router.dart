import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template/misc/constants.dart';
import 'package:template/misc/extensions.dart';
import 'package:template/misc/scale.dart';
import 'package:template/misc/behaviors.dart';
import 'package:template/resources/styles.dart';
import 'package:template/services/analytics_service.dart';
import 'package:template/services/service_locator.dart';
import 'package:template/startup_logic/widgets/startup_logic_screen.dart';

/// This is the router of the app. Every new route is pushed using this class. New routes can be pushed using Get:
/// ``` dart
/// Get.toNamed(CustomRouter.main, arguments: {})
/// ```
/// For more examples of Get routing, see https://pub.dev/packages/get#route-management
class CustomRouter {
  static const startupLogic = '/';
  static const main = '/';

  static Route<dynamic> generateRoute(RouteSettings s) {
    if (kEnableFirebase)
      locator<AnalyticsService>().logRouteChange(s.name ?? 'unknown');

    switch (s.name) {
      case startupLogic:
        return _cupertinoRouteBuilder(
          page: const StartupLogicScreen(),
          route: '${s.name}',
        );

      default:
        return _cupertinoRouteBuilder(
          page: Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${s.name}',
                style: textStyleH1.copyWith(),
              ),
            ),
          ),
          route: 'Unknown route: ${s.name}',
        );
    }
  }

  static Widget _route(
    BuildContext context,
    Widget page, {
    bool transparent = false,
  }) =>
      ScrollConfiguration(
        behavior: NoOverscrollBehavior(),
        child: Material(
          color: transparent ? Colors.transparent : context.pallette.background,
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaleFactor: Scale.instance.textScaleFactor),
            child: page,
          ),
        ),
      );

  // ignore: unused_element
  static Route<dynamic> _cupertinoRouteBuilder({
    required Widget page,
    required String route,
  }) {
    return CupertinoPageRoute(
      settings: RouteSettings(
        name: route,
      ),
      builder: (context) => _route(context, page),
    );
  }

  // ignore: unused_element
  static Route<dynamic> _materialRouteBuilder({
    required Widget page,
    required String route,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(
        name: route,
      ),
      builder: (context) => _route(context, page),
    );
  }

  // ignore: unused_element
  static Route<dynamic> _transparentRouteBuilder({
    required Widget page,
    required String route,
  }) {
    return PageRouteBuilder(
      settings: RouteSettings(
        name: route,
      ),
      opaque: false,
      pageBuilder: (context, _, __) => _route(
        context,
        page,
        transparent: true,
      ),
    );
  }
}
