import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookit_demo/delayed_animation.dart';
import 'package:cookit_demo/RegisterActivity.dart';

void main(){
  runApp(MaterialApp(
    title: 'CookiT Recipe Results',
    home: RecipeResults(),
  ));
}

class RecipeResults extends StatelessWidget {
  List<String> recipes=new List(4);
  RecipeResults(){
    recipes[0]='Baked Salmon';
    recipes[1]='Pan Fried Salmon';
    recipes[2]='Microwave Salmon';
    recipes[3]='Salmon Sashimi';
  }
  @override
  Widget build(BuildContext context){
    final titleView = Text(
      "Recipe Results",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 35.0,
        color: Colors.lightGreen,)
    );

    final ingredientView = Text(
      "salmon,salt,pepper,lemon",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
        color: Colors.grey,)
    );

    final recipesView=ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(recipes[index]),
          onTap: () {
            //Go to the next screen with Navigator.push
          },
        );
      },
    );

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
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20.0,),
                    titleView,
                    SizedBox(height: 30.0,),
                    ingredientView,
                    new Container(
                      height: 400.0,
                      child: new ListView.builder(
                        itemCount: recipes.length,
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
                                  onPressed: (){},
                                  child: Text(recipes[index],
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
            )
        ),
      ),
    );
  }
}