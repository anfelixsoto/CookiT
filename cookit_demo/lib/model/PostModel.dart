import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final String username;
  final String email;
  final String profileImage;
  final String userId;

  Post({
    this.id,
    this.imageUrl,
    this.title,
    this.description,
    this.username,
    this.email,
    this.profileImage,
    this.userId,
  });

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
      id: doc.documentID,
      imageUrl: doc['imageUrl'],
      title: doc['title'],
      description: doc['description'],
      username: doc['username'],
      email: doc['email'],
      profileImage: doc['profileImage'],
      userId: doc['userId'],

    );
  }
}

