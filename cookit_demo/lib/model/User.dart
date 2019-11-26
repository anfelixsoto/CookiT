import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  String name;
  String email;
  String imageUrls;

  User({
    this.name,
    this.email,
    this.imageUrls,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User (
      name: doc['name'],
      email: doc['email'],
      imageUrls: doc['imageUrls'],
    );
  }

}