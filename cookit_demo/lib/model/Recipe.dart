import 'package:flutter/material.dart';

class Recipe{
  String name;
  int numCalories;
  int prepTime;
  int servings;
  List<String> ingredients;
  List<String> instructions;
  
  Recipe.justName(String name){
    this.name=name;
  }

  Recipe.none(){
  }

  Recipe(String name,int numCalories,int prepTime,int servings,List<String> ingredients,List<String> instructions){
    this.name=name;
    this.numCalories=numCalories;
    this.prepTime=prepTime;
    this.servings=servings;
    this.ingredients=ingredients;
    this.instructions=instructions;
  }
}