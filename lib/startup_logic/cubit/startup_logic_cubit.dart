import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:template/misc/constants.dart';
import 'package:template/misc/initialize.dart';
import 'package:template/misc/logger.dart';
import 'package:template/resources/assets.dart';
import 'package:template/reusable/functions/load_image.dart';
import 'package:template/services/authentication_service.dart';
import 'package:template/services/local_storage_service.dart';
import 'package:template/services/push_notification_service.dart';
import 'dart:async';

import 'package:template/services/service_locator.dart';
part 'startup_logic_state.dart';

/// This cubit handles the running of startup logic. It is responsible for running every piece of (asyncronous) code
/// that needs to run before the app can be used (before main screen is shown). This typically includes initializing
/// services, handling permissions etc. Syncronous calls (that can run before calling runApp)
/// shall be placed in `lib/misc/initialize.dart`.
/// initializing services
class StartupLogicCubit extends Cubit<StartupLogicState> {
  /// This list contains all the functions that need to run in the startup logic.
  late List<Future<bool> Function()> _steps;

  final Map<Permission, PermissionStatus> _permissions = {
    /// * Add all the required permissions and their MINIMUM required statuses here, like so:
    /// Permission.location: PermissionStatus.granted,
    /// OR
    /// Permission.location: PermissionStatus.limited,
  };

  StreamSubscription? _startupSubscription;
  StreamSubscription? _authChangeSubscription;
  StartupLogicCubit() : super(StartupLogicState()) {
    logger.d('<create>');

    _steps = [
      /// * Add all of the steps to startup logic here. They will be completed one by one in the order they are below.
      _hideNativeSplashScreen,
      _handlePermissions,
      if (kEnableFirebaseMessaging) _handlePushNotificationPermission,
    ];

    emit(state.copyWith(totalSteps: _steps.length));

    if (kEnableFirebaseAuthentication) {
      // Listen to auth changes and let the authentication stream kick the startup logic process.
      var _authService = locator<AuthenticationService>();
      _authChangeSubscription = _authService.authChanges().listen((User? user) {
        if (user == null) {
          emit(state.copyWith(status: StartupLogicStatus.signInRequired));
        } else {
          _kick();
        }
      });
    } else {
      /// If authentication stream does not do the kicking (authentication not used), we'll do it manually.
      _kick();
    }
  }

  /// This is responsible for kicking (starting) the startup logic process.
  /// This function also makes sure that there cannot be multiple startup logics
  /// running simultaneously and causing issues.
  Future _kick() async {
    /// If startup logic is already running, cancel it.
    logger.d('Canceling previous startup logic (if there is any)');
    await _startupSubscription?.cancel();

    /// Kicks the startup logic to start, and converts it to stream so it can be cancelled if necessary.
    logger.d('Kicking new startup logic!');
    _startupSubscription = _handleStartupLogic().asStream().listen((_) {});
  }

  /// Handles the actual startup logic. Loops trough the steps and executes them one by one.
  /// When all the steps are done, it updates the UI accordingly (shows the main screen of the app)
  Future _handleStartupLogic() async {
    logger.i('Starting to handle startup logic!');
    emit(state.copyWith(
      status: StartupLogicStatus.running,

      /// If the startup logic is already finished and kicking is triggered by change in authentication
      /// stream, we'll start startup logic from the beginning. Otherwise we'll continue from where
      /// we left off.
      currentStep: state.status == StartupLogicStatus.finished ? 0 : state.currentStep,
    ));
    for (Future<bool> Function() step in _steps) {
      var index = _steps.indexOf(step);
      logger.i('Handling step $index');

      if (index < state.currentStep) {
        /// This step is already completed, no need to do it again.
        logger.i('Skipping step $index because it is already completed.');
        continue;
      }
      final success = await step.call();
      if (!success) {
        /// If any step requires some actions from the user (returns `false`), other steps won't continue
        logger.i('Step $index failed, requires some action from user.');
        await _startupSubscription?.cancel();
        return;
      }
      logger.i('Step $index completed.');
      emit(state.copyWith(currentStep: index + 1));
    }

    if (kShowLoadingIndicatorOnStartup) {
      /// Waits for the loading indicator to reach 100%, then opens the app
      await Future.delayed(const Duration(milliseconds: 300));
    }

    /// Marks startup logic finished (opens the app)
    logger.i('Startup logic completed!');
    emit(state.copyWith(status: StartupLogicStatus.finished));

    /// Runs everything that needs to run when main screen is shown.
    await initializeAfterStartupLogic();
  }

