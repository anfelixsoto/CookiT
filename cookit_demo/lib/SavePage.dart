import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/RecipeDetails.dart';
import 'package:cookit_demo/service/Authentication.dart';
import 'package:cookit_demo/service/UserOperations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'model/Recipe.dart';

void main() => runApp(SavePage());

class SavePage extends StatefulWidget{
  SavePage({Key key, this.auth, this.userId}) : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  _SavedPage createState() => new _SavedPage();
}

class _SavedPage extends State<SavePage>{

  FirebaseUser currentUser;

  bool isLoading = false;
  DocumentReference userRef;
  String userId;
  List<String> savedRecipes = [];
  List<Recipe> userRecipes = [];

  @override
  void initState(){
    super.initState();
    loadCurrentUser;
    getUserRef();
  }

  void loadCurrentUser(){
    FirebaseAuth.instance.currentUser().then((FirebaseUser user){
      setState(() {
        this.currentUser = user;
      });
    });
  }

  Future<void> getUserRef() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;

    FirebaseUser user = await _auth.currentUser();

    setState(() {
      List<String> temp = [];
      userRef = _firestore.collection('users').document(user.uid);
      userId = user.uid;
      userRef.get().then((data){
        if(data.exists){
          temp = List.from(data.data['saved']);
          for(var i = 0; i < temp.length; i++){
            savedRecipes.add(temp[i]);
          }
          goThroughList();
        }
      });
    });
  }

  void goThroughList(){
    for(var i = 0; i < savedRecipes.length; i++){
      log('savedRecipes[' + i.toString() + ']:' + savedRecipes[i]);
    }
  }

  Future<List<String>> getSavedRecipes() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(userId)
        .get();
    if(querySnapshot.exists &&
        querySnapshot.data.containsKey('saved') &&
        querySnapshot.data['saved'] is List){
      return List<String>.from(querySnapshot.data['saved']);
    }

    return [];
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('BookMarks',
          style: TextStyle(color: Colors.lightGreen,),),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.lightGreen,
          ),
          onPressed: (){Navigator.pop(context);},
        ),
      ),
      body: FutureBuilder<List<Recipe>>(
          future: getRecipeDetails(savedRecipes),
          builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator());
            else if(snapshot.data.length == 0){
              return Container(
                  alignment: FractionalOffset.center,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text('No Bookmarked Items!')
              );
            } else{
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (int, i) =>
                    ListTile(
                      leading: CircleAvatar(radius: 30.0,
                      backgroundImage: NetworkImage(snapshot.data[i].imageURL),
                      ),
                      title: Text(snapshot.data[i].name),
                      subtitle: Text(""),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: (){
                          showAlert('saved', context, userId, snapshot.data[i].id);
                        },
                      ),
                      onTap: () {
                        //TODO: Implement recipeDetails
                      },
                    ),
              );
            }
          }
      ),
    );
  }

  Future<void> showAlert(String type, BuildContext context, String userId, String recipeId){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Are you sure you want to delete this?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(8.0),),
              GestureDetector(
                child: Text('Yes'),
                onTap: (){
                  UserOperations.delete(type, userId, recipeId);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SavePage()
                  ));
                },
              ),
              Padding(padding: EdgeInsets.all(8.0),),
              GestureDetector(
                child: Text('No'),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}