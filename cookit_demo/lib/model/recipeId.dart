class RecipeId{
  final int rid;
  final String rname;
  RecipeId({this.rid,this.rname});


  factory RecipeId.fromJSON(Map<String,dynamic> json){
    return RecipeId(rid:json['id'],rname:json['title']);
  }

}