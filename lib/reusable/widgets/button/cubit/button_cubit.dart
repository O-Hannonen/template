import 'package:bloc/bloc.dart';

part 'button_state.dart';

class ButtonCubit extends Cubit<ButtonState> {
  ButtonCubit() : super(const ButtonState());

  void setPressed(bool pressed) {
    emit(state.copyWith(pressed: pressed));
  }
}
