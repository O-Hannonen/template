part of 'lifecycle_manager_cubit.dart';

class LifecycleManagerState {
  final AppLifecycleState lifeCycleState;

  LifecycleManagerState({
    this.lifeCycleState = AppLifecycleState.resumed,
  });

  LifecycleManagerState copyWith({
    AppLifecycleState? lifeCycleState,
  }) {
    return LifecycleManagerState(
      lifeCycleState: lifeCycleState ?? this.lifeCycleState,
    );
  }
}
