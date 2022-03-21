import 'package:get/get.dart';

/// Dynamic links and push notifications can specify a map of parameters. These parameters can be used
/// to trigger certain actions in the app (eg. navigate to new page etc). This function will check the
/// parameters and handle the required actions.
Future handleRemoteActions(Map<String, dynamic> data) async {
  final route = data['nav-to'];
  if (route != null) {
    await Get.toNamed(route, arguments: data['nav-arguments']);
  }
}
