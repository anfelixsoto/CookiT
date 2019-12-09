//Daichi Kanasugi
//favorite.dart
//This file allows people to search through their favorite.

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
      userRef.get().then((data) {
        if (data.exists) {
          profileImage = data.data['profileImage'].toString();
          favorites = List.from(data.data['favorites']);
          print(favorites);


        }
      });


      //print(user.displayName.toString());
    });
  }


  Future<List<Recipe>> getFavorites() async {
    List<String> recipeIds = [];
    List<Recipe> recipes = [];
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(userId)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('favorites') &&
        querySnapshot.data['favorites'] is List) {
        for(var id in querySnapshot.data['favorites']) {
          recipeIds.add(id.toString());
        }
      //print(List<String>.from(querySnapshot.data['favorites']));
      //return List<String>.from(querySnapshot.data['favorites']);
    }



    for( var recipeId in recipeIds){
      DocumentSnapshot snap = await Firestore.instance
          .collection('recipes')
          .document(recipeId)
          .get();
      recipes.add(Recipe.fromDoc(snap));

    }
    return recipes;
  }

  List<Widget> displayFavorites(AsyncSnapshot snapshot) {
    return snapshot.data.documents.map<Widget>((document){


      return Padding(
          padding: EdgeInsets.symmetric( vertical: 10, horizontal: 1),
          child:Container(
            width: 500,
            child: Card(
              clipBehavior: Clip.antiAlias,
              // shape: shape,

              child: Padding(
                padding:EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),

                child: Column(
                    children: <Widget>[



                      ListTile(
                        leading: ClipOval(
                          child:Image.network(
                            document['imageUrl'] != ""?
                            document['imageUrl']: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbEs2FYUCNh9EJ1Hl_agLEB6oMYniTBhZqFBMoJN2yCC1Ix0Hi&s',


                            fit: BoxFit.cover,

                          ),
                        ),

                        contentPadding: EdgeInsets.all(7),

                        title: GestureDetector(
                          child:Text(
                            document['user_name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            if(userId != document['userId'] ) {

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    ViewUser(userId: userId.toString(),
                                        otherId: document['userId'].toString())
                                ),
                              );
                            } else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UserProfile(userId: widget.userId,
                                  auth: widget.auth,)),
                              );
                            }

                          },

                        ),


                        trailing: Text(
                          document['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 11,
                          ),
                        ),

                      ),
                      Divider(),
                      Center(

                        child: ClipRect(
                          child:Image.network(
                            document['imageUrl'],

                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,

                          ),
                        ),
                      ),

                      Divider(),
                      ListTile(
                        title: Text(
                            document['description'],
                            style: TextStyle(fontWeight: FontWeight.w500)),

                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            child: Text('Cook it'),
                            textColor: Colors.lightBlueAccent,
                            onPressed: () { print('pressed'); },
                          ),
                          FlatButton(
                            child: Text('Next time'),
                            textColor: Colors.orangeAccent,
                            onPressed: () { print('pressed'); },
                          ),

                          showDelete(context, Post.fromDoc(document).id.toString(), role.toString(), Post.fromDoc(document).imageUrl),

                        ],
                      ),


                    ]
                ),
              ),

            ),
          )
      );
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
              showSearchPage(context, _searchDelegate);
            },
          ),
        ],
      ),
      body: FutureBuilder <List<Recipe>>(
          future: getFavorites(),
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
                        child: Text('No Posts')
                    );
              } else{
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) =>
                      ListTile(
                        title: Text(snapshot.data[i].name.toString()),
                        onTap: () {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Click the Search action"),
                                  action: SnackBarAction(
                                    label: 'Search',
                                    onPressed: (){
                                      showSearchPage(context, _searchDelegate);
                                    },
                                  )
                              )
                          );
                        },
                      ),
                );
              }
              }

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