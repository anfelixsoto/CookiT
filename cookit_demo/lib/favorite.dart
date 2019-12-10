//Daichi Kanasugi
//favorite.dart
//This file allows people to search through their favorite.

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Global Variable for List.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SearchAppBarRecipe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Favorites(title: 'SearchAppBarRecipe'),
    );
  }
}

class Favorites extends StatefulWidget {
  Favorites({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Favorites createState() => _Favorites();
}

class _Favorites extends State<Favorites> {
  _SearchAppBarDelegate _searchDelegate;
  FirebaseUser currentUser;

  bool loading = false;
  DocumentReference userRef;
  String profileImage;
  String userId;
  List<String> favorites;
  List<Recipe> recipes = [];
  List<String> favNames;
  List<String> favs = [];

  String filterRecipes;
  TextEditingController filterController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    //Initializing search delegate with sorted list of recipes
    loadCurrentUser();
    getUserRef();

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
          temp = List.from(data.data['favorites']);
          for(var i = 0; i < temp.length; i++){
            favs.add(temp[i]);
          }



        }
      });



      //print(user.displayName.toString());
    });

    filterController.addListener(() {
      setState(() {
        filterRecipes = filterController.text;
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


  Future<List<Recipe>> getFavorites() async {
    List<Recipe> temp = [];
    List<Recipe> results = [];
    List<String> names = [];
    var snap= await Firestore.instance
        .collection('users')
        .document(userId)
        .get();

    temp = List.from(snap.data['favorites']);

    for(var i in temp){
      DocumentSnapshot snapItem = await Firestore.instance
          .collection('recipes')
          .document(i.toString())
          .get();
      results.add(Recipe.fromDoc(snapItem));

    }
    return results;
  }






  List<Widget> displayFavorites(AsyncSnapshot snapshot) {
    return snapshot.data.documents.map<Widget>((document){
      if(document['name'].toString() != "") {
        return Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
            child: Container(
              width: 500,
              child: Card(
                clipBehavior: Clip.antiAlias,
                // shape: shape,

                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),

                  child: Column(
                      children: <Widget>[


                        Center(

                          child: ClipRect(
                            child: document['imageURL'].toString() != "" ?
                            Image.network(
                              document['imageURL'],
                              height: 200,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 0.0),
                              margin: const EdgeInsets.only(
                                  top: 0, bottom: 0.0),
                              height: 200,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              color: Colors.blueGrey[100],

                            ),

                          ),
                        ),

                        Divider(),

                        Divider(),
                        ListTile(
                          leading: Text(
                            document['name'].toString(),
                          ),
                        ),


                      ]
                  ),
                ),

              ),
            )
        );
      }else{
        return new Container();
      }
    }).toList();
  }








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Favorites'),
        actions: <Widget>[
          //Adding the search widget in AppBar
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            //Don't block the main thread
            onPressed: () {
              TextField(
                decoration: new InputDecoration(
                    labelText: "Search something"
                ),
                controller: filterController,
              );
            },
          ),
        ],
      ),
      body:Container(
        child: FutureBuilder<List<Recipe>>(
          future: getRecipeDetails(favs),
          builder: (context, AsyncSnapshot<List<Recipe>> snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                return Center(
                    child: CircularProgressIndicator()
                );
              default:
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (int, i) =>

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
            child: Container(
            width: 500,

                   child: Card(
                      clipBehavior: Clip.antiAlias,
                      // shape: shape,

                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                      child: Column(
                          children: <Widget>[


                            Center(

                              child: ClipRect(
                                child: snapshot.data[i].imageURL.toString() != "" ?
                                Image.network(
                                  snapshot.data[i].imageURL,
                                  height: 200,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  fit: BoxFit.cover,
                                )
                                    : Container(
                                  padding: EdgeInsets.only(top: 20.0, bottom: 0.0),
                                  margin: const EdgeInsets.only(
                                      top: 0, bottom: 0.0),
                                  height: 200,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  color: Colors.blueGrey[100],

                                ),

                              ),
                            ),

                            Divider(),

                            Divider(),
                            ListTile(
                              leading: Text(
                               snapshot.data[i].name,
                              ),
                            ),



                          ]
                        ),


                      ),
                    ),

            ),
                  ),
                );
            }

          },

        ),
      ),
    );
  }

  //Shows Search result
  void showSearchPage(BuildContext context,
      _SearchAppBarDelegate searchDelegate) async {
    final String selected = await showSearch<String>(
      context: context,
      delegate: searchDelegate,
    );

    if (selected != null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Your Word Choice: $selected'),
        ),
      );
    }
  }
}

//Search delegate
class _SearchAppBarDelegate extends SearchDelegate<String> {
  final List<String> _words;
  final List<String> _history;

  _SearchAppBarDelegate(List<String> words)
      : _words = words,
  //pre-populated history of words
        _history = <String>['apple', 'orange', 'banana', 'watermelon'],
        super();

  // Setting leading icon for the search bar.
  //Clicking on back arrow will take control to main page
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        //Take control back to previous page
        this.close(context, null);
      },
    );
  }

  // Builds page to populate search results.
  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('===Your Word Choice==='),
            GestureDetector(
              onTap: () {
                //Define your action when clicking on result item.
                //In this example, it simply closes the page
                this.close(context, this.query);
              },
              child: Text(
                this.query,
                style: Theme.of(context)
                    .textTheme
                    .display2
                    .copyWith(fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Suggestions list while typing search query - this.query.
  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions = this.query.isEmpty
        ? _history
        : _words.where((word) => word.startsWith(query));

    return _WordSuggestionList(
      query: this.query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        this.query = suggestion;
        this._history.insert(0, suggestion);
        showResults(context);
      },
    );
  }

  // Action buttons at the right of search bar.
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isNotEmpty ?
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ) : IconButton(
        icon: const Icon(Icons.mic),
        tooltip: 'Voice input',
        onPressed: () {
          this.query = 'TBW: Get input from voice';
        },

      ),
    ];
  }
}

// Suggestions list widget displayed in the search page.
class _WordSuggestionList extends StatelessWidget {
  const _WordSuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? Icon(Icons.history) : Icon(null),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: textTheme.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}