import 'package:template/misc/constants.dart';
import 'package:template/misc/logger.dart';
import 'package:template/services/dynamic_links_service.dart';
import 'package:template/services/cloud_messaging_service.dart';
import 'package:template/services/service_locator.dart';

/// This function is the last thing to be called after the app is closed.
Future dispose() async {
  logger.d('Disposing the app!');

  if (kEnableFirebaseCloudMessaging) {
    await locator<CloudMessagingService>().dispose();
  }
  if (kEnableFirebaseDynamicLinks) {
    await locator<DynamicLinkService>().dispose();
  }
}
