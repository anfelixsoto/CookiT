// for user view. Not implemented yet
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/HomeScreen.dart';
import 'package:cookit_demo/ImageUpload.dart';
import 'package:cookit_demo/RecipeDetails.dart';
import 'package:cookit_demo/UserScreen.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:cookit_demo/recipeResults.dart';
import 'package:cookit_demo/Model/User.dart';
import 'package:cookit_demo/service/AdminOperations.dart';
import 'package:cookit_demo/service/Authentication.dart';

import 'package:cookit_demo/editProfile.dart';
import 'package:cookit_demo/service/UserOperations.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'dart:io';

import 'model/PostModel.dart';


class ViewUser extends StatefulWidget {
  // ViewUser({Key key,  this.userId,  this.otherUserId });
  final String userId;
  final String otherId;
  ViewUser({Key key, this.userId, this.otherId,})
      : super(key: key);

  // final BaseAuth auth;
  //final VoidCallback logoutCallback;


  @override
  _ViewUser createState() => new _ViewUser();
}


class _ViewUser extends State<ViewUser> {

  List<Post> postsFeed = [];
  FirebaseUser currentUser;
  DocumentReference userRef;
  DocumentReference otherUserRef;

  var role;
  var userQuery;
  bool isAdmin = false;
  String userId;
  int postCount;
  String profilePic;
  String otherEmail;
  String pic;
  String otherRole;
  String otherUsername;

  @override
  void initState(){
    super.initState();

    if(widget.userId.toString() == widget.otherId.toString()){
      print("Current User");
    }
    print(getPosts());
    getUserRef();
    //print(this.us);
  }

  Future<void> getUserRef() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;

    FirebaseUser user = await _auth.currentUser();

