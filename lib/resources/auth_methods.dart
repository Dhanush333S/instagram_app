import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/resources/storage_methods.dart';
import 'package:instagram_app/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserdetails() async{
    User currentUser=_auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String username,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
            username: username,
            email: email,
            bio: bio,
            uid: cred.user!.uid,
            photoUrl: photoUrl,
            following: [],
            followers: []);

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = "Success";
      } else {
        res = "Fill in the form";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //logging in Users
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some Error Occured";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = "Please Enter All the Fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
