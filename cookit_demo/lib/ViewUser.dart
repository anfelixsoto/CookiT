// for user view. Not implemented yet
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/HomeScreen.dart';
import 'package:cookit_demo/ImageUpload.dart';
import 'package:cookit_demo/UserScreen.dart';
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
      userId= user.uid;

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
              width: 500,
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
          width: 180.0,
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
  Future<void> showAlert(BuildContext context, String userId, String role, String email) {
    return showDialog(context: context,builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Seclect an option: '),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text('Delete user: ' + email.toString()),
                onTap: (){
                  //removeImage(url);
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

  Widget showDelete(BuildContext context, String userId, String role, String email) {

    return  Visibility(

      child: IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () {
            showAlert(context, userId, role, email);
          }
      ),

    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(



        title: Text(getUsername().toString()),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        actions: <Widget>[
          role == "admin"?

         showDelete(context, widget.otherId, role,otherEmail)
              :  new IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              //showDelete(context, widget.otherId, role, otherEmail);
            },

          ),
        
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
        Divider(),
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
          builder: (context) => PostDetails(post: post, currId: currId, currEmail: currEmail, currRole: role,),
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


  // In the constructor, require a Post.
  PostDetails({Key key, @required this.post, @required this.currId, @required this.currEmail,  @required this.currRole}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // Use the Post to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),

        child: Card(

          child: Padding(
            padding:EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: Column(
                children: <Widget>[



                  ListTile(
                    leading: IconButton(
                      icon:  post.profileImage != "" ? CircleAvatar(radius: 15.0, backgroundImage: NetworkImage(post.profileImage)):
                      CircleAvatar(
                        radius: 15.0,
                        backgroundImage: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbEs2FYUCNh9EJ1Hl_agLEB6oMYniTBhZqFBMoJN2yCC1Ix0Hi&s',
                        ),
                      ),
                  ),

                    contentPadding: EdgeInsets.all(7),

                    title: GestureDetector(
                      child:Text(
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
                  Divider(),
                  Center(

                    child: ClipRect(
                      child:Image.network(
                        post.imageUrl,

                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,

                      ),
                    ),
                  ),


                  Divider(),
                  Divider(),
                  ListTile(

                    title: Text(
                        post.description,
                        style: TextStyle(fontWeight: FontWeight.w500)
                    ),


                  ),
                  Divider(),
                  Divider(),
                  Divider(),
                  Divider(),
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
                      // show menu button
                     // post.email == currEmail ?






                    ],
                  ),


                ]
            ),
          ),
        ),
      ),
    );
  }
}
