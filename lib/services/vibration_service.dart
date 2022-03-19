import 'package:flutter/services.dart';
import 'package:template/misc/logger.dart';
import 'package:vibration/vibration.dart';

/// This class can be used to access devices haptic feedback motors. For more info, see https://pub.dev/packages/vibration
class VibrationService {
  var _canVibrate = false;
  VibrationService() {
    _initialize();
  }

  Future _initialize() async {
    final hasVibrators = await Vibration.hasVibrator();
    final hasAmplitudeControl = await Vibration.hasAmplitudeControl();
    final hasCustomVibrationSupport = await Vibration.hasCustomVibrationsSupport();
    _canVibrate = hasVibrators! && hasAmplitudeControl! && hasCustomVibrationSupport!;
  }

  Future selectionClick() async {
    if (_canVibrate) {
      logger.d('Vibrating!');
      await HapticFeedback.selectionClick();
      return;
    }
    logger.d('Does not have vibrators...');
  }

  Future vibrateError() async {
    if (_canVibrate) {
      logger.d('Vibrating!');
      await Vibration.vibrate(duration: 500, amplitude: 1);
      return;
    }
    logger.d('Does not have vibrators...');
  }

  Future vibrateHeadsUp() async {
    if (_canVibrate) {
      logger.d('Vibrating!');
      await Vibration.vibrate(
        duration: 200,
        amplitude: 255,
        pattern: [200, 200],
      );
      return;
    }
    logger.d('Does not have vibrators...');
  }
}