    setState((){
      userRef = _firestore.collection('users').document(user.uid);
      otherUserRef = _firestore.collection('users').document(widget.otherId.toString());
      userId = user.uid;
      userRef.get().then((data) {
        if (data.exists) {
          role = data.data['role'].toString();
          pic =  data.data['profileImage'].toString();
          print('Role: ' + role);
          if (role == 'admin') {
            isAdmin = true;
          }

        }
      });

      otherUserRef.get().then((data) {
        if (data.exists) {
          profilePic = data.data['profileImage'].toString();
          otherEmail = data.data['email'].toString();
          otherUsername = data.data['user_name'].toString();
          otherRole = data.data['role'].toString();
          print(otherEmail);

        }
      });

      //print(user.displayName.toString());
    });
  }

  String getuserId() {
    return userId;
  }

  String getUsername() {
    return otherUsername;
  }

  /*
  List<Widget> checkRole(AsyncSnapshot shot) {
    if (userRef.snapshots() == null) {
      print("Error");
    }
    AsyncSnapshot<DocumentSnapshot> snapshot = userRef;
    AsyncSnapshot<DocumentSnapshot> snap = snapshot;
    if (snap.data['role'] == 'admin') {
      return displayAdminPosts(shot);
    } else {
      return displayPosts(shot);
    }
  }
*/






  Future<void> removeImage(String url) async{
    //Future<StorageReference> photoReference =
    try {
      //String path;
      print (url);
      String path = url.replaceAll(new RegExp(r'%2F'), '---');
      // print(path.split('---')[1]);
      String remove = path.split('---')[1].replaceAll('?alt', '---');
      String img = remove.split('---')[0];
      print(img);
      final StorageReference storageReference =
      FirebaseStorage.instance.ref().child("UserRecipes/" + img);

      storageReference.delete();

    } catch (e) {
      return null;
    }
  }







  List<Widget> displayPosts(AsyncSnapshot snapshot) {
    return snapshot.data.documents.map<Widget>((document){
      if(widget.otherId.toString() == document['userId'].toString()) {
        return Padding(
            padding: EdgeInsets.symmetric( vertical: 10, horizontal: 1),
            child:Container(
              width: MediaQuery.of(context).size.width,
              child: Card(
                clipBehavior: Clip.antiAlias,
                // shape: shape,

                child: Padding(
                  padding:EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),

                  child: Column(
                      children: <Widget>[



                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: document['profileImage'] == null ? NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbEs2FYUCNh9EJ1Hl_agLEB6oMYniTBhZqFBMoJN2yCC1Ix0Hi&s',
                            ): NetworkImage(
                              document['profileImage'],
                            ),
                          ),

                          contentPadding: EdgeInsets.all(7),

                          title: GestureDetector(
                            child:Text(
                              document['email'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ViewUser(userId: getuserId(), otherId: document['userId'],)
                                ),
                              );
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


                          ],
                        ),


                      ]
                  ),
                ),

              ),
            )
        );
      } else{
        return Card(
          child: Text('User not found'),
        );
      }
    }).toList();
  }

  Future<List<Post>> getPosts() async {
    List<Post> posts = [];
    var snap = await Firestore.instance
        .collection('posts')
        .where("userId", isEqualTo: widget.otherId.toString())
        .getDocuments();
    for (var doc in snap.documents) {
      posts.add(Post.fromDoc(doc));
      //print(doc['user_name']);
    }
    setState(() {
      postCount = snap.documents.length;
    });
    return posts.toList();
  }






  Widget _buildAvatar() {
    return new GestureDetector(
        child: Container(
          width: (MediaQuery.of(context).size.width/3),
          height: 180.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white30),
          ),
          margin: const EdgeInsets.only(top: 32.0, left: 16.0),
          padding: const EdgeInsets.all(3.0),
          child:  ClipOval(
            child: (profilePic == null || profilePic == "" )
                ?
            Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbEs2FYUCNh9EJ1Hl_agLEB6oMYniTBhZqFBMoJN2yCC1Ix0Hi&s',
            )
                : Image.network(
              profilePic,
              height: 300,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),

        ),
        onTap:(){
          //showAlert(context, widget.otherId, otherRole);
        }
    );
  }
  Future<void> showAlert(BuildContext context, String userId, String role, String email, String url) {
    return showDialog(context: context,builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Seclect an option: '),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text('Delete user: ' + email.toString()),
                onTap: (){
                  adminRemovePic(url);
                  AdminOperations.deleteUser(userId);
                  Navigator.pop(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text('Grant admin role'),
                onTap: () {
                  AdminOperations.grantAdmin(userId);
                  Navigator.pop(context);
                },
              ),

              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.redAccent,
                    )
                ),

                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      );
    });
  }

  static Future<void> adminRemovePic(String url) async{
    //Future<StorageReference> photoReference =
    print("removing..");

    try {

      print (" deleteing..." + url.toString());
      String path = url.toString().replaceAll(new RegExp(r'%2F'), '---');

      String remove = path.split('---')[1].replaceAll('?alt', '---');
      String img = remove.split('---')[0];
      print(img);
      final StorageReference storageReference =
      FirebaseStorage.instance.ref().child("UserProfileImage/" + img);

      storageReference.delete();
      print (" deleted..." );


    } catch (e) {
      print("Something went wrong");
      return null;
    }
  }


  Widget showDelete(BuildContext context, String userId, String role, String email, String pic) {

    return  Visibility(

      child: IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.lightGreen,
            size: 30.0,
          ),
          onPressed: () {
            showAlert(context, userId, role, email, pic);
          }
      ),

    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getUsername().toString(),
          style: TextStyle(color: Colors.lightGreen),),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: new IconButton(icon: new Icon(Icons.arrow_back, color: Colors.lightGreen), onPressed: () => Navigator.of(context).pop(context)),
        actions: <Widget>[
          role == "admin"? showDelete(context, widget.otherId, role,otherEmail, profilePic) :
          new IconButton(icon: pic == " " || pic == null ? Icon(Icons.account_circle, color: Colors.grey[300], size: 40.0):
          CircleAvatar(radius:15.0, backgroundImage: NetworkImage(pic)),
            onPressed: () {}, ),
        ],
      ),
      body: ListView (
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
                  else if(snapshot.data.length == 0){
                    return Container(
                        alignment: FractionalOffset.center,
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text('No Posts')
                    );
                  }
                  else {
                    // build the grid
                    return GridView.count(

                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                        //                    padding: const EdgeInsets.all(0.5),
                        mainAxisSpacing: 1.5,

                        crossAxisSpacing: 1.5,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: snapshot.data.map((Post post) {
                          return GridTile(
                            child: showPosts(context, post, post.imageUrl, post.userId, post.email),
                          );
                        }).toList());


                  }
                },

              ),
            ),
          ]
      ),

    );
  }

  Widget showPosts(BuildContext context, Post post, url, String currId, String currEmail){
    return InkWell(
      //  onTap: () => print("Post " + post.id +" pressed"),
      onTap:() {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => PostDetails(post: post, currId: userId, currEmail: currEmail, currRole: role, loginProfilePic: pic,),
        ),);
      },
      child: Container (
        child: new Image.network(
          url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget getUserId(){
    return Container(
        child: FutureBuilder(
            future: FirebaseAuth.instance.currentUser(),
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot){
              if(snapshot.hasData){
                return Text(snapshot.data.uid);
              }else{
                return Text('Loading...');
              }
            }

        )

    );
  }




}


