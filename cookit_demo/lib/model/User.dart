import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  String user_name;
  String email;
  String imageUrls;
  String role;
  String profileImage;

  User({
    this.user_name,
    this.email,
    this.role,
    this.profileImage,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User (
      user_name: doc['user_name'],
      email: doc['email'],
      role: doc['role'],
      profileImage: doc['profileImage'],
    );
  }

}