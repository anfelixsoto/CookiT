import 'package:cookit_demo/RecipeInstructions.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:cookit_demo/model/recipeId.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    title: 'CookiT Recipe Results',
    //home: RecipeDetails(recipe:632660),
    home:RecipeDetails(recipe:null),
  ));
}

Widget buildError(BuildContext context, FlutterErrorDetails error) {
   return Scaffold(
     body: Center(
       child: Text(
         "Error appeared.",
         style: Theme.of(context).textTheme.title,
       ),
     )
   );
 }

class RecipeDetails extends StatefulWidget {
  final Recipe recipe;
  RecipeDetails({Key key,@required this.recipe}):super(key:key);

  @override
  _RecipeDetails createState() => _RecipeDetails();
}
class _RecipeDetails extends State<RecipeDetails>{
  Recipe recipe;

  @override
  void initState(){
    super.initState();
    recipe = widget.recipe;
  }

  @override
  Widget build(BuildContext context){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (BuildContext context, Widget widget) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return buildError(context, errorDetails);
          };
          return widget;
        },
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
              child: /*FutureBuilder<Recipe>(
              future: recipe,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return */
                   Container(
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 5.0,),
                          new Container(
                            height:150.0,
                            width:600.0,
                            child:Image.network(
                              recipe.imageURL,
                              fit: BoxFit.fill,),
                          ),
                          new Container(
                            height: 120.0,
                            child:ListView(
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
                                    padding:EdgeInsets.fromLTRB(30.0, 40.0, 35.0, 45.0),
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
                            ),
                          ),
                          new Container(
                            height: 80.0,
                            child:ListView(
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
                            ),
                          ),
                          new Container(
                            height: 40.0,
                            child:Padding(
                              padding:EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                              child:Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.lightGreen,
                                child:MaterialButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                  onPressed: (){
<<<<<<< Updated upstream
=======
                                    //print((widget.recipeId.rid.toString()));

                                    if(widget.recipeId != null){
                                      Firestore.instance.collection('recipes').document(widget.recipeId.rid.toString()).get().then((data) {
                                        //print(data.documentID);
                                        Recipe postRecipe = Recipe.fromDoc(data);
                                        print(postRecipe.id);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>
                                                RecipeInstructions(recipe: postRecipe,
                                                  rId: postRecipe, dbId: widget.recipeId),)
                                        );

                                      });
                                    }else{

                                      Firestore.instance.collection('recipes').document(widget.recid.id.toString()).get().then((data) {
                                        //print(data.documentID);
                                        Recipe postRecipe = Recipe.fromDoc(data);
                                        print(postRecipe.id);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>
                                                RecipeInstructions(recipe: postRecipe,
                                                  rId: widget.recid),)
                                        );

                                      });

                                    }

                                /*
                                    widget.recipeId != null ?


>>>>>>> Stashed changes
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
               /* } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
              ),*/
            ),
            ),
          );
  }

}