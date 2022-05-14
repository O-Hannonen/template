import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/misc/lifecycle_manager/cubit/lifecycle_manager_cubit.dart';

class LifecycleManager extends StatefulWidget {
  final Widget child;
  const LifecycleManager({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<LifecycleManager> createState() => _LifecycleManagerState();
}

class _LifecycleManagerState extends State<LifecycleManager>
    with WidgetsBindingObserver {
  WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  late LifecycleManagerCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = LifecycleManagerCubit();
    binding.addObserver(this);
  }

  @override
  void dispose() async {
    binding.removeObserver(this);
    await cubit.close();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    cubit.setLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: FutureBuilder<Object>(
        future: cubit.initialize(context),
        builder: (context, _) {
          return widget.child;
        },
      ),
    );
  }
}
