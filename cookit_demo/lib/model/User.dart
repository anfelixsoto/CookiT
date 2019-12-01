import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  String user_name;
  String email;
  String imageUrls;
  String role;

  User({
    this.user_name,
    this.email,
    this.imageUrls,
    this.role,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User (
      user_name: doc['user_name'],
      email: doc['email'],
      imageUrls: doc['imageUrls'],
      role: doc['role']
    );
  }

}