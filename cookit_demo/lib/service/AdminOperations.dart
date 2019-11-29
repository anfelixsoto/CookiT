import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/model/PostModel.dart';
import 'package:cookit_demo/model/User.dart';

class AdminOperations {
  static void deletePost(String PostId) {
    // delete the specified post
      Firestore.instance.collection('posts')
          .document(PostId)
          .get().then((data) {
        if (data.exists) {
          data.reference.delete();
        }
      });
  }

}