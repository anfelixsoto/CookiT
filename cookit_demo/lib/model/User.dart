import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class User {
  final String user_id;
  String username;
  String email;
  String profileImage;
  String role;
  List<String> favorites = new List<String>();
  List<String> saved = new List<String>();
  List<String> recipeCreated = new List<String>();


  User({
    this.user_id,
    this.username,
    this.email,
    this.profileImage,
    this.role,
    this.favorites,
    this.saved,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User (
      user_id: doc.documentID,
      username: doc['user_name'],
      email: doc['email'],
      profileImage: doc['profileImage'],
      role: doc['role'],
      favorites: List.from(doc['favorites']),
      saved: List.from(doc['saved']),
    );
  }

  User.fromMap(Map<String, dynamic> doc, String id)
      : this(
    username: doc['user_name'],
    email: doc['email'],
    profileImage: doc['profileImage'],
    role: doc['role'],
    favorites: new List<String>.from(doc['favorites']),
    saved: new List<String>.from(doc['saved']),
  );

}