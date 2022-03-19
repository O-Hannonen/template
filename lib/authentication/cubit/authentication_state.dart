part of 'authentication_cubit.dart';

enum AuthenticationType {
  signIn,
  signUp,
}

class AuthenticationState {
  final AuthenticationType type;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController secondaryPasswordController;
  final bool busy;

  AuthenticationState({
    this.type = AuthenticationType.signIn,
    this.busy = false,
    required this.emailController,
    required this.passwordController,
    required this.secondaryPasswordController,
  });

  AuthenticationState copyWith({
    AuthenticationType? type,
    bool? busy,
  }) {
    return AuthenticationState(
      type: type ?? this.type,
      busy: busy ?? this.busy,
      emailController: emailController,
      passwordController: passwordController,
      secondaryPasswordController: secondaryPasswordController,
    );
  }
}
