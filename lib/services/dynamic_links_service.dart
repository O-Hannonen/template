import 'dart:async';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:template/misc/logger.dart';
import 'package:template/misc/remote_actions.dart';

/// This service allows easy access to firebase dynamic links. For more info, see https://firebase.flutter.dev/docs/dynamic-links/overview
class DynamicLinkService {
  final _dynamicLinks = FirebaseDynamicLinks.instance;

  /// * Your apps android package name, found in the AndroidManifest.xml
  static const _androidPackageName = 'your.package.name';

  /// * Your apps ios bundle id, found from `Runner.xcodeproj/project.pbxproj`
  static const _iosBundleId = 'your.bundle.id';

  /// * Your URI prefix defined in the Firebase console > Dynamic links.
  static const _uriPrefix = 'https://your.domain.com';

  /// * Your IOS app store ID, found from these instructions: https://learn.apptentive.com/knowledge-base/finding-your-app-store-id/
  static const _iosAppStoreId = '12345679';

  StreamSubscription? _linkSubscription;

  /// Initializes dynamic links
  Future initialize() async {
    logger.d('Initializing dynamic links');

    _linkSubscription = _dynamicLinks.onLink.listen(
      (PendingDynamicLinkData data) async {
        await _handleDynamicLink(data);
      },
      onError: (e) async {
        logger.d('Dynamic link failed: ${e.toString()}');
      },
    );

    final data = await _dynamicLinks.getInitialLink();

    if (data != null) {
      await _handleDynamicLink(data);
    }
  }

  /// Cancels streams and disposes dynamic links
  Future dispose() async {
    await _linkSubscription?.cancel();
  }

  /// The actual function that handles the dynamic link
  Future _handleDynamicLink(PendingDynamicLinkData data) async {
    logger.d('Handling dynamic link!');
    if (data.isBlank ?? false) {
      logger.d('Data is blank...');
      return;
    }

    final shortUrl = data.link;

    logger.d(shortUrl.toString());

    await handleRemoteActions(shortUrl.queryParameters);
  }

  /// Handles the creationi of deep links
  Future<String> createDeepLink({
    /// A custom URI path to be appended to the URI prefix. This parameter shall start with '/' and cannot end with '/'.
    /// Eg. the structure should look like: '/your/custom/path'
    String uriPath = '',

    /// Contains any additional parameters to the deep link.
    Map<String, String>? parameters,
  }) async {
    logger.d('Creating deep link!');
    if (uriPath.isNotEmpty)
      assert(uriPath.startsWith('/') && !uriPath.endsWith('/'));
    var uri = '$_uriPrefix$uriPath';

    parameters?.forEach((key, value) {
      uri += '?$key=$value&';
    });

    logger.d('Uri: $uri');

    final _linkParameters = DynamicLinkParameters(
      uriPrefix: _uriPrefix,
      navigationInfoParameters: const NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
      link: Uri.parse(uri),
      androidParameters: const AndroidParameters(
        packageName: _androidPackageName,
      ),
      iosParameters: const IOSParameters(
        bundleId: _iosBundleId,
        appStoreId: _iosAppStoreId,
      ),
    );

    final shortDynamicLink =
        await _dynamicLinks.buildShortLink(_linkParameters);
    final shortUrl = shortDynamicLink.shortUrl.toString();
    logger.d('Short url: $shortUrl');

    return shortUrl;
  }
}
