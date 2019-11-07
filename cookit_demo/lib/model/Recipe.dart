import 'package:flutter/material.dart';

class Recipe{
  String name;
  int numCalories;
  int prepTime;
  List<String> ingredients;
  List<String> instructions;
  Recipe(String name){
    this.name=name;
    this.numCalories=numCalories;
    this.prepTime=prepTime;
    this.ingredients=ingredients;
    this.instructions=instructions;
  }
}