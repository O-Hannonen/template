import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:template/misc/logger.dart';
import 'package:template/misc/remote_actions.dart';
import 'package:template/models/user.dart';
import 'package:template/reusable/dialogs/snackbar.dart';
import 'package:template/services/firestore_service.dart';
import 'package:template/services/service_locator.dart';
// HOW TO SETUP:
// 1. See the official documentation to enable push notifications.
// 2. Set cloud messaging to enabled at ./lib/misc/constants.dart:
//     const kEnableFirebaseCloudMessaging = true;

// Note: see official documentation at: https://firebase.google.com/docs/cloud-messaging/flutter/client

enum PushNotificationType {
  foreground,
  background,
  initial,
}

/// An interface for interacting with firebase cloud messaging (push notifications)
class CloudMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  StreamSubscription? _tokenSubscription;
  StreamSubscription? _messageSubscription;

  /// Requests permission to send push notifications.
  Future<bool> requestPermission() async {
    logger.d('Requesting push notification permissions!');
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Initializes the service
  Future initialize() async {
    final settings = await _messaging.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

    /// Initializes listening of foreground notifications
    _messageSubscription = FirebaseMessaging.onMessage.listen((m) => _handleNotification(m, type: PushNotificationType.foreground));

    /// Initializes the method for handling background notifications.
    /// This allows us to run some code in the background every time the app receives
    /// a push notification and the app is in background or closed (even if the user
    /// does not press on the notification)
    FirebaseMessaging.onBackgroundMessage((m) => _handleNotification(m, type: PushNotificationType.background));

    /// Initializes listening of a token refresh.
    _tokenSubscription = _messaging.onTokenRefresh.listen(_handleToken);

    /// Gets the initial token and handles it
    final token = await _messaging.getToken();
    await _handleToken(token);

    /// Gets the initial message and handles it
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotification(initialMessage, type: PushNotificationType.initial);
    }
  }

  /// This gets called whenever token is refreshed or fetched. If the current token
  /// is already stored in firebase (and current user singleton), won't do anything. If the token has to be refreshed
  /// in firebase, will update it.
  Future _handleToken(String? token) async {
    final user = User.current;
    if ((user.id ?? '').isEmpty) return;
    if (token == null) return;

    logger.d('Handling token $token');
    if (user.notificationToken != token) {
      logger.d('Token is new, updating in firestore!');
      User.current = user.copyWith(notificationToken: token);
      await locator<FirestoreService>().saveCurrentUserChanges();
      logger.d('Token updated in firestore!');
    } else {
      logger.d('Token is not new, no need to update in firestore');
    }
  }

  /// Handles the push notification
  Future _handleNotification(
    RemoteMessage notification, {
    PushNotificationType type = PushNotificationType.foreground,
  }) async {
    final data = notification.data;
    switch (type) {
      case PushNotificationType.foreground:
        logger.d('Handling foreground push notification!');

        /// * Add your custom implementation here to handle foreground push notifications.
        /// * This code is excecuted when the app is in the foreground (running) and receives
        /// * a push notification. Default behavior is to display the notification to the user.
        showSnackbar(
          title: data['title'],
          text: data['message'],
          duration: const Duration(seconds: 8),
          onTap: () async {
            await handleRemoteActions(data);
          },
        );
        break;
      case PushNotificationType.background:
        logger.d('Handling background push notification!');

        /// * Add your custom implemetation here to handle background push notifications.
        /// * This code is executed when the device reveices a push notification and
        /// * the app is not open in foreground. Note: the user does not have to click on the notification
        /// * for this piece of code to be executed.
        break;
      case PushNotificationType.initial:
        logger.d('Handling initial push notification!');

        /// * Add your custom implemetation here to handle initial push notifications. This code is executed
        /// * when the user taps on a push notification (and the app opens) while the app is not open in foreground.
        await handleRemoteActions(data);
        break;
    }
  }

  /// Subscribes the currently logged in user to the given topic. Topics allow
  /// us to send push notifications to a specific group of users.
  Future subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  /// Unsubscribes the currently logged in user from the given topic. Topics allow
  /// us to send push notifications to a specific group of users.
  Future unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  /// Closes all the stream subscriptions
  Future dispose() async {
    await _tokenSubscription?.cancel();
    await _messageSubscription?.cancel();
  }
}
