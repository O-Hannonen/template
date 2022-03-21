import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:template/misc/constants.dart';
import 'package:template/misc/logger.dart';
import 'package:template/services/analytics_service.dart';
import 'package:template/services/dynamic_links_service.dart';
import 'package:template/services/push_notification_service.dart';

import 'package:template/services/service_locator.dart';

/// This function contains stuff that needs to run before calling runApp();
Future initializeBeforeRunApp() async {
  logger.d('Initialize before runApp()');

  if (kEnableFirebaseAuthentication || kEnableFirebaseDynamicLinks || kEnableFirebaseMessaging || kEnableFirebaseCrashlytics) {
    /// Any of the services above cannot work without firebase core enabled.
    assert(kEnableFirebase);
  }

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// Keeps the app from automatically closing the native splash screen.
  /// Native splash screen can be closed by calling widgetsBinding.allowFirstFrame().
  /// It is closed in lib/startup_logic/cubit/startup_logic_cubit.dart
  widgetsBinding.deferFirstFrame();

  await setupServiceLocator();

  await GetStorage.init();

  if (kEnableFirebase) {
    await Firebase.initializeApp(

        /// When enabling Firebase, make sure to uncomment the line below.
        // options: DefaultFirebaseOptions.currentPlatform,
        );
  }
}

/// This function contains stuff that needs to run after calling runApp() AND before
/// building `GetMaterialApp`. The biggest difference to `initializeBeforeRunApp()` is,
/// that this function has access to `BuildContext`.
Future initializeAfterRunApp(BuildContext context) async {
  logger.d('Initialize after runApp()');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (kEnableFirebase) await locator<AnalyticsService>().logAppOpen();
}

/// This function contains stuff that needs to run after startup logic is finished, and
/// the apps main screen is opened.
Future initializeAfterStartupLogic() async {
  logger.d('Initialize after startup logic');
  if (kEnableFirebaseDynamicLinks) await locator<DynamicLinkService>().initialize();
  if (kEnableFirebaseMessaging) await locator<PushNotificationService>().initialize();
  if (kEnableFirebase) await locator<AnalyticsService>().logStartupLogicComplete();
}
