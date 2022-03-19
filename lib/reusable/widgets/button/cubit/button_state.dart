part of 'button_cubit.dart';

class ButtonState {
  final bool pressed;

  const ButtonState({
    this.pressed = false,
  });

  ButtonState copyWith({
    bool? pressed,
  }) =>
      ButtonState(
        pressed: pressed ?? this.pressed,
      );
}
