import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/model/PostModel.dart';
import 'package:cookit_demo/model/Recipe.dart';
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

  static Future<void> addToFavorites(String userId, String recipeId) async {
    //DocumentReference favoritesReference = Firestore.instance.collection('users').document(userId);
    //DocumentSnapshot snapshot = await favoritesReference.get();
    Firestore.instance.collection('users')
        .document(userId)
        .get().then((data) {
          if (data.exists) {
            if(!data.data["favorites"].contains(recipeId)) {
              data.reference.updateData({
                'favorites': FieldValue.arrayUnion([recipeId]),
              });
            }
      } else{
            data.reference.setData({
              'favorites': [recipeId],
            });
          }
    });

  }

  static Future<void> removeFromFavorites(String userId, String recipeId) async {
    //DocumentReference favoritesReference = Firestore.instance.collection('users').document(userId);
    //DocumentSnapshot snapshot = await favoritesReference.get();
    Firestore.instance.collection('users')
        .document(userId)
        .get().then((data) {
      if (data.exists) {
        if(data.data["favorites"].contains(recipeId)) {
          data.reference.updateData({
            'favorites': FieldValue.arrayRemove([recipeId]),
          });
        }
      }
    });

  }

  static Future<DocumentSnapshot> getRecipeFromDB(String recipeId) {
    return Firestore.instance.collection('recipes')
        .document(recipeId)
        .get();

    //return data;
  }
  static  Future<void> deleteFavorite(String userId, String recipeId){
    Firestore.instance.collection('users')
        .document(userId)
        .get().then((data){
          if(data.exists){
            data.reference.updateData({
              'favorites' : FieldValue.arrayRemove([recipeId]),


            });
          }
    });
    print("Removed Favorited Recipe");
  }

  static Future<void> delete(String type, String userId, String recipeId){
    Firestore.instance.collection('users')
        .document(userId)
        .get().then((data){
          if(data.exists){
            data.reference.updateData({
              type : FieldValue.arrayRemove([recipeId]),
            });
          }
    });
  }

  static Future<void> addToSave(String userId, String recipeId) async{
    Firestore.instance.collection('users')
        .document(userId)
        .get().then((data){
      if(data.exists){
        data.reference.updateData({
          'saved' : FieldValue.arrayUnion([recipeId]),
        });
      } else{
        data.reference.setData({
          'saved': [recipeId],
        });
      }
    });
  }

}