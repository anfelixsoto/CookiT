import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class User {
  String username;
  String email;
  String profileImage;
  String role;
  List<String> favorites = new List<String>();


  User({
    this.username,
    this.email,
    this.profileImage,
    this.role,
    this.favorites,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User (
      username: doc['user_name'],
      email: doc['email'],
      profileImage: doc['profileImage'],
      role: doc['role'],
      favorites: List.from(doc['favorites']),
    );
  }

  User.fromMap(Map<String, dynamic> doc, String id)
      : this(
    username: doc['user_name'],
    email: doc['email'],
    profileImage: doc['profileImage'],
    role: doc['role'],
    favorites: new List<String>.from(doc['favorites']),
  );

}