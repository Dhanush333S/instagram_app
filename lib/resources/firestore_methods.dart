import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/models/post.dart';
import 'package:instagram_app/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;


  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  )async{
    String res="Some error Occured";
    try {
      String postUrl=await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId=const Uuid().v1();
      Post post=Post(description: description, uid: uid, username: username, postId: postId, datePublished: DateTime.now(), postUrl: postUrl, profImage: profImage, likes: []);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res="Success";
    } catch (e) {
      res=e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId,String uid,List likes)async{
    try {
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes':FieldValue.arrayRemove([uid]),
        });
      }else{
        await _firestore.collection('posts').doc(postId).update({
          'likes':FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }


  Future<void> postComment(String postId,String text,String uid,String name,String profilePic)async{
    
    try {
      if(text.isNotEmpty){
        String commentId=const Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic':profilePic,
          'name':name,
          'uid':uid,
          'text':text,
          'commentId':commentId,
          'datePublished':DateTime.now()
        });
      }else{
        print("EMPTY");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId)async{
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}