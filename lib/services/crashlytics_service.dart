import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:template/misc/constants.dart';

// HOW TO SETUP:
// This service requires no additional setup.
// Recommended: To get features like crash-free users, breadcrumb logs, and velocity alerts, you need to enable Google Analytics in your Firebase project.
// Make sure that Google Analytics is enabled in your Firebase project: Go to settings > Project settings > Integrations tab, then follow the on-screen instructions for Google Analytics.

// Note: see official documentation at: https://firebase.google.com/docs/crashlytics/get-started?platform=flutter

/// This service can be used to log errors to Firebase Crashlytics. For more info, see https://firebase.flutter.dev/docs/crashlytics/overview
class CrashlyticsService {
  final _crashlytics = FirebaseCrashlytics.instance;

  CrashlyticsService() {
    _initialize();
  }

  /// Initializes crashlytics
  Future _initialize() async {
    /// Sets up automatic crash reporting for crashlytics. Enables crash reporting only in debug mode.
    if (kEnableFirebase) {
      await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
      FlutterError.onError = _crashlytics.recordFlutterError;
    }
  }

  /// Logs an error to firebase crashlytics
  Future recordError(
    dynamic message,
    dynamic error, {
    StackTrace? stackTrace,
    bool fatal = false,
  }) async {
    if (!_crashlytics.isCrashlyticsCollectionEnabled) return;
    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: message,
      fatal: fatal,
    );
  }
}
