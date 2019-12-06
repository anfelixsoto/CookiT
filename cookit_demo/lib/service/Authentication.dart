import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String username, String email, String password, String profileImage);
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut();
  Future<String> uploadImage(File image);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email,String password) async{
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String username, String email, String password, String profileImage) async{
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password
      );
      FirebaseUser user = result.user;
      if (user != null) {
        Firestore.instance.collection('/users').document(user.uid).setData({
          'user_name': username,
          'email': email,
          'profileImage': profileImage,
          'role': 'user',
        });
        return user.uid;
      }
    }catch(e) {
        print(e);
    }

  }

  Future <FirebaseUser> getCurrentUser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<String> uploadImage(File image) async {
    String fileName = basename(image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("UserRecipes/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
    String downloadUrl = await firebaseStorageRef.getDownloadURL();
    return downloadUrl;
  }
}