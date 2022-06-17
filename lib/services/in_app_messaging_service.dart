import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

// HOW TO SETUP:
// This service requires no additional setup.

// Note: see official documentation at: https://firebase.google.com/docs/in-app-messaging/get-started?platform=flutter

/// An interface for interacting with firebase in app messaging.
class InAppMessagingService {
  final _fiam = FirebaseInAppMessaging.instance;

  /// Keeps in app messaging from showing messages until `allowMessages()` is called.
  Future deferMessages() async {
    await _fiam.setMessagesSuppressed(true);
  }

  /// Allows in app messages to be shown until `deferMessages()` is called.
  Future allowMessages() async {
    await _fiam.setMessagesSuppressed(false);
  }

  /// Triggers in app messaging event with the given `eventName`.
  Future triggerEvent(String eventName) async {
    await _fiam.triggerEvent(eventName);
  }
}
