import 'package:flutter/material.dart';

class Recipe{
  String name;
  String description;
  String imageURL;
  int numCalories;
  int prepTime;
  int servings;
  List<String> ingredients;
  List<String> instructions;
  
  Recipe.justName(String name){
    this.name=name;
    this.imageURL="";
  }

  Recipe.none(){
  }

  Recipe(String name,String description,String imageURL,int numCalories,int prepTime,int servings,List<String> ingredients,List<String> instructions){
    this.name=name;
    this.description=description;
    this.imageURL=imageURL;
    this.numCalories=numCalories;
    this.prepTime=prepTime;
    this.servings=servings;
    this.ingredients=ingredients;
    this.instructions=instructions;
  }
}