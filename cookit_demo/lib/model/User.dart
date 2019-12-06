import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  String username;
  String email;
  String profileImage;
  String role;


  User({
    this.username,
    this.email,
    this.profileImage,
    this.role,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User (
      username: doc['user_name'],
      email: doc['email'],
      profileImage: doc['profileImage'],
      role: doc['role']
    );
  }

}