import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/ImageUpload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'dart:io';
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


  @override
  void initState() {
    super.initState();
    loadCurrentUser();
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

  Widget _buildActionButtons(ThemeData theme) {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          createButton(
            'What to Cook?',
            backgroundColor: theme.accentColor,
          ),
          createButton(
            'Favorites',
            backgroundColor: theme.accentColor,

          ),

        ],
      ),
    );
  }

  Widget createButton(
      String text, {
        Color backgroundColor = Colors.transparent,
        Color textColor = Colors.white,
      }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: 150.0,
        height: 50.0,

        color: Colors.lightBlueAccent,
        textColor: textColor,
        onPressed: () {},
        child: new Text(text),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

      var theme = Theme.of(context);



      return new Stack(


        children: <Widget>[
          //_buildDiagonalImageBackground(context),


          Container(
            color: Colors.white,
          ),
          new Align(
            alignment: FractionalOffset.bottomCenter,
            heightFactor: 1,

            child: new Column(
              children: <Widget>[
                AppBar(
                  title: Text(showEmail()),
                  backgroundColor: Colors.lightGreen,
                ),
                _buildAvatar(),
                _buildActionButtons(theme),
                Expanded(
                  child: GridView.count(
                    shrinkWrap: true, // use this
                    crossAxisCount: 4,
                    children: new List<Widget>.generate(22, (index) {
                      return new GridTile(
                        child: new Card(
                            color: Colors.blue.shade200,
                            child: new Center(
                              child: new Text('tile $index'),
                            )
                        ),
                      );
                    }),
                  ),
                ),
                // footer
                new Container(
                  height: 40.0,
                  color: Colors.lightBlueAccent,
                  child: Center(
                    child: RaisedButton(
                      child: Text('New Post'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                    ),
                  ),
                ),

              ],
            ),
          ),

        ],
      );

  }
}



/*
class UserProfile extends StatelessWidget {


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

  Widget _buildActionButtons(ThemeData theme) {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          createButton(
            'What to Cook?',
            backgroundColor: theme.accentColor,
          ),
          createButton(
            'Favorites',
            backgroundColor: theme.accentColor,

          ),

        ],
      ),
    );
  }

  Widget createButton(
      String text, {
        Color backgroundColor = Colors.transparent,
        Color textColor = Colors.white,
      }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: 150.0,
        height: 50.0,

        color: Colors.lightBlueAccent,
        textColor: textColor,
        onPressed: () {},
        child: new Text(text),
      ),
    );
  }




  Widget build(BuildContext context) {
    var theme = Theme.of(context);



    return new Stack(

      children: <Widget>[
        //_buildDiagonalImageBackground(context),
        Container(
          color: Colors.white,
        ),
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1,

          child: new Column(
            children: <Widget>[
              AppBar(
                title: Text('Welcome ' ),
                backgroundColor: Colors.lightGreen,
              ),
              _buildAvatar(),
              _buildActionButtons(theme),
              Expanded(
                child: GridView.count(
                  shrinkWrap: true, // use this
                  crossAxisCount: 4,
                  children: new List<Widget>.generate(33, (index) {
                    return new GridTile(
                      child: new Card(
                          color: Colors.blue.shade200,
                          child: new Center(
                            child: new Text('tile $index'),
                          )
                      ),
                    );
                  }),
                ),
              ),
              // footer
              new Container(
                height: 40.0,
                color: Colors.lightBlueAccent,
                child: Center(
                  child: RaisedButton(
                    child: Text('New Post'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                  ),
                ),
              ),

            ],
          ),
        ),

      ],
    );
  }
}


class PostUpload extends StatelessWidget {
  Widget createButton(
      String text, {
        Color backgroundColor = Colors.transparent,
        Color textColor = Colors.white,
      }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: 150.0,
        height: 50.0,

        color: Colors.lightBlueAccent,
        textColor: textColor,
        onPressed: () {},
        child: new Text(text),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),
        backgroundColor: Colors.lightGreen,

      ),
      body: Center(
        child: Column (
          children: <Widget>[

            createButton(
              'Image Upload',
              backgroundColor: Colors.lightBlueAccent,
            ),
          ],
        ),

      ),
    );
  }


 */