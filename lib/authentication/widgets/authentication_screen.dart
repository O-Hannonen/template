import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/authentication/cubit/authentication_cubit.dart';
import 'package:template/authentication/widgets/sign_in_screen.dart';
import 'package:template/authentication/widgets/sign_up_screen.dart';
import 'package:template/reusable/widgets/circular_progress.dart';

/// This screen handles the authentication. If the user needs to create an account, this directs them to the sign up screen.
/// If the user needs to sign in, this directs them to the sign in screen.
class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationCubit(),
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          return Stack(
            children: [
              if (state.type == AuthenticationType.signIn) SignInScreen(state: state) else SignUpScreen(state: state),
              if (state.busy)
                const Material(
                  color: Colors.black26,
                  child: Center(
                    child: CircularProgress(),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
