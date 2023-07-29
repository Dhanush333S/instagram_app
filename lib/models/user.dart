import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String email;
  final String bio;
  final String uid;
  final String photoUrl;
  final List following;
  final List followers;

  const User({
    required this.username,
    required this.email,
    required this.bio,
    required this.uid,
    required this.photoUrl,
    required this.following,
    required this.followers,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'bio': bio,
        'uid': uid,
        'photoUrl': photoUrl,
        'following': [],
        'followers': [],
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot['username'],
      email: snapshot['email'],
      bio: snapshot['bio'],
      uid: snapshot['uid'],
      photoUrl: snapshot['photoUrl'],
      following: snapshot['following'],
      followers: snapshot['followers'],
    );
  }
}
