import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:template/misc/logger.dart';

// HOW TO SETUP:
// 1. Make sure that Google Analytics is enabled in your Firebase project: Go to settings > Project settings > Integrations tab, then follow the on-screen instructions for Google Analytics.

// Note: see official documentation at: https://firebase.google.com/docs/remote-config/get-started?platform=flutter

/// This service can be used to access firebase remote config. For more info, see https://firebase.flutter.dev/docs/remote-config/overview
class RemoteConfigService {
  final _remoteConfig = FirebaseRemoteConfig.instance;
  bool _updated = false;

  RemoteConfigService() {
    _initialize();
  }

  /// Configures the timeout and minimum fetch interval for the remote config. Fetches
  /// the newest config from the server.
  Future _initialize() async {
    logger.d('Initializing remote config.');
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await update();
  }

  /// Returns the value with given `key` in remote config.
  RemoteConfigValue getValue(String key) {
    return _remoteConfig.getValue(key);
  }

  /// Updates the local cache of remote config values.
  Future update() async {
    logger.d('Trying to update remote config.');
    _updated = await _remoteConfig.fetchAndActivate();
    logger.d('Remote config updated: $_updated');
  }
}
