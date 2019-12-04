import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as prefix1;
import 'package:cookit_demo/model/PostModel.dart';
import 'package:cookit_demo/service/AdminOperations.dart';
import 'package:cookit_demo/service/Authentication.dart';
import 'package:cookit_demo/service/RootPage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cookit_demo/model/User.dart';

import 'package:cookit_demo/UserScreen.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}
class Home extends StatefulWidget {
  Home({Key key, this.auth, this.userId, this.logoutCallback, this.role})
      : super(key: key);


  final BaseAuth auth;
  final String userId;
  final VoidCallback logoutCallback;
  final String role;




  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  List<Post> postsFeed = [];
  FirebaseUser currentUser;
  DocumentReference userRef;
  var role;
  var userQuery;
  bool isAdmin = false;


  @override
  void initState(){
    super.initState();


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
      userRef.get().then((data) {
        if (data.exists) {
          role = data.data['role'].toString();
          print('Role: ' + role);
          if (role == 'admin') {
            isAdmin = true;
          }

        }
      });

      //print(user.displayName.toString());
    });
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

  Future<List<String>> getPosts() async {
    List<String> temp = [];
    final QuerySnapshot result = await Firestore.instance.collection('posts').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    //documents.forEach((data) => temp.add(data.documentID));
    for (var doc in documents){
      temp.add(doc.toString());
    }
    return temp;
  }



  Widget showDelete(String postId, String role, String url) {

      return  Visibility(
        visible: isAdmin,
        child: IconButton(
          icon: Icon(
            Icons.remove_circle,
            color: Colors.redAccent,
            size: 30.0,
          ),
          onPressed: () {
              removeImage(url);
              AdminOperations.deletePost(postId);
            }
          ),

      );

  }

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
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Card(
          child: Padding(
            padding:EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
          child: Column(
              children: <Widget>[



                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      "https://picsum.photos/250?image=9",
                    ),
                  ),

                  contentPadding: EdgeInsets.all(0),

                 title: Text(
                   document['email'],
                   style: TextStyle(
                     fontWeight: FontWeight.bold,
                   ),),


                  trailing: Text(
                    document['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                    ),
                  ),

                ),
                Image.network(
                  document['imageUrl'],

                  height: 170,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Divider(),
                ListTile(
                  title: Text(
                      document['description'],
                      style: TextStyle(fontWeight: FontWeight.w500)),

                ),
                ButtonBar(
                  alignment: MainAxisAlignment.start,
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

                    showDelete(Post.fromDoc(document).id.toString(), role.toString(), Post.fromDoc(document).imageUrl),

                  ],
                ),


      ]
      ),
      ),
      ),);
    }).toList();
  }


  signOut() async{
    try{
      await widget.auth.signOut();
      widget.logoutCallback();
    }catch(e){
      print(e);
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(



        title: Text("Home"),
        //centerTitle: true,
        backgroundColor: Colors.lightGreen,
        actions: <Widget>[

          new IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 40.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile(userId: widget.userId,
                  auth: widget.auth,)),
              );
            },

          ),
          new FlatButton(onPressed: signOut,
              child: new Text('Logout',
              style: new TextStyle(
                fontSize: 17.0,
                color: Colors.white,
              ))),
        ],
      ),
      body: Container(
       child: StreamBuilder(
              stream: Firestore.instance.collection('posts').snapshots(),
              builder: (context, snapshot) {
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                  return Center(
                      child: CircularProgressIndicator()
                  );
                default:
                  return ListView (
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    children:
                    displayPosts(snapshot),

                    //Text(snapshot.data)
                    // Text(snapshot.data.documents[0]['email']
                   );
                  }

                },

            ),
      ),
          /*
      ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 50),
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          Map post = posts[index];
          return Post(
            img: post['img'],
            name: post['name'],
            dp: post['dp'],
            time: post['time'],
          );
        },
      ),*/
          /*
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade400,
        child: Icon(
          Icons.add,),
        onPressed: (){},
      ),*/
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