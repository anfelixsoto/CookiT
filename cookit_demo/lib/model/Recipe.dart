import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cookit_demo/model/Name.dart';
import 'package:cookit_demo/model/Instruction.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

class Recipe{
  String name;
  String description;
  String imageURL;
  double numCalories;
  int prepTime;
  int servings;
  @JsonKey(defaultValue: [''])
  List<String> ingredients;
  @JsonKey(defaultValue: [''])
  List<String> instructions;
  
  Recipe({this.name,this.description,this.imageURL,this.numCalories,this.prepTime,this.servings,this.ingredients,this.instructions});

  factory Recipe.fromJSON(Map<String,dynamic> json){
    return Recipe(
      name:json['title'],
      description: json['title'],
      imageURL:json['image'],
      numCalories:json['nutrition']['nutrients'][0]['amount'],
      prepTime:json['readyInMinutes'],
      servings:json['servings'],
      ingredients:(json['extendedIngredients'] as List).map((p) => Name.fromJson(p).name).toList(),
      instructions:(json['analyzedInstructions'].isNotEmpty)?(json['analyzedInstructions'][0]['steps'] as List).map((p) => Instruction.fromJson(p).step).toList():null,
      );
  }

  static FutureOr<Recipe> fetchRecipe(int id) async {
    final response =
        await http.get('https://api.spoonacular.com/recipes/'+id.toString()+'/information?includeNutrition=true&apiKey=d6c4887150dc409191eebfd9378ee595');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      return Recipe.fromJSON(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      //throw Exception('Failed to load post 2');
      throw Exception('Failed to load post');
    }
  }
}
