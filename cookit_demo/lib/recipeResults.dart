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
        s+=(widget.ingredients[i]+", ");
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
    final resultsHeader=Center(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: ListView(
            children: <Widget>[
              /*SizedBox(height: 20.0,),
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
              ),*/
              SizedBox(height:50.0),
              Text(
                "No recipes found :(",
                textAlign: TextAlign.center,
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.lightGreen,)
              ),
            ]
          ),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          title: Text('Recipe Results',
          style: TextStyle(color: Colors.lightGreen),
          ),
          leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.lightGreen),
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
                if(recipeList.isNotEmpty){
                  for(int i=0;i<recipeList.length;i++){
                    if(recipeList[i]!=null&&recipeList[i].mCount>0){
                      recipeList.removeAt(i);
                      i--;
                    }
                  }
                }
                Future<List<Recipe>> recipees=getRes(recipeList);
                return FutureBuilder<List<Recipe>>(
                  future: recipees,
                  builder: (context, snapshot2) {
                    if (snapshot2.hasData) {
                      List<Recipe> rec=snapshot2.data;
                      for(int i=0;i<rec.length;i++){
                        Recipe rTest=rec[i];
                        if(rTest==null||
                          rTest.ingredients==null||
                          rTest.instructions==null||
                          rTest.instructions.isEmpty||
                          rTest.ingredients.isEmpty){
                            rec.removeAt(i);
                            i--;
                          }
                        }
                        if(rec.length==0){
                          return resultsHeader;
                        }
                        else{
                        return Center(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ListView(
                                children: <Widget>[
                                  /*SizedBox(height: 10.0,),
                                  Text(
                                    "Recipe Results",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 30.0,
                                      color: Colors.lightGreen,)
                                  ),*/
                                  SizedBox(height: 10.0,),
                                  Text(
                                    getIngredientString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.grey,)
                                  ),
                                  SizedBox(height: 10.0,),
                                  new Container(
                                    height: 400.0,
                                    child:new ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: rec.length,
                                          itemBuilder: (context, index) {
                                            //if(temp3.contains(recipe.documentID) ) {
                                              return Container(
                                                height: 100,
                                                padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                                                child: Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Column(
                                                      children: <Widget>[
                                                        ListTile(
                                                          leading: CircleAvatar(radius: 30.0,
                                                            backgroundImage: NetworkImage(rec[index].imageURL),
                                                          ),
                                                          title: Text(rec[index].name.toString()),



                                                          subtitle: Text("Prep Time: " + rec[index].prepTime.toString() + " | " +
                                                              "Servings: " + rec[index].servings.toString()
                                                          ),
                                                          onTap: () {
                                                            //Recipe selectRecipe = Recipe.fromDoc(recipe);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => RecipeDetails(recipe: rec[index], recid: rec[index], )),
                                                            );
                                                          },
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                              );
                                            } )
                                          //},
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                        }
                      } 
                      else if(snapshot2.hasError){
                        //return Text("${snapshot2.error}");
                        print("${snapshot2.error}");
                        return Text(
                          "Oh no,\nan error occured:(\n\nWe apologize for the inconvenience.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Colors.red,),
                        );
                      }  
                      return CircularProgressIndicator(); 
                    });
              } else if (snapshot.hasError) {
                //return Text("${snapshot.error}");
                return Text(
                      "Oh no,\nan error occured:(\n\nWe apologize for the inconvenience.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 30.0,
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