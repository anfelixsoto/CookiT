import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/RecipeDetails.dart';
import 'package:cookit_demo/RecipeInstructions.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:cookit_demo/service/UserOperations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//Global Variable for List.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SavePage(title: 'SearchAppBarRecipe'),
    );
  }
}

class SavePage extends StatefulWidget {
  SavePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SavePage createState() => _SavePage();
}

class _SavePage extends State<SavePage> {
  FirebaseUser currentUser;

  bool loading = false;
  DocumentReference userRef;
  String profileImage;
  String userId;
  List<String> savedRecipes;
  List<Recipe> recipes = [];
  List<String> favNames;
  List<String> saved = [];
  bool isAdmin = false;

  List<String> filterRecipes;
  TextEditingController editingController = TextEditingController();
  var items = List<String>();
  TextEditingController filterController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    //Initializing search delegate with sorted list of recipes
    loadCurrentUser();
    getUserRef();
    getSaved();


  }

  void getSaved(){
    print(saved);
  }
  void loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentUser = user;

      });
    });
  }

  Future<void> getUserRef() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;

    FirebaseUser user = await _auth.currentUser();

    //_searchDelegate = _SearchAppBarDelegate(favorites);

    setState((){
      userRef = _firestore.collection('users').document(user.uid);
      userId = user.uid;
      List<String> temp = [];
      userRef.get().then((data) {
        if (data.exists) {
          profileImage = data.data['profileImage'].toString();
          temp = List.from(data.data['saved']);
          for(var i = 0; i < temp.length; i++){
            saved.add(temp[i]);
            if(data.data['role'].toString() == 'admin'){
              isAdmin = true;
            }
          }
        }
      });
      //print(user.displayName.toString());
    });

    filterController.addListener(() {
      setState(() {
        //filterRecipes = filterController.text;
      });
    });
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }


  Future<List<Recipe>> getRecipeDetails(List<String> temp) async{
    List<Recipe> recipeDetails = [];
    Recipe recipe;
    String rec_id, rec_name, rec_description, rec_imageURL;
    double rec_numCal;
    int rec_prepTime, rec_servings;
    List<String> rec_ingredients;
    List<String> rec_instructions;

    for(var i in temp){
      DocumentSnapshot snapshot = await Firestore.instance
          .collection('recipes')
          .document(i)
          .get();
      if(snapshot.exists){
        rec_id = snapshot.data['id'].toString();
        rec_name = snapshot.data['name'].toString();
        rec_description = snapshot.data['description'].toString();
        rec_imageURL = snapshot.data['imageURL'].toString();
        rec_numCal = snapshot.data['numCalories'];
        rec_prepTime = snapshot.data['prepTime'];
        rec_servings = snapshot.data['servings'];
        rec_ingredients = List<String>.from(snapshot.data['ingredients']);
        rec_instructions = List<String>.from(snapshot.data['instructions']);
        recipe = new Recipe(id: rec_id,name: rec_name,description: rec_description,imageURL: rec_imageURL ,numCalories: rec_numCal
            ,prepTime: rec_prepTime,servings: rec_servings, ingredients: rec_ingredients,instructions: rec_instructions);
        recipeDetails.add(recipe);

      }
    }

    return recipeDetails;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: new Text('Bookmarks',
              style: TextStyle(color: Colors.lightGreen)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.lightGreen,
            ),
            onPressed: (){Navigator.pop(context);},
          ),
        ),
        body:Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('users')
                        .document(userId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      print(snapshot);
                      switch(snapshot.connectionState){
                        case ConnectionState.waiting:
                          return Center(
                              child: CircularProgressIndicator()
                          );
                        default:
                          if(!snapshot.hasData){
                            return Container(
                              alignment: FractionalOffset.center,
                              padding: const EdgeInsets.only(top: 10.0),
                              child: CircularProgressIndicator(),
                            );
                          }else if(snapshot.data['saved'].length == null ||snapshot.data['saved'].length == 0){
                            return Container(
                                alignment: FractionalOffset.center,
                                padding: const EdgeInsets.only(top: 1.0),
                                child: Text(
                                  'No Bookmarked Recipes!',
                                  style: TextStyle(
                                    color: Colors.lightGreen,
                                    fontSize: 20,
                                  ),
                                )
                            );
                          }else{
                            return new ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: List.generate(snapshot.data['saved'].length, (index) {
                                //print(snapshot.data['favorites'][index]);
                                List temp3 = [];
                                if(!temp3.contains(snapshot.data['saved'][index].toString())) {
                                  temp3.add(snapshot.data['saved'][index].toString());
                                }
                                return  StreamBuilder(
                                    stream: Firestore.instance
                                        .collection('recipes')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      print(snapshot);
                                      switch(snapshot.connectionState){
                                        case ConnectionState.waiting:
                                          return Center(
                                              child: CircularProgressIndicator()
                                          );
                                        default:
                                        // List videosList = snapshot.data;
                                          return ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: snapshot.data.documents.length,
                                            itemBuilder: (context, recipeId) {
                                              DocumentSnapshot recipe = snapshot.data.documents[recipeId];
                                              if(temp3.contains(recipe.documentID) ) {
                                                return Container(
                                                  height: 100,
                                                  padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                                                  child: Card(
                                                    clipBehavior: Clip.antiAlias,
                                                    child: Column(
                                                        children: <Widget>[
                                                          ListTile(
                                                            leading: CircleAvatar(radius: 30.0,
                                                              backgroundImage: NetworkImage(recipe.data['imageURL']),
                                                            ),
                                                            title: Text(recipe.data['name'].toString()),
                                                            subtitle: Text("Prep Time: " + recipe.data['prepTime'].toString() + " | " +
                                                                "Servings: " + recipe.data['servings'].toString()
                                                            ),
                                                            trailing: IconButton(
                                                              icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                                                              onPressed: (){
                                                                UserOperations.delete('saved', userId, recipe.documentID);
                                                              },
                                                            ),
                                                            onTap: () {
                                                              Recipe selectRecipe = Recipe.fromDoc(recipe);
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => RecipeDetails(recipe: selectRecipe, recid: selectRecipe, )),
                                                              );
                                                            },
                                                          ),
                                                        ]
                                                    ),
                                                  ),
                                                );
                                              } return Container(
                                              );
                                            },
                                          );
                                      }
                                    }
                                );
                              }
                              ),
                            );
                          }
                      }
                    }
                ),),
            ]
        ),
      ),
    );
  }
}