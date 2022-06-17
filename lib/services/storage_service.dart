import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:template/misc/logger.dart';

// HOW TO SETUP:
// 1. See the official documentation for setup.

// Note: see official documentation at: https://firebase.google.com/docs/storage/flutter/start

/// An interface for interacting with the Firebase Storage.
class StorageService {
  final _storageRef = FirebaseStorage.instance.ref();

  /// This function uploads the local file in the given `filePath` to cloud storage.
  /// If upload is successfull, returns the url of the uploaded file. Otherwise, returns null.
  /// An optional `uploadPath` can be provided to create proper folder structure to cloud storage.
  /// If `uploadPath` is not provided, the file will be uploaded to `/uploads`.
  /// Optional `metadata` can also be provided for the file.
  Future<String?> uploadFile({
    required String filePath,
    String? uploadPath,
    Map<String, String>? metadata,
  }) async {
    try {
      final file = File(filePath);
      SettableMetadata? meta;
      if (metadata != null) {
        meta = SettableMetadata(
          cacheControl: 'max-age=60',
          customMetadata: metadata,
        );
      }

      final ms = DateTime.now().millisecondsSinceEpoch;
      uploadPath ??= 'uploads/$ms';
      final uploadTask = _storageRef.child(uploadPath).putFile(file, meta);
      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e, stackTrace) {
      await logError('Error uploading file', e, stackTrace: stackTrace);
    }
    return null;
  }

  /// This function deletes the file in the given `url` from cloud storage
  Future<bool> deleteFile({
    required String url,
  }) async {
    try {
      if (!Uri.parse(url).isAbsolute) {
        return false;
      }
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
      return true;
    } catch (e, stackTrace) {
      await logError('Error deleting file', e, stackTrace: stackTrace);
    }
    return false;
  }
}
