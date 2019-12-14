import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/RecipeDetails.dart';
import 'package:cookit_demo/ViewUser.dart';
import 'package:cookit_demo/service/AdminOperations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/PostModel.dart';
import 'model/Recipe.dart';
import 'model/User.dart';

void main(){
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AdminPage(),
  ));
}

class AdminPage extends StatefulWidget{
  AdminPage({Key key}): super(key:key);

  @override
  _AdminPage createState() => new _AdminPage();
}

class _AdminPage extends State<AdminPage>{
  FirebaseUser currentUser;
  String username;
  DocumentReference userRef;
  String currEmail;
  String currId;
  String role;
  bool isAdmin = false;
  String profilePic;
  int _currentIndex = 0;
  String collection = 'users';

  void initState(){
    super.initState();
    loadCurrentUser();
    getUserRef();
  }

  void loadCurrentUser(){
    FirebaseAuth.instance.currentUser().then((FirebaseUser user){
      setState(() {
        this.currentUser = user;
      });
    });
  }

  void _onItemTapped(int index){
    setState(() {
      _currentIndex = index;
    });

    if(index == 0){
      collection = 'users';
    }

    if(index == 1){
      collection = 'posts';
    }

    if(index == 2){
      collection = 'recipes';
    }
    print(collection);
  }

  Future<void> getUserRef() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    setState((){
      userRef = _firestore.collection('users').document(user.uid);
      currId = user.uid;
      userRef.get().then((data) {
        if (data.exists) {
          currEmail = data.data['email'].toString();
          profilePic = data.data['profileImage'].toString();
          username = data.data['user_name'].toString();
          role = data.data['role'].toString();
          username = data.data['user_name'].toString();
          print(profilePic);
          if(role == 'admin'){
            isAdmin = true;
          }
        }
      });
    });
  }

  List<Widget> displayUsers(AsyncSnapshot snapshot){
    return snapshot.data.documents.map<Widget>((doc){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
        child: Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: doc['profileImage'] == " " || doc['profileImage'] == null ? NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbEs2FYUCNh9EJ1Hl_agLEB6oMYniTBhZqFBMoJN2yCC1Ix0Hi&s',):
                    NetworkImage(doc['profileImage'])),
                  title: Text(doc['user_name'] + " | (" + doc['role'] + ")" ),
                  subtitle: Text(doc['email']),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert, color:Colors.lightGreen),
                    onPressed: (){
                      showUserAlert(context, User.fromDoc(doc).user_id.toString(), doc['email'], doc['profileImage'], doc['role']);
                    },
                  ),
                  onTap: (){
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ViewUser(userId: currId, otherId: User.fromDoc(doc).user_id.toString()))
                    );
                  },
                )
              ],
            ),
          )
        ),

      );
    }).toList();
  }

  List<Widget> displayPosts(AsyncSnapshot snapshot){
    return snapshot.data.documents.map<Widget>((doc){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
        child: Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(doc['imageUrl']),backgroundColor: Colors.grey[300],),
                    title: Text(doc['title']),
                    subtitle: Text("User: " + doc['user_name'] ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: CircleAvatar(radius: 30.0, backgroundImage: NetworkImage(doc['profileImage']),),
                        ),
                        IconButton(
                          icon: Icon(Icons.more_vert, color:Colors.lightGreen),
                          onPressed: (){
                            showPostAlert(context, Post.fromDoc(doc).id, role, doc['imageURL']);
                          },
                        ),
                      ],
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => PostDetails(post: Post.fromDoc(doc), currId: currId, currEmail: currEmail, currRole: role, loginProfilePic: profilePic,),
                      ),);
                    },
                  )
                ],
              ),
            )
        ),

      );
    }).toList();
  }

  List<Widget> displayRecipes(AsyncSnapshot snapshot){
    return snapshot.data.documents.map<Widget>((doc){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
        child: Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(doc['imageURL'])),
                    title: Text(doc['name']),
                    subtitle: Text("Servings: " + doc['servings'].toString() + " | " + "Calories: " + doc['numCalories'].toString()),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RecipeDetails(recipe: Recipe.fromDoc(doc), recid: Recipe.fromDoc(doc)))
                      );
                    },
                  )
                ],
              ),
            )
        ),

      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page',
          style: TextStyle(color: Colors.lightGreen),
        ),
        actions: <Widget>[
          IconButton(
              icon: profilePic != null ? CircleAvatar( radius: 15.0,
                  backgroundImage: NetworkImage( profilePic ) ) :
              Icon( Icons.account_circle, color: Colors.grey[300], size: 40.0 ),
              onPressed: () {}
          ),
        ],
        backgroundColor: Colors.white,
        centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.lightGreen,
            ),
            onPressed: (){Navigator.pop(context);},
          ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection(collection).snapshots(),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                  children:
                    collection == 'users' ? displayUsers(snapshot):
                        collection == 'posts' ? displayPosts(snapshot):
                            displayRecipes(snapshot)
                );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar( //
        backgroundColor: Colors.grey[300],// footer
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Users'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            title: Text('Posts'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            title: Text('Recipes'),
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.lightGreen,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> showUserAlert(BuildContext context, String userId, String email, String url, String role) {
    return showDialog(context: context,builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
                child: Text(role == 'admin' ? 'Ungrant Admin Role' : 'Grant Admin Roloe'),
                onTap: () {
                  role == 'admin' ? AdminOperations.unGrantAdmin(userId):
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

  Future<void> showPostAlert(BuildContext context, String postId, String role, String url) {
    return showDialog(context: context,builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Text('Are you sure you want to delete this post? '),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text('Yes'),
                onTap: (){
                  removeImage(url);
                  AdminOperations.deletePost(postId);
                  Navigator.pop(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text('No'),
                onTap: () {
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

  Future<void> removeImage(String url) async {
    try {
      print (url);
      String path = url.replaceAll(new RegExp(r'%2F'), '---');
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
}