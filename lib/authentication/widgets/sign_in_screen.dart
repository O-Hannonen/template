import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/authentication/cubit/authentication_cubit.dart';
import 'package:template/generated/l10n.dart';
import 'package:template/misc/dynamic_theme.dart';
import 'package:template/resources/styles.dart';
import 'package:template/reusable/widgets/button/widgets/button.dart';
import 'package:template/reusable/widgets/inputfield.dart';

/// A minimum version of a sign in screen.
class SignInScreen extends StatelessWidget {
  final AuthenticationState state;
  const SignInScreen({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 22.0,
            vertical: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputField(
                controller: state.emailController,
                hint: L.of(context).email,
                margin: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              InputField(
                controller: state.passwordController,
                hint: L.of(context).password,
                margin: const EdgeInsets.only(bottom: 20.0),
              ),
              GestureDetector(
                onTap: () {
                  context.read<AuthenticationCubit>().changeAuthenticationType(AuthenticationType.signUp);
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    L.of(context).dontYouHaveAccount,
                    style: textStyleItalic.copyWith(
                      decoration: TextDecoration.underline,
                      color: context.dynamicTheme.backgroundTextColor,
                    ),
                  ),
                ),
              ),
              Button(
                text: L.of(context).signIn,
                enabled: !state.busy,
                onTap: () {
                  context.read<AuthenticationCubit>().signIn();
                },
                margin: const EdgeInsets.symmetric(vertical: 15.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
