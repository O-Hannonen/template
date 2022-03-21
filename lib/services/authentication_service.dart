import 'package:firebase_auth/firebase_auth.dart';
import 'package:template/generated/l10n.dart';
import 'package:template/misc/constants.dart';
import 'package:template/misc/logger.dart';
import 'package:template/models/user.dart' as u;
import 'package:template/reusable/dialogs/snackbar.dart';
import 'package:template/services/analytics_service.dart';
import 'package:template/services/firestore_service.dart';
import 'package:template/services/service_locator.dart';

/// An interface for interacting with firebase authentication methods. For more info, see https://firebase.flutter.dev/docs/auth/overview
class AuthenticationService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestoreService = locator<FirestoreService>();
  final _analyticsService = locator<AnalyticsService>();

  /// Signs out the currently logged in user. If the user is anonymous, deletes the user.
  Future signOut() async {
    try {
      final fbUser = _firebaseAuth.currentUser;

      if (fbUser != null) {
        if (fbUser.isAnonymous) {
          await fbUser.delete();
          if (kEnableFirebase) await _analyticsService.logSignOut();
          return;
        }
        await _firebaseAuth.signOut();
        if (kEnableFirebase) await _analyticsService.logSignOut();
      }
    } catch (e, stackTrace) {
      await logError('Signing out failed', e, stackTrace);
    }
  }

  /// Deletes the currently logged in user. This action requires a recent login to proceed.
  /// If there is no recent login, a snackabar is shown.
  /// If deletion is successfull, returns `true`. Otherwise, returns `false`.
  Future<bool> deleteUser() async {
    try {
      final fbUser = _firebaseAuth.currentUser;
      if (fbUser == null) return false;

      await fbUser.delete();
      if (kEnableFirebase) await _analyticsService.logDeleteUser();
      return true;
    } catch (e, stackTrace) {
      await logError('User deletion failed', e, stackTrace);
      if (e is FirebaseAuthException) {
        if (e.code == 'requires-recent-login') {
          showSnackbar(
            title: L.current.recentLoginRequired,
            text: L.current.logInAgainToProceed,
          );
        }
      }

      return false;
    }
  }

  /// Signs in to firebase authentication with the given `email`
  /// and `password`. Uses snackbar to display
  /// human readable error message to the user
  /// if the sign in did not work because of a known reason.
  /// Returns `true` if user is signed in succesfully, and `false`
  /// if not.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return false;
    }
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        if (kEnableFirebase) await _analyticsService.logSignIn(AuthenticationMethod.emailAndPassword);
        return true;
      }
    } catch (e, stackTrace) {
      await logError('Signing in failed', e, stackTrace);
      if (e is FirebaseAuthException) {
        var title = L.current.signingInFailed;
        var text = L.current.unknownErrorOccured;
        switch (e.code) {
          case 'invalid-email':
            text = L.current.invalidEmail;
            break;
          case 'wrong-password':
            text = L.current.invalidPassword;
            break;
          case 'user-not-found':
            text = L.current.userNotFound;
            break;
          case 'user-disabled':
            text = L.current.userDisabled;
            break;
        }
        showSnackbar(title: title, text: text);
      }
    }

    return false;
  }

  /// Creates a new account to firebase using
  /// `email` and `password`.
  /// Uses scnackbar to display a
  /// human readable message if the signup did not work
  /// because of a known reason. Returns `true` if user is created
  /// successfully, and `false` if not.
  Future<bool> signUp({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        logger.d('Email is empty or password is empty');

        return false;
      }

      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        if (kEnableFirebase) await _analyticsService.logSignUp(AuthenticationMethod.emailAndPassword);
        return true;
      }
    } catch (e, stackTrace) {
      await logError('Signing up failed', e, stackTrace);
      if (e is FirebaseAuthException) {
        var title = L.current.signingUpFailed;
        var text = L.current.unknownErrorOccured;
        switch (e.code) {
          case 'weak-password':
            text = L.current.weakPassword;
            break;
          case 'invalid-email':
            text = L.current.invalidEmail;
            break;
          case 'email-already-in-use':
            text = L.current.emailAddressTaken;
            break;
        }
        showSnackbar(title: title, text: text);
      }
    }

    return false;
  }

  /// Sends password reset email to the given email IF the email is valid and
  /// a user with the given email exists. Otherwise, shows a snackbar with a
  /// error message. Returns `true` if the email was sent successfully, and
  /// `false` if not.
  Future<bool> requestPasswordChange({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      return true;
    } catch (e, stackTrace) {
      await logError('Password reset failed', e, stackTrace);

      if (e is FirebaseAuthException) {
        var title = L.current.passwordResetFailed;
        var text = L.current.unknownErrorOccured;
        switch (e.code) {
          case 'invalid-email':
            text = L.current.invalidEmail;
            break;
          case 'user-not-found':
            text = L.current.userNotFound;
            break;
        }
        showSnackbar(title: title, text: text);
      }
    }
    return false;
  }

  /// Saves the updated values in the current user singleton to firebase authentication.
  /// If operation is not successfull for a known reason, shows a snackbar with
  /// a human readable error message. Returns `true` if the operation was
  /// successfull, and `false` if not.
  Future<bool> saveCurrentUserChanges() async {
    try {
      final user = u.User.current;
      final authUser = _firebaseAuth.currentUser!;
      if (user.email != authUser.email) await _firebaseAuth.currentUser!.updateEmail(user.email!);
      if (user.photoUrl != authUser.photoURL) await _firebaseAuth.currentUser!.updatePhotoURL(user.photoUrl);
      if (user.displayName != authUser.displayName) await _firebaseAuth.currentUser!.updateDisplayName(user.displayName);

      return true;
    } catch (e, stackTrace) {
      await logError('Email update failed', e, stackTrace);

      if (e is FirebaseAuthException) {
        var title = L.current.emailUpdateFailed;
        var text = L.current.unknownErrorOccured;
        switch (e.code) {
          case 'invalid-email':
            text = L.current.invalidEmail;
            break;
          case 'email-already-in-use':
            text = L.current.emailAddressTaken;
            break;

          case 'requires-recent-login':
            text = L.current.recentLoginRequired + ' ' + L.current.logInAgainToProceed;
            break;
        }
        showSnackbar(title: title, text: text);
      }
    }

    return false;
  }

  /// Returns a stream of auth changes (Users). This stream is triggered when:
  /// 1. The listener is created
  /// 2. A user signs in
  /// 3. The current user signs out
  Stream<User?> authChanges() => _firebaseAuth.authStateChanges().asyncMap(_mapNewAuthUser);

  /// Runs some code on the user before returning the newly triggered user to authState stream.
  Future<User?> _mapNewAuthUser(User? user) async {
    logger.d('Auth change stream triggered by new user: $user');
    if (user == null) {
      /// Stream is triggered by a user signing out. Clearing the current user singleton.
      u.User.current.emptySingleton();
    } else {
      /// Stream is triggered by authenticated user. Updating the current user singleton.
      await _firestoreService.initUser(user);
    }

    return user;
  }
}
