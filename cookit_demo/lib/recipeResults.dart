import 'package:cookit_demo/RecipeDetails.dart';
import 'package:cookit_demo/model/Recipe.dart';
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
  //_RecipeResults({Key key,@required this.ingredients}):super(key:key);

   @override
  void initState(){
    super.initState();
    recipes = RecipeList.fetchRecipes(widget.ingredients);
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
                              itemCount: snapshot.data.recipes.length,
                              itemBuilder: (context, index) {
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
                                              MaterialPageRoute(builder: (context) => RecipeDetails(recipeId:snapshot.data.recipes[index].rid))
                                          );
                                        },
                                        child: Text(snapshot.data.recipes[index].rname,
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
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
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