import 'package:avatar_glow/avatar_glow.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookit_demo/delayed_animation.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main(){
  runApp(MaterialApp(
    title: 'CookiT Recipe Results',
    home: RecipeInstructions(),
  ));
}

class RecipeInstructions extends StatelessWidget {

  //Recipe recipe=new Recipe.none();
  List<String> ingredients=new List();  
  List<String> steps=new List();
  RecipeInstructions(){
    ingredients.add('12 ounce salmon fillet, cut into 4 pieces');    
    ingredients.add('pepper');   
    ingredients.add('salt');  
    ingredients.add('baked squash'); 
    steps.add('Preheat the oven to 450 degrees F.');
    steps.add('Season salmon with salt and pepper. Place salmon, skin side down, on a non-stick baking sheet or in a non-stick pan with an oven-proof handle. Bake until salmon is cooked through, about 12 to 15 minutes. Serve with the squash, if desired.');
  }

  @override
  Widget build(BuildContext context){

    final imageView=Image.network(
      'https://www.jessicagavin.com/wp-content/uploads/2019/01/baked-salmon-8-1200.jpg',
      fit: BoxFit.fill,);
    final recipe=Recipe('Baked Salmon',450,20,2,ingredients,steps);

    final detailsView=ListView(
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
                "Prep time: "+recipe.prepTime.toString(),
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey,)
              ),
              new Text(
                "Calories: "+recipe.numCalories.toString(),
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey,)
              ),
              new Text(
                "Serving size: "+recipe.servings.toString(),
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey,)
              ),
            ]
          ),
        ),
        Container(
          width:120.0,
          child:Padding(
            padding:EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 30.0),
            child:Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.lightGreen,
              child:MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                onPressed: (){},
                child: Text("Take a photo",
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
                      child:detailsView,
                    ),
                    new Container(
                      height: 30.0,
                      child:ListView(
                        children: <Widget>[
                          new AutoSizeText(
                            "Ingredients",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.black,)
                          ),
                        ]
                      ),
                    ),
                    new Container(
                      height:80.0,
                      child:new ListView.builder(
                        itemCount: recipe.ingredients.length,
                        itemBuilder: (context, index) {
                          return new AutoSizeText(recipe.ingredients[index],
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            )
                          );
                        }
                      ),
                    ),
                    new Container(
                      height:20.0,
                      child: AutoSizeText(
                            "Instructions",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.black,)
                        ),
                    ),
                    new Container(
                      height:400.0,
                      child:new ListView.builder(
                        itemCount: recipe.instructions.length,
                        itemBuilder: (context, index) {
                          return new AutoSizeText(recipe.instructions[index],
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            )
                          );
                        }
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      ),
    );

  }
}