class PostDetails extends StatelessWidget {

  final Post post;
  String currId;
  String currEmail;
  String currRole;
  String loginProfilePic;

  // In the constructor, require a Post.
  PostDetails(
      {Key key, @required this.post, @required this.currId, @required this.currEmail, @required this.currRole, @required this.loginProfilePic})
      : super( key: key );

  @override
  Widget build(BuildContext context) {
    // Use the Post to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text( post.title,
          style: TextStyle( color: Colors.lightGreen ), ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: new IconButton(
            icon: new Icon( Icons.arrow_back, color: Colors.lightGreen ),
            onPressed: () => Navigator.of( context ).pop( context ) ),
        actions: <Widget>[
          IconButton(
              icon: loginProfilePic != null ? CircleAvatar( radius: 15.0,
                  backgroundImage: NetworkImage( loginProfilePic ) ) :
              Icon( Icons.account_circle, color: Colors.grey[300], size: 40.0 ),
              onPressed: () {}
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all( 10 ),
        child: Container(
          height: 530,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular( 15.0 ),
            ),
            color: Colors.grey[200],
            child: Padding(
              padding: EdgeInsets.fromLTRB( 0.0, 10.0, 0.0, 0.0 ),
              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: IconButton(
                        icon: post.profileImage != "" ? CircleAvatar(
                            radius: 15.0, backgroundImage: NetworkImage( post
                            .profileImage ) ) :
                        CircleAvatar(
                          radius: 15.0,
                          backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbEs2FYUCNh9EJ1Hl_agLEB6oMYniTBhZqFBMoJN2yCC1Ix0Hi&s',
                          ),
                        ),
                      ),

                      contentPadding: EdgeInsets.all( 7 ),

                      title: GestureDetector(
                        child: Text(
                          post.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {


                        },

                      ),


                      trailing: Text(
                        post.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 11,
                        ),
                      ),

                    ),
                    Center(

                      child: ClipRect(
                        child: Image.network(
                          post.imageUrl,

                          height: 300,
                          width: MediaQuery
                              .of( context )
                              .size
                              .width,
                          fit: BoxFit.cover,

                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                          post.description,
                          style: TextStyle( fontWeight: FontWeight.w500 )
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          child: Text( 'Cook it' ),
                          textColor: Colors.lightBlueAccent,
                          onPressed: () {
                            Firestore.instance.collection( 'recipes' ).document(
                                post.recipeId ).get( ).then( (data) {
                              //print(data.documentID);
                              Recipe postRecipe = Recipe.fromDoc( data );
                              print( postRecipe.id );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute( builder: (context) =>
                                      RecipeDetails( recipe: postRecipe,
                                        recid: postRecipe, ), )
                              );
                            } );
                          },
                        ),
                        FlatButton(
                          child: Text( 'Next time' ),
                          textColor: Colors.redAccent,
                          onPressed: () {
                            UserOperations.addToSave( currId,
                                post.recipeId.toString( ) );
                          },
                        ),
                        // show menu button
                        // post.email == currEmail ?
                      ],
                    ),
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}