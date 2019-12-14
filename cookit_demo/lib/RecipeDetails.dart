import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/RecipeInstructions.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:cookit_demo/model/recipeId.dart';
import 'package:cookit_demo/service/RecipeOperations.dart';
import 'package:cookit_demo/service/UserOperations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
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
  final RecipeId recipeId;
  final Recipe recid;
  RecipeDetails({Key key,@required this.recipe, this.recipeId, this.recid}):super(key:key);


  @override
  _RecipeDetails createState() => _RecipeDetails();
}
class _RecipeDetails extends State<RecipeDetails>{
  Recipe recipe;
  FirebaseUser currentUser;
  String username;
  DocumentReference userRef;
  String currEmail;
  String userId;
  bool saved = false;
  bool favorite = false;


  @override
  void initState(){
    super.initState();
    recipe = widget.recipe;
    getUserRef();

    if(widget.recipeId != null){
      RecipeOperations.addToRecipes(widget.recipeId.rid.toString(), recipe);
    }
    getFavorites();
  }

  Future<List<String>> getFavorites() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(userId)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('favorites') &&
        querySnapshot.data['favorites'] is List) {
      // Create a new List<String> from List<dynamic>
      print(querySnapshot.data['favorites']);
      querySnapshot.data.forEach((m,v) {
        print(v);
      });

      setState(() {
        if(widget.recipeId != null && List<String>.from(querySnapshot.data['favorites']).contains(widget.recipeId.rid.toString())){
          favorite = true;
        } else if(widget.recid != null && List<String>.from(querySnapshot.data['favorites']).contains(widget.recid.id.toString())){
          favorite = true;
          print(favorite.toString());
        }else{
          favorite = false;
        }
      });
      return List<String>.from(querySnapshot.data['favorites']);
    }
    return [];
  }


  Future<void> getUserRef() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;

    FirebaseUser user = await _auth.currentUser();
    List<String> favorites = await getFavorites();

    setState((){
      userRef = _firestore.collection('users').document(user.uid);
      userId = user.uid;

      userRef.get().then((data){
        //print(List<String>.from(data.data["favorites"]).contains(1059776));

        setState((){
          if(widget.recipeId != null && List<String>.from(data.data["favorites"]).contains(widget.recipeId.rid.toString())){
            favorite = true;
          } else if(widget.recid != null && List<String>.from(data.data["favorites"]).contains(widget.recid.id.toString())){
            favorite = true;
            print(favorite.toString());
          }else{
            favorite = false;
          }


        });
      });


      //String recipeId = recipe.toString();
      //log(recipeId);

      for(var i = 0; i < favorites.length; i++){
        log(favorites[i]);
      }

      /*userRef.get().then((data) {
        if (data.exists) {
          profileImage = data.data['profileImage'].toString();
        }
      });*/


      //print(user.displayName.toString());
    });
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
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            'Details',
            style: TextStyle(color: Colors.lightGreen),
          ),
          leading: IconButton(
            color: Colors.lightGreen,
            icon:Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          actions: <Widget>[
            showStar(),

          ],

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
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 5.0,),
                  new Container(
                      height:250.0,
                      width: MediaQuery.of(context).size.width,
                      child:Image.network(
                        recipe.imageURL,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        //fit: BoxFit.fill,
                      )
                  ),


                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                    child: Container(
                      height: 120.0,
                      width: MediaQuery.of(context).size.width,
                      child:ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Container(

                              width:(MediaQuery.of(context).size.width/2),
                              child:ListView(
                                  children: <Widget>[
                                    new Text(
                                        recipe.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.0,
                                          color: Colors.black,)
                                    ),
                                    new Text(
                                        recipe.description,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.0,
                                          color: Colors.grey,)
                                    ),
                                  ]
                              ),
                            ),

                            Container(
                              width:(MediaQuery.of(context).size.width/2),
                              child:Padding(
                                padding:EdgeInsets.fromLTRB(20.0, 40, 40.0, 45.0),
                                child:Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.lightGreen,
                                  child:MaterialButton(

                                    minWidth: MediaQuery.of(context).size.width,
                                    onPressed: (){
                                      if(widget.recipeId  != null) {
                                        UserOperations.addToSave(userId,
                                            widget.recipeId.rid
                                                .toString());
                                        //UserOperations.addToFavorites(userId, widget.recipeId.rid.toString());
                                        RecipeOperations.addToRecipes(
                                            widget.recipeId.rid
                                                .toString(), recipe);
                                      }else{
                                        UserOperations.addToSave(userId,
                                            widget.recid.id
                                                .toString());
                                        //UserOperations.addToFavorites(userId, widget.recipeId.rid.toString());
                                        RecipeOperations.addToRecipes(
                                            widget.recid.id
                                                .toString(), recipe);
                                      }
                                    },
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
                  ),


                  new Container(
                    height: 100.0,
                    child:ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 25),

                        children: <Widget>[


                          Container(

                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            width:(MediaQuery.of(context).size.width/3),
                            child:ListView(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[

                                      new Icon(
                                        Icons.restaurant_menu,
                                        size: 20.0,
                                        color: Colors.lightGreen,
                                      )
                                      ,
                                      new SizedBox(
                                          width: 5.0
                                      ),
                                      new Text(
                                          recipe.ingredients.length.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: Colors.lightGreen,)
                                      ),
                                    ],
                                  ),

                                  new Text(
                                      "Ingredients",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20.0,
                                        color: Colors.black,)
                                  ),

                                ]
                            ),
                          ),
                          Container(
                            width:(MediaQuery.of(context).size.width/3),
                            child:Column(
                              //padding: EdgeInsets.symmetric(horizontal: 0),
                                children: <Widget>[

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.timer,
                                        size: 20.0,
                                        color: Colors.lightGreen,

                                      )
                                      ,
                                      SizedBox(
                                          width: 5.0
                                      ),
                                      new Text(

                                          recipe.prepTime.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: Colors.lightGreen,)
                                      ),
                                    ],
                                  ),
                                  new Text(
                                      "Minutes",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20.0,
                                        color: Colors.black,)
                                  ),
                                ]
                            ),
                          ),
                          Container(
                            width:(MediaQuery.of(context).size.width/3),
                            child:ListView(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                children: <Widget>[

                                  new Text(
                                      recipe.numCalories.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.lightGreen,)
                                  ),


                                  new Text(
                                      "Calories",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
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
                                   Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RecipeInstructions(recipe:recipe, rId: widget.recipeId.rid.toString()))
                                    )
                                        :Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RecipeInstructions(recipe:recipe, rId: widget.recid.toString()))
                                    );*/

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

  Widget showStar(){
    if(favorite == false){
      return IconButton(
        icon: Icon(Icons.favorite_border,
            color: Colors.red,
            size: 30),
        onPressed: (){
          print("pressed");
          setState(() {
            favorite = true;
          });
          //print(widget.recipeId.rid.toString());
          if(widget.recipeId != null){
            UserOperations.addToFavorites(userId, widget.recipeId.rid.toString());
            RecipeOperations.addToRecipes(widget.recipeId.rid.toString(), recipe);

          }else{

            UserOperations.addToFavorites(userId, widget.recid.id.toString());
            RecipeOperations.addToRecipes(widget.recid.id.toString(), recipe);
          }



          print("saved");
        },
      );
    } else{
      return IconButton(
        icon: Icon(Icons.favorite,
            color: Colors.red,
            size: 30),
        onPressed: (){
          setState(() {
            favorite = false;
          });
          if(widget.recipeId != null) {
            UserOperations.deleteFavorite(userId, widget.recipeId.rid.toString());
          }else{
            UserOperations.deleteFavorite(userId, widget.recid.id.toString());
          }


        },
      );
    }
  }

}