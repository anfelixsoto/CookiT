import 'package:cookit_demo/model/Recipe.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main(){
  runApp(MaterialApp(
    title: 'CookiT Recipe Results',
    home: RecipeInstructions(recipe:null),
  ));
}

class RecipeInstructions extends StatelessWidget {
  final Recipe recipe;
  RecipeInstructions({Key key,@required this.recipe}):super(key:key){
  }

  @override
  Widget build(BuildContext context){

    final imageView=Image.network(
      recipe.imageURL,
      fit: BoxFit.fill,);
    //final recipe=Recipe('Baked Salmon','This healthy baked salmon is the best way to feed a crowd.',450,20,2,ingredients,steps);

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