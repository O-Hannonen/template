import 'package:get_it/get_it.dart';
import 'package:template/misc/constants.dart';
import 'package:template/services/analytics_service.dart';
import 'package:template/services/authentication_service.dart';
import 'package:template/services/cloud_functions_service.dart';
import 'package:template/services/crashlytics_service.dart';
import 'package:template/services/dynamic_links_service.dart';
import 'package:template/services/cloud_messaging_service.dart';
import 'package:template/services/firestore_service.dart';
import 'package:template/services/in_app_messaging_service.dart';
import 'package:template/services/local_storage_service.dart';
import 'package:template/services/remote_config_service.dart';
import 'package:template/services/storage_service.dart';
import 'package:template/services/vibration_service.dart';

GetIt locator = GetIt.instance;

/// Sets up all the services to be referenced and used in the app. For more info, see https://pub.dev/packages/get_it
Future setupServiceLocator() async {
  locator.registerLazySingleton(() => LocalStorageService());
  locator.registerLazySingleton(() => VibrationService());

  if (kEnableFirebase) {
    if (kEnableFirebaseDynamicLinks) {
      locator.registerLazySingleton(() => DynamicLinkService());
    }

    if (kEnableFirebaseCloudMessaging) {
      locator.registerLazySingleton(() => CloudMessagingService());
    }
    if (kEnableFirebaseAuthentication) {
      locator.registerLazySingleton(() => AuthenticationService());
    }
    locator.registerLazySingleton(() => StorageService());
    locator.registerLazySingleton(() => FirestoreService());
    locator.registerLazySingleton(() => AnalyticsService());
    locator.registerLazySingleton(() => CloudFunctionsService());
    locator.registerLazySingleton(() => InAppMessagingService());
    locator.registerSingleton(() => CrashlyticsService());
    locator.registerSingleton(() => RemoteConfigService());
  }
}
