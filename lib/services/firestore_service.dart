import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

/// An interface for interacting with firestore database. For more info, see https://firebase.flutter.dev/docs/firestore/overview
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initializes the current user singleton. If the user doc exists in firestore,
  /// gets the users data from there. Otherwise, creates a new user doc in firestore.
  /// Returns a future that resolves to the current user.
  Future<User> initUser(auth.User authUser) async {
    /// Tries to get the user data from firestore.
    var doc = await _firestore.collection('users').doc(authUser.uid).get();

    if (doc.exists) {
      /// Updates the singleton with data from firestore.
      User.current.updateSingletonFromDoc(doc);
    } else {
      /// Creates the user in firestore.
      await doc.reference.set(User.current.toJson());

      /// Updates the singleton with data from `auth.User`
      User.current.updateSingletonFromAuthUser(authUser);
    }

    /// Returns the current user.
    return User.current;
  }

  /// Saves any changes made to the current user singleton to firestore.
  Future saveCurrentUserChanges() async {
    await _firestore.collection('users').doc(User.current.id).update(User.current.toJson());
  }
}
