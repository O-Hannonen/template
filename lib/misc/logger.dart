import 'package:logger/logger.dart';
import 'package:template/misc/constants.dart';
import 'package:template/services/crashlytics_service.dart';
import 'package:template/services/service_locator.dart';

/// Log using some of the following log levels:
/// ```dart
///logger.v("Verbose log");
///logger.d("Debug log");
///logger.i("Info log");
///logger.w("Warning log");
///logger.e("Error log");
///logger.wtf("What a terrible failure log");
/// ```
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
  ),
);

Future logError(
  dynamic message,
  dynamic error, [
  StackTrace? stackTrace,
  bool fatal = false,
]) async {
  logger.e(message, error, stackTrace);
  if (kEnableFirebase) {
    await locator<CrashlyticsService>().recordError(
      message,
      error,
      stackTrace,
      fatal,
    );
  }
}
