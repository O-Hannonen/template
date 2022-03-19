import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:template/misc/constants.dart';
import 'package:template/services/analytics_service.dart';
import 'package:template/services/dynamic_links_service.dart';

import 'package:template/services/service_locator.dart';

/// This function contains stuff that needs to run before calling runApp();
Future initializeBeforeRunApp() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// Keeps the app from automatically closing the native splash screen.
  /// Native splash screen can be closed by calling widgetsBinding.allowFirstFrame().
  /// It is closed in lib/startup_logic/cubit/startup_logic_cubit.dart
  widgetsBinding.deferFirstFrame();

  await setupServiceLocator();

  await GetStorage.init();

  if (kEnableFirebaseAuthentication) {
    /// Auth cannot work if firebase is not initialized.
    assert(kEnableFirebase);
  }

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
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await locator<AnalyticsService>().logAppOpen();
}

/// This function contains stuff that needs to run after startup logic is finished, and
/// the apps main screen is opened.
Future initializeAfterStartupLogic() async {
  await locator<DynamicLinkService>().initialize();
}
