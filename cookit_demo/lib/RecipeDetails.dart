import 'package:cookit_demo/RecipeInstructions.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    title: 'CookiT Recipe Results',
    home: RecipeDetails(recipeName:""),
  ));
}

class RecipeDetails extends StatelessWidget {
  final String recipeName;
  Recipe recipe;
  List<String> ingredients=new List();  
  List<String> steps=new List();
  RecipeDetails({Key key,@required this.recipeName}):super(key:key)
  {
    //instead of mock adding dependencies: get recipe by recipe name
    ingredients.add('12 ounce salmon fillet, cut into 4 pieces');    
    ingredients.add('pepper');   
    ingredients.add('salt');  
    ingredients.add('baked squash'); 
    steps.add('Preheat the oven to 450 degrees F.');
    steps.add('Season salmon with salt and pepper. Place salmon, skin side down, on a non-stick baking sheet or in a non-stick pan with an oven-proof handle. Bake until salmon is cooked through, about 12 to 15 minutes. Serve with the squash, if desired.');
    this.recipe=Recipe('Baked Salmon','This healthy baked salmon is the best way to feed a crowd.','https://www.jessicagavin.com/wp-content/uploads/2019/01/baked-salmon-8-1200.jpg',450,20,2,ingredients,steps);
  }

  @override
  Widget build(BuildContext context){

  final imageView=Image.network(
    this.recipe.imageURL,
    fit: BoxFit.fill,);

  final titleView=ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          width:160.0,
          child:ListView(
            children: <Widget>[
                  new Text(
                    recipe.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black,)
                  ),
                  new Text(
                    recipe.description,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Colors.grey,)
                  ),
                ]
          ),
        ),
        Container(
          width:160.0,
          child:Padding(
            padding:EdgeInsets.fromLTRB(30.0, 20.0, 35.0, 25.0),
            child:Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.lightGreen,
              child:MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                onPressed: (){},
                child: Text("Save",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ]
    );

  final detailsView=ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
          Container(
          width:120.0,
          child:ListView(
                children: <Widget>[
                  new Text(
                    recipe.ingredients.length.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black,)
                  ),
                  new Text(
                    "Ingredients",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black,)
                  ),
                ]
              ),
          ),
          Container(
          width:80.0,
          child:ListView(
                children: <Widget>[
                  new Text(
                    recipe.prepTime.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black,)
                  ),
                  new Text(
                    "Minutes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black,)
                  ),
                ]
              ),
          ),
          Container(
          width:100.0,
          child:ListView(
                children: <Widget>[
                  new Text(
                    recipe.numCalories.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black,)
                  ),
                  new Text(
                    "Calories",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black,)
                  ),
                ]
              ),
        ),
      ]
    );

    final recipeButton=Padding(
      padding:EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child:Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.lightGreen,
        child:MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeInstructions(recipe:recipe))
            );
          },
          child: Text("Start Recipe",
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          automaticallyImplyLeading: true,
          title: Text('CookiT'),
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        backgroundColor: Colors.white,
        body: Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 5.0,),
                    new Container(
                      height:150.0,
                      width:600.0,
                      child:imageView
                    ),
                    new Container(
                      height: 80.0,
                      child:titleView,
                    ),
                    new Container(
                      height: 80.0,
                      child:detailsView,
                    ),
                    new Container(
                      height: 40.0,
                      child:recipeButton,
                    ),
                  ],
                ),
              ),
            )
        ),
      ),
    );

  }
}