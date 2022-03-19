import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:template/generated/l10n.dart';
import 'package:template/misc/logger.dart';
import 'package:template/reusable/dialogs/snackbar.dart';
import 'package:template/services/authentication_service.dart';
import 'package:template/services/service_locator.dart';

part 'authentication_state.dart';

/// This cubit handles the calls to `AuthenticationService` and manages the state for `AuthenticationScreen`.
/// It specifies, whether `AuthenticationScreen` shall show sign in screen, or sign up screen. Also it handles
/// when the loading indicator shall be shown.
class AuthenticationCubit extends Cubit<AuthenticationState> {
  final _authService = locator<AuthenticationService>();
  AuthenticationCubit()
      : super(AuthenticationState(
          emailController: TextEditingController(),
          passwordController: TextEditingController(),
          secondaryPasswordController: TextEditingController(),
        )) {
    logger.d('<create>');
  }

  /// Calling this method will change `type` in the state to the given parameter (`AuthenticationType.signIn` or `AuthenticationType.signUp`).
  /// On the UI side, changing `type` will specify, whether the sign in or sign up screen shall be shown.
  void changeAuthenticationType(AuthenticationType type) {
    state.emailController.clear();
    state.passwordController.clear();
    state.secondaryPasswordController.clear();
    emit(state.copyWith(type: type));
  }

  /// This method handles the calls to `AuthenticationService` for signing the user in.
  /// It takes the email address from `emailController` and the password from `passwordController`.
  /// If the signing in is not successfull, a snackbar is shown with a human readable error message.
  Future signIn() async {
    if (state.busy) return;
    emit(state.copyWith(busy: true));
    var email = state.emailController.text;
    var password = state.passwordController.text;
    logger.d('Signing in with $email');

    final success = await _authService.signIn(email: email, password: password);

    if (!success) {
      /// Hide the loading indicator only if the action wasn't successfull. If it was successfull, auth
      /// stream is triggered and startup_logic handles hiding sign in screen.
      emit(state.copyWith(busy: false));
    }
  }

  /// This method handles the calls to `AuthenticationService` for signing the user up.
  /// It takes the email address from `emailController` and the password from `passwordController` (and secondary checkup from `secondaryPasswordController`).
  /// If the signing up is not successfull, a snackbar is shown with a human readable error message.
  Future signUp() async {
    if (state.busy) return;
    emit(state.copyWith(busy: true));
    var email = state.emailController.text;
    var password = state.passwordController.text;
    var secondaryPassword = state.secondaryPasswordController.text;

    if (password != secondaryPassword) {
      showSnackbar(title: L.current.invalidPassword, text: L.current.passwordMismatch);
      emit(state.copyWith(busy: false));
      return;
    }

    logger.d('Signing up with $email');

    final success = await _authService.signUp(email: email, password: password);

    if (!success) {
      /// Hide the loading indicator only if the action wasn't successfull. If it was successfull, auth
      /// stream is triggered and startup_logic handles hiding sign up screen.
      emit(state.copyWith(busy: false));
    }
  }

  @override
  Future<void> close() {
    state.emailController.dispose();
    state.passwordController.dispose();
    state.secondaryPasswordController.dispose();
    return super.close();
  }
}
