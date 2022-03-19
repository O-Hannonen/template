import 'package:cloud_functions/cloud_functions.dart';

/// This service can be used to call firebase cloud functions.
class CloudFunctionsService {
  final _functions = FirebaseFunctions.instance;

  /// Calls a cloud function with the given `functionName` and `parameters`.
  /// Returns a future that resolves to the data returned by the cloud function.
  Future<dynamic> callFunction(
    String functionName, {
    Map<String, dynamic>? parameters,
  }) async {
    final callable = _functions.httpsCallable(functionName);
    final result = await callable.call(parameters);
    return result.data;
  }
}
