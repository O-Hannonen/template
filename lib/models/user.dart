import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

/// This represents the object in 'Users' -collection in firestore
class User {
  static User current = User._();
  final String? id;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? notificationToken;

  User._({
    this.id,
    this.email,
    this.displayName,
    this.photoUrl,
    this.notificationToken,
  });

  /// A way to make a new instance with some modifications
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? notificationToken,
  }) {
    return User._(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      notificationToken: notificationToken ?? this.notificationToken,
    );
  }

  /// A way to make a new instance based off document in firebase
  User updateSingletonFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    current = User._(
      id: doc.id,
      email: data['email'],
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      notificationToken: data['notificationToken'],
    );

    return current;
  }

  /// A way to make a new instance based off auth user
  User updateSingletonFromAuthUser(auth.User authUser) {
    current = User._(
      id: authUser.uid,
      email: authUser.email,
      displayName: authUser.displayName,
      photoUrl: authUser.photoURL,
      notificationToken: null,
    );

    return current;
  }

  /// A json representation of this object to be used in firestore
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'notificationToken': notificationToken,
    };
  }

  /// Empties the current user data.
  void emptySingleton() {
    current = User._();
  }
}
