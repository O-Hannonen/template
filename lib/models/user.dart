import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

/// This represents the object in 'Users' -collection in firestore
class User {
  static User current = User._();
  final String? id;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  User._({
    this.id,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  User updateSingletonFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    current = User._(
      id: doc.id,
      email: data['email'],
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
    );

    return current;
  }

  User updateSingletonFromAuthUser(auth.User authUser) {
    current = User._(
      id: authUser.uid,
      email: authUser.email,
      displayName: authUser.displayName,
      photoUrl: authUser.photoURL,
    );

    return current;
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }

  void emptySingleton() {
    current = User._();
  }
}
