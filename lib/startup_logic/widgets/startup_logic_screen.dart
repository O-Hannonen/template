import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/authentication/widgets/authentication_screen.dart';
import 'package:template/misc/extensions.dart';

import 'package:template/misc/lifecycle_manager/cubit/lifecycle_manager_cubit.dart';
import 'package:template/resources/styles.dart';
import 'package:template/startup_logic/cubit/startup_logic_cubit.dart';
import 'package:template/startup_logic/widgets/loading_screen.dart';
import 'package:template/startup_logic/widgets/permission_screen.dart';

/// This screen handles the startup logic. If authentication is required, shows authentication screen.
/// If startup logic is finished, shows the main screen. Otherwise shows the loading screen.
class StartupLogicScreen extends StatelessWidget {
  const StartupLogicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StartupLogicCubit>(
      create: (context) => StartupLogicCubit(),
      child: BlocListener<LifecycleManagerCubit, LifecycleManagerState>(
        listener: (context, state) {
          if (state.lifeCycleState == AppLifecycleState.resumed) {
            /// Came back to the app from settings etc.
            context.read<StartupLogicCubit>().refreshPermanentlyDeniedPermissions();
          }
        },
        child: BlocBuilder<StartupLogicCubit, StartupLogicState>(
          builder: (context, state) {
            switch (state.status) {
              case StartupLogicStatus.running:
                return LoadingScreen(
                  progress: (state.currentStep / state.totalSteps) * 100,
                );
              case StartupLogicStatus.signInRequired:
                return const AuthenticationScreen();
              case StartupLogicStatus.permissionRequired:
                return PermissionScreen(
                  deniedPermissions: state.deniedPermissions,
                  permanentlyDeniedPermissions: state.permanentlyDeniedPermissions,
                );
              case StartupLogicStatus.finished:

                /// TODO replace this with the apps main screen
                return Container();

              default:
                return Text(
                  'Unknown status',
                  style: textStyleH1.copyWith(
                    color: context.pallette.onBackground,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