  /// Hides the native splash screen and reveals the UI rendered below it.
  Future<bool> _hideNativeSplashScreen() async {
    if (!state.firstFrameAllowed) {
      await loadImage(const AssetImage(splashScreen));

      var binding = WidgetsBinding.instance!;
      binding.addPostFrameCallback((_) {
        /// Hides the native splash screen
        logger.d('First frame allowed!');
        binding.allowFirstFrame();
      });

      /// Marks the native spash screen hidden, so `binding.allowFirstFrame()` is not called again.
      emit(state.copyWith(firstFrameAllowed: true));
    }

    return true;
  }

  /// Handles the permissions to send push notifications.
  Future<bool> _handlePushNotificationPermission() async {
    logger.d('Handling push notification permission');
    final pushNotifications = locator<PushNotificationService>();
    final storage = locator<LocalStorageService>();

    if (storage.readValue('push-notification-permission-prompted') != true) {
      final hasPermissions = await pushNotifications.requestPermission();
      logger.d('Has notification permissions: $hasPermissions');
      await storage.writeValue('push-notification-permission-prompted', true);
    }

    return true;
  }

  /// This function is responsible for showing the permission screen, if any of
  /// the required permissions are not granted.
  Future<bool> _handlePermissions() async {
    logger.d('Handling permissions!');
    var deniedPermissions = <Permission>[];
    var permanentlyDeniedPermissions = <Permission>[];
    for (Permission permission in _permissions.keys) {
      var status = await permission.status;

      /// Some services may be restricted due to parental controls etc. In that case, we cannot ask for permission to use the service.
      /// Those servicews are marked as restricted.
      var serviceRestricted = status == PermissionStatus.restricted;

      /// Some devices do not support phone- or location-based services. In that case, service is marked as unavailable.
      var serviceUnavailable = false;

      if (permission is PermissionWithService) {
        serviceUnavailable = await permission.serviceStatus != ServiceStatus.enabled;
      }

      if (serviceUnavailable || serviceRestricted) {
        /// * Add here case specific logic what shall be done if a service is not available on the device.
        /// * If the service is critical to your app, you should probably not continue (should show a screen
        /// * stating the app cannot be used with the device). Otherwise you may continue normally.
        /// * By default these services are skipped and app is launched normally, but that can cause
        /// * issues in many use-cases.
        await logError(
          'Service unavailable or restricted. This case should be handled by the developers',
          UnimplementedError(),
        );
        continue;
      }

      final satisfied = _doesPermissionSatisfyMinimumRequirements(permission, status);

      if (!satisfied) {
        logger.d('Permission is not satisfied...');
        if (status == PermissionStatus.permanentlyDenied) {
          permanentlyDeniedPermissions.add(permission);
        } else {
          deniedPermissions.add(permission);
        }
      }
    }

    if (deniedPermissions.isNotEmpty || permanentlyDeniedPermissions.isNotEmpty) {
      /// It is a good practice to show a detailed explanation of why the app needs the permissions before asking for them. We
      /// will first update the UI to show permission screen. The permission screen has a button which will trigger the actual method,
      /// `requestDeniedPermissions()` or `requestPermanentlyDeniedPermissions()`, which asks for the permissions.

      logger.d('Some of the permissions were not satisfied, user input needed.');
      emit(state.copyWith(
        status: StartupLogicStatus.permissionRequired,
        deniedPermissions: deniedPermissions,
        permanentlyDeniedPermissions: permanentlyDeniedPermissions,
      ));

      return false;
    }

    return true;
  }

