import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:statusbarz/statusbarz.dart';
import 'package:template/generated/l10n.dart';
import 'package:template/misc/constants.dart';
import 'package:template/misc/initialize.dart';
import 'package:template/misc/lifecycle_manager/widgets/lifecycle_manager.dart';
import 'package:template/misc/router.dart';
import 'package:template/services/crashlytics_service.dart';
import 'package:template/services/service_locator.dart';

void main() async {
  await initializeBeforeRunApp();

  /// Catches uncaught errors and logs them to crashlytics.
  runZonedGuarded(
    () {
      runApp(const MyApp());
    },
    (error, stack) {
      if (kEnableFirebaseCrashlytics) {
        locator<CrashlyticsService>().recordError(
          'Unhandled error',
          error,
          stack,
        );
      }
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LifecycleManager(
      child: StatusbarzCapturer(
        child: GetMaterialApp(
          localizationsDelegates: const [
            L.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
          navigatorObservers: [
            Statusbarz.instance.observer, // Refreshes statusbar color automatically when new page opened
          ],
          onGenerateRoute: CustomRouter.generateRoute,
          initialRoute: CustomRouter.startupLogic,
        ),
      ),
    );
  }
}
