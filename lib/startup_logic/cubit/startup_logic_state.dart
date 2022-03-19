part of 'startup_logic_cubit.dart';

enum StartupLogicStatus {
  running,
  signInRequired,
  permissionRequired,
  finished,
}

class StartupLogicState {
  final bool firstFrameAllowed;
  final int currentStep;
  final int totalSteps;
  final StartupLogicStatus status;
  final List<Permission> deniedPermissions;
  final List<Permission> permanentlyDeniedPermissions;

  StartupLogicState({
    this.firstFrameAllowed = false,
    this.status = StartupLogicStatus.running,
    this.deniedPermissions = const [],
    this.permanentlyDeniedPermissions = const [],
    this.currentStep = 0,
    this.totalSteps = 1,
  });

  StartupLogicState copyWith({
    bool? firstFrameAllowed,
    int? currentStep,
    int? totalSteps,
    StartupLogicStatus? status,
    List<Permission>? deniedPermissions,
    List<Permission>? permanentlyDeniedPermissions,
  }) {
    return StartupLogicState(
      status: status ?? this.status,
      firstFrameAllowed: firstFrameAllowed ?? this.firstFrameAllowed,
      deniedPermissions: deniedPermissions ?? this.deniedPermissions,
      permanentlyDeniedPermissions: permanentlyDeniedPermissions ?? this.permanentlyDeniedPermissions,
      totalSteps: totalSteps ?? this.totalSteps,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