  /// It is a good practice to show a detailed explanation of why the app needs the permissions before asking for them.
  /// When `_handlePermissions()` detects that all of the required permissions are not granted, it will update the UI
  /// to show detailed info about the permissions. The info screen has a button which will trigger this method, which
  /// asksk for the permissions.
  Future requestDeniedPermissions() async {
    var deniedPermissions = state.deniedPermissions;
    if (deniedPermissions.isEmpty) return;
    logger.d('Requesting denied permissions!');
    for (Permission permission in deniedPermissions) {
      final status = await permission.request();

      final satisfies = _doesPermissionSatisfyMinimumRequirements(permission, status);
      if (satisfies) {
        logger.d('Previously denied permission $permission is now satisfied!');
        deniedPermissions.remove(permission);
        emit(state.copyWith(deniedPermissions: deniedPermissions));
      }
    }

    if (deniedPermissions.isEmpty && state.permanentlyDeniedPermissions.isEmpty) {
      /// If all the required permissions are granted, we can continue with the startup logic.
      logger.d('Has all the necessary permissions, kicking startup logic!');
      _kick();
    }
  }

  /// It is a good practice to show a detailed explanation of why the app needs the permissions before asking for them.
  /// When `_handlePermissions()` detects that all of the required permissions are not granted, it will update the UI
  /// to show detailed info about the permissions. The info screen has a button which will call `openPermissionSettings()`,
  /// which opens the app's permission settings for the user to grant the permissions. `StartupLogicScreen` will listen
  /// to app lifecycle changes, and when the user comes back to the app, it will call `refreshPermanentlyDeniedPermissions()`.
  /// This method will refresh the list of permanently denied permissions and if there aren't any, it will kick the startup.
  Future refreshPermanentlyDeniedPermissions() async {
    var permanentlyDeniedPermissions = state.permanentlyDeniedPermissions;

    if (permanentlyDeniedPermissions.isEmpty) return;
    logger.d('Refreshing permanently denied permissions!');
    for (Permission permission in permanentlyDeniedPermissions) {
      final status = await permission.request();

      final satisfies = _doesPermissionSatisfyMinimumRequirements(permission, status);
      if (satisfies) {
        logger.d('Previously permanently denied permission $permission is now satisfied!');
        permanentlyDeniedPermissions.remove(permission);
        emit(state.copyWith(permanentlyDeniedPermissions: permanentlyDeniedPermissions));
      }
    }

    if (permanentlyDeniedPermissions.isEmpty && state.deniedPermissions.isEmpty) {
      /// If all the required permissions are granted, we can continue with the startup logic.
      logger.d('Has all the necessary permissions, kicking startup logic!');
      _kick();
    }
  }

  /// Opens app settings for the user to grant permanently denied permissions.
  Future openPermissionSettings() async {
    final opened = await openAppSettings();
    logger.d('Opening app settings ${opened ? 'succeeded' : 'failed'}');
  }

  /// Checks if the required permissions meet the minimum requirements.
  bool _doesPermissionSatisfyMinimumRequirements(Permission permission, PermissionStatus status) {
    var minimumStatus = _permissions[permission];

    /// Checks that the permission is correctly set up.
    assert(minimumStatus != null);

    /// These are the only two cases that give any access to the services. We do not want to specify
    /// PermissionStatus.denied or any of the other statuses as the minimum status, since they do not
    /// give access to any services, thus it is useless to even ask for permission.
    assert(minimumStatus == PermissionStatus.granted || minimumStatus == PermissionStatus.limited);

    /// Checks if the current permission status satisfies the minimum required status.
    switch (_permissions[permission]) {
      case PermissionStatus.granted:

        /// Only status that satisfies this as the minimum status is `PermissionStatus.granted`
        return (status == PermissionStatus.granted);

      case PermissionStatus.limited:

        /// Only statuses that satisfies this as the minimum status are `PermissionStatus.granted` and `PermissionStatus.limited`
        return (status == PermissionStatus.limited || status == PermissionStatus.granted);

      default:
        throw Exception('Use only PermissionStatus.granted or PermissionStatus.limited as minimum status for the permission');
    }
  }

  @override
  Future<void> close() async {
    await _startupSubscription?.cancel();
    await _authChangeSubscription?.cancel();
    return super.close();
  }
}
