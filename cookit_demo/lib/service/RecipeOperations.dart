import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:cookit_demo/model/recipeId.dart';

class RecipeOperations {
  static Future<void> addToRecipes(String recipeId, Recipe recipe) async {
    // when a user favorites/ saves recipe, store it in recipes collection
    Firestore.instance.collection('recipes')
        .document(recipeId)
        .setData({
      "name": recipe.name,
      "description": recipe.description,
      "imageURL": recipe.imageURL ,
      "numCalories": recipe.numCalories,
      "prepTime": recipe.prepTime,
      "servings": recipe.servings,
      "ingredients": recipe.ingredients,
      "instructions": recipe.instructions,

    });

  }
}