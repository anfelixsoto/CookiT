import 'package:cookit_demo/RecipeDetails.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:cookit_demo/model/RecipeList.dart';
import 'package:flutter/material.dart';

import 'model/RecipeList.dart';
import 'model/recipeId.dart';

void main(){
  runApp(MaterialApp(
    title: 'CookiT Recipe Results',
    home: RecipeResults(ingredients:['salt','pepper','salmon','lemon']),
  ));
}

class RecipeResults extends StatefulWidget {
  final List<String> ingredients;
  RecipeResults({Key key,@required this.ingredients}):super(key:key);

  @override
  _RecipeResults createState() => _RecipeResults();
}

class _RecipeResults extends State<RecipeResults>{
  Future<RecipeList> recipes;
  List<RecipeId> recipeList;
  List<Recipe> recipeItems;
  static var recipees=new List<Recipe>();
  //_RecipeResults({Key key,@required this.ingredients}):super(key:key);

   @override
  void initState(){
    super.initState();
    recipes = RecipeList.fetchRecipes(widget.ingredients);
    recipeItems=new List<Recipe>(0);
  }

  String getIngredientString(){
    String s="";
    for(int i=0;i<widget.ingredients.length;i++){
      if(i==(widget.ingredients.length-1)){
        s+=widget.ingredients[i];
      }
      else{
        s+=(widget.ingredients[i]+",");
      }
    }
    return s;
  }
  
  Future<List<Recipe>> getRes(List<RecipeId> ids) async{
    List<Recipe> list = await Future.wait(ids.map((itemId) => Recipe.fetchRecipe(itemId.rid)));
    return list.map((response){
      // do processing here and return items
      return response;
    }).toList();
  }

  @override
  Widget build(BuildContext context){

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          automaticallyImplyLeading: true,
          title: Text('Recipe Results'),
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: FutureBuilder<RecipeList>(
            future: recipes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                recipeList=snapshot.data.recipes;
                Future<List<Recipe>> recipees=getRes(recipeList);
                return FutureBuilder<List<Recipe>>(
                  future: recipees,
                  builder: (context, snapshot2) {
                    if (snapshot2.hasData) {
                      List<Recipe> rec=snapshot2.data;
                        return Center(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(36.0),
                              child: ListView(
                                children: <Widget>[
                                  SizedBox(height: 20.0,),
                                  Text(
                                    "Recipe Results",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35.0,
                                      color: Colors.lightGreen,)
                                  ),
                                  SizedBox(height: 30.0,),
                                  Text(
                                    getIngredientString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.grey,)
                                  ),
                                  new Container(
                                    height: 400.0,
                                    child: new ListView.builder(
                                      itemCount: rec.length,
                                      itemBuilder: (context, index) {
                                        if(rec.length>0){
                                        Recipe rTest=rec[index];
                                        if(rTest!=null&&
                                        rTest.ingredients!=null&&
                                        rTest.instructions!=null&&
                                        rTest.instructions.isNotEmpty&&
                                        rTest.ingredients.isNotEmpty){
                                            return new Padding(
                                            padding:EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                                            child:Material(
                                              elevation: 5.0,
                                              borderRadius: BorderRadius.circular(30.0),
                                              color: Colors.lightGreen,
                                              child:MaterialButton(
                                                minWidth: MediaQuery.of(context).size.width,
                                                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                onPressed: (){
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => RecipeDetails(recipe:rec[index]))
                                                  );
                                                },
                                                child: Text(rec[index].name,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        else{
                                          return SizedBox(height:0.0);
                                        }
                                        }return SizedBox(height:0.0);
                                          }),
                                      //},
                                    ),
                                  //),
                                ],
                              ),
                            ),
                          ),
                        );
                      } 
                      else if(snapshot2.hasError){
                        //return Text("${snapshot2.error}");
                        return Text(
                          "Oh no, an error occured:(\nWe apologize for the inconvenience.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                            color: Colors.red,),
                        );
                      }  
                      return CircularProgressIndicator(); 
                    });
              } else if (snapshot.hasError) {
                //return Text("${snapshot.error}");
                return Text(
                      "Oh no, an error occured:(\nWe apologize for the inconvenience.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0,
                        color: Colors.red,),
                    );
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}