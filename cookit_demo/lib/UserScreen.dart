import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/HomeScreen.dart';
import 'package:cookit_demo/ImageUpload.dart';
import 'package:cookit_demo/recipeResults.dart';
import 'package:cookit_demo/Model/User.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'dart:io';

import 'model/PostModel.dart';
void main(){
  runApp(new MaterialApp(
    home: UserProfile(),
  ));
}


class UserProfile extends StatefulWidget {

  final String userId;

  UserProfile({this.userId});

  @override
  _UserProfile createState() => new _UserProfile();
}


class _UserProfile extends State<UserProfile> {

  FirebaseUser currentUser;
  String username;
  int postCount = 0;
  int _selectedIndex = 0;



  @override
  void initState() {
    super.initState();
    loadCurrentUser();
    //showEmail();
    //showUsername();
  }

  void loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentUser = user;
      });
    });
  }

  String showEmail() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "no current user";
    }
  }








  Widget _buildAvatar() {
    return new Container(
      width: 180.0,
      height: 180.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white30),
      ),
      margin: const EdgeInsets.only(top: 32.0, left: 16.0),
      padding: const EdgeInsets.all(3.0),
      child: ClipOval(
        child: Image.network(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbEs2FYUCNh9EJ1Hl_agLEB6oMYniTBhZqFBMoJN2yCC1Ix0Hi&s',
        ),
      ),);
  }



  Widget findRecipes(String text, {
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.white,
  }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(100.0),
      child: new MaterialButton(
        minWidth: 120.0,
        height: 40.0,

        color: Colors.lightBlueAccent,
        textColor: textColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecipeResults()),
          );
        },
        child: new Text(text),
      ),
    );
  }


  Widget showFavorites(String text, {
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.white,
  }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(100.0),
      child: new MaterialButton(
        minWidth: 120.0,
        height: 40.0,

        color: Colors.lightBlueAccent,
        textColor: textColor,
        onPressed: () {

        },
        child: new Text(text),
      ),
    );
  }


    Future<List<Post>> getPosts() async {
      List<Post> posts = [];
      var snap = await Firestore.instance
          .collection('posts')
          .where('email', isEqualTo: showEmail())
          .getDocuments();
      for (var doc in snap.documents) {
        posts.add(Post.fromDoc(doc));
      }
      setState(() {
        postCount = snap.documents.length;
      });
      return posts.reversed.toList();
    }

  void _onItemTapped(int index) {
    if(index == 0) {

    }
    else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }

    else if(index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PostUpload()),
      );
    }
  }



  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(

        title: Text(showEmail()),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        actions: <Widget>[
        ],
      ),
          body: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: _buildAvatar(),
                    ),
                    Row(
                      children: <Widget>[



                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  findRecipes('What to Cook'),
                                  showFavorites('Favorites'),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[

                                  ]),
                            ],
                          ),
                        )
                      ],
                    ),


                  ],
                ),
              ),
              Divider(),
              //buildImageViewButtonBar(),
              Divider(height: 0.0),
              Container (
                 child: FutureBuilder<List<Post>>(
                  future: getPosts(),
                 builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                          alignment: FractionalOffset.center,
                          padding: const EdgeInsets.only(top: 10.0),
                          child: CircularProgressIndicator());
                    else {
                    // build the grid
                          return GridView.count(

                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                          //                    padding: const EdgeInsets.all(0.5),
                          mainAxisSpacing: 1.5,
                          crossAxisSpacing: 1.5,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: snapshot.data.map((Post post) {
                            return GridTile(
                                child: showPosts(post.imageUrl),
                            );
                          }).toList());
                        }
                    },

                  ),
               ),
              //Divider(height: 10.0),

            ]

        ),
        bottomNavigationBar: BottomNavigationBar( // footer
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              title: Text('New Post'),

            ),

          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),

      );
  }
}

Widget showPosts(url){
  return Container (
    child: new Image.network(
      url,
      fit: BoxFit.cover,
    ),

  );
}