import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:template/misc/dispose.dart';
import 'package:template/misc/initialize.dart';
import 'package:template/misc/logger.dart';

part 'lifecycle_manager_state.dart';

class LifecycleManagerCubit extends Cubit<LifecycleManagerState> {
  LifecycleManagerCubit() : super(LifecycleManagerState()) {
    logger.d('<create>');
  }

  /// Updates the lifecycle state
  void setLifecycleState(AppLifecycleState lifeCycleState) {
    logger.d('App lifecycle state changed to $lifeCycleState');
    emit(state.copyWith(lifeCycleState: lifeCycleState));
  }

  Future<Object>? initialize(BuildContext context) async {
    await initializeAfterRunApp(context);
    return Object();
  }

  @override
  Future<void> close() async {
    await dispose();
    return super.close();
  }
}
