import 'dart:convert';
import 'dart:io';
import 'package:cookit_demo/model/recipeId.dart';
import 'package:cookit_demo/model/Recipe.dart';

import 'package:http/http.dart' as http;

String getUrlString(List<String> ingredients){
    String request='';
    for(int i=0;i<ingredients.length;i++){
      if(i==(ingredients.length-1)){
        request+=ingredients[i];
      }
      else{
        request+=(ingredients[i]+',+');
      }
    }
    return request;
  }

class RecipesList{
  final List<Recipe> recipes;
  RecipesList({this.recipes});

  factory RecipesList.fromJSON(List<dynamic> json){
    return RecipesList(recipes:json.map((p) => Recipe.recipecheat(RecipeId.fromJSON(p).rid)).toList());
  }


  static Future<RecipesList> fetchRecipes(List<String> ingredients) async {
    String url=getUrlString(ingredients);
    final response =
      await http.get('https://api.spoonacular.com/recipes/findByIngredients?ingredients='+url+'&number=2&apiKey=18743cb58f294573a49a41d78c78a8ce');

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON.
        return RecipesList.fromJSON(json.decode(response.body));
          } else {
            // If that call was not successful, throw an error.
            throw Exception('Failed to load post');
          }
  }
}