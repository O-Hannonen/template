import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:template/generated/l10n.dart';
import 'package:template/misc/extensions.dart';

import 'package:template/resources/styles.dart';
import 'package:template/reusable/widgets/button/widgets/button.dart';
import 'package:template/startup_logic/cubit/startup_logic_cubit.dart';

/// A basic screen that displays a list of permissions which needs to be granted. This screen
/// should also state to the user why the given permission is needed.
class PermissionScreen extends StatelessWidget {
  final List<Permission> deniedPermissions;
  final List<Permission> permanentlyDeniedPermissions;
  const PermissionScreen({
    Key? key,
    required this.deniedPermissions,
    required this.permanentlyDeniedPermissions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 22.0,
      ),
      alignment: Alignment.center,
      child: ListView(
        shrinkWrap: true,
        children: [
          if (deniedPermissions.isNotEmpty) ...[
            Text(
              L.of(context).insufficientPermissions,
              style: textStyleH1.copyWith(
                color: context.pallette.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              L.of(context).theFollowingPermissionsAreDenied,
              style: textStyleH3.copyWith(
                color: context.pallette.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ...deniedPermissions
                .map(
                  (p) => Text(
                    p.toString(),
                    style: textStyleBody.copyWith(
                      color: context.pallette.onBackground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
                .toList(),
            const SizedBox(height: 22.0),
            Button(
              text: L.of(context).grantPermissions,
              onTap: () {
                context.read<StartupLogicCubit>().requestDeniedPermissions();
              },
            ),
            const SizedBox(height: 8.0),
          ],
          if (permanentlyDeniedPermissions.isNotEmpty) ...[
            Text(
              L.of(context).theFollowingPermissionsArePermanentlyDenied,
              style: textStyleH3.copyWith(
                color: context.pallette.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ...permanentlyDeniedPermissions
                .map(
                  (p) => Text(
                    p.toString(),
                    style: textStyleBody.copyWith(
                      color: context.pallette.onBackground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
                .toList(),
            const SizedBox(height: 22.0),
            Button(
              text: L.of(context).openSettings,
              onTap: () {
                context.read<StartupLogicCubit>().openPermissionSettings();
              },
            ),
          ],
        ],
      ),
    );
  }
}
