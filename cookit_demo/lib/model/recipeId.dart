import 'package:json_annotation/json_annotation.dart';

class RecipeId{
  final int rid;
  final String rname;
  @JsonKey(defaultValue:1)
  final int mCount;
  RecipeId({this.rid,this.rname,this.mCount});


  factory RecipeId.fromJSON(Map<String,dynamic> json){
    return RecipeId(rid:json['id'],rname:json['title'],mCount:json['missedIngredientCount']);
  }

}