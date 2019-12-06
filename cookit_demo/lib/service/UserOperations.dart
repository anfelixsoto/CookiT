import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/model/PostModel.dart';
import 'package:cookit_demo/model/User.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserOperations {
  static String deletePost(String PostId) {
    // delete the specified post
    String filepath;
    String url;
    Firestore.instance.collection('posts')
        .document(PostId)
        .get().then((data) {
      if (data.exists) {
        url = data['imageUrl'];
        print(url);
        filepath = url.replaceAll(new RegExp(r'%2F'), '/');
        // filepath = filepath.replaceAll(new RegExp(r'(\?alt).*'), '');
        //StorageReference storageReference = FirebaseStorage.instance.ref();
        print(filepath);
        //StorageReference photoRef = FirebaseStorage.instance.getReferenceFromUrl(url);

        //storageReference.child("UserRecipes/").delete().then((_) => print('Successfully deleted $filepath storage item' ));
        print(filepath);
        data.reference.delete();
      }
    });
    return url;



  }

  Future<bool> addToFavorites(String userId, String recipeId) {
    DocumentReference favoritesReference = Firestore.instance.collection('users').document(userId);

    return Firestore.instance.runTransaction((Transaction favoritesOperations) async {
      DocumentSnapshot postSnapshot = await favoritesOperations.get(favoritesReference);
      if (postSnapshot.exists) {
        // Extend 'favorites' if the list does not contain the recipe ID:
        if (!postSnapshot.data['favorites'].contains(recipeId)) {
          await favoritesOperations.update(favoritesReference, <String, dynamic>{
            'favorites': FieldValue.arrayUnion([recipeId])
          });
          // Delete the recipe ID from 'favorites':
        } else {
          await favoritesOperations.update(favoritesReference, <String, dynamic>{
            'favorites': FieldValue.arrayRemove([recipeId])
          });
        }
      } else {
        // Create a document for the current user in collection 'users'
        // and add a new array 'favorites' to the document:
        await favoritesOperations.set(favoritesReference, {
          'favorites': [recipeId]
        });
      }
    }).then((result) {
      return true;
    }).catchError((error) {
      print('Error: $error');
      return false;
    });
  }
}