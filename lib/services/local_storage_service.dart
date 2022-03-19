import 'package:get_storage/get_storage.dart';

/// A service for saving key-value pairs locally to the device. For more info, see https://pub.dev/packages/get_storage
class LocalStorageService {
  /// Local storage can be accessed using
  /// ```dart
  /// storage.read(key)
  /// ```
  /// and
  /// ``` dart
  /// storage.write(key, value)
  /// ```
  /// For more information on GetStorage, see https://pub.dev/packages/get_storage
  GetStorage storage = GetStorage();

  /// Writes a key-value pair to local storage
  Future writeValue(String key, dynamic value) async {
    await storage.write(key, value);
  }

  /// Reads a key-value pair from local storage
  dynamic readValue(String key) {
    return storage.read(key);
  }
}
