import 'package:firebase_analytics/firebase_analytics.dart';

enum AuthenticationMethod {
  emailAndPassword,
  google,
  facebook,
  apple,
  anonymous,
  phone,
}

var _authMethodToString = <AuthenticationMethod, String>{
  AuthenticationMethod.emailAndPassword: 'email/password',
  AuthenticationMethod.google: 'google',
  AuthenticationMethod.facebook: 'facebook',
  AuthenticationMethod.apple: 'apple',
  AuthenticationMethod.anonymous: 'anonymous',
  AuthenticationMethod.phone: 'phone',
};

class AnalyticsService {
  final _analytics = FirebaseAnalytics.instance;

  /// Logs app opening
  Future logAppOpen() async {
    await _analytics.logAppOpen();
  }

  /// Logs startup logic completion
  Future logStartupLogicComplete() async {
    await _analytics.logEvent(name: 'startup_logic_complete');
  }

  /// Logs user sign in
  Future logSignIn(AuthenticationMethod method) async {
    await _analytics.logLogin(loginMethod: _authMethodToString[method]!);
  }

  /// Logs user sign out
  Future logSignOut() async {
    await _analytics.logEvent(name: 'sign_out');
  }

  /// Logs user sign up
  Future logSignUp(AuthenticationMethod method) async {
    await _analytics.logSignUp(signUpMethod: _authMethodToString[method]!);
  }

  /// Logs delete user
  Future logDeleteUser() async {
    await _analytics.logEvent(name: 'delete_user');
  }

  /// Logs route changes
  Future logRouteChange(String route) async {
    await _analytics.logScreenView(
      screenName: route,
      screenClass: route,
    );
  }
}
