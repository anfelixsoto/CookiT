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
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.lightGreen,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
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
    }else if(index == 1){
      collection = 'posts';
    }else if(index == 2){
      collection = 'recipes';
    }
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
                  title: Text(doc['user_name']),
                  subtitle: Text(doc['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: doc['role'] == 'admin' ? Icon(Icons.star,color: Colors.yellow,) :
                        Icon(Icons.star_border, color: Colors.yellow,),
                        onPressed: (){
                          doc['role'] == 'admin' ? AdminOperations.unGrantAdmin(User.fromDoc(doc).user_id.toString()):
                          AdminOperations.grantAdmin(User.fromDoc(doc).user_id.toString());
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_forever, color:Colors.redAccent),
                        onPressed: (){
                          showUserAlert(context, User.fromDoc(doc).user_id.toString(), doc['email'], doc['profileImage'], doc['role']);
                        },
                      ),
                    ],
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
                          onPressed: (){},
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_forever, color:Colors.redAccent),
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
                    subtitle: Text("Servings: " + doc['servings'].toString() + " | Calories: " + doc['numCalories'].toString()),
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
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Admin Page', style: TextStyle(color: Colors.lightGreen), ),
          actions: <Widget>[
            IconButton(
              icon: profilePic != null ? CircleAvatar( radius: 15.0,
                  backgroundImage: NetworkImage( profilePic ) ) :
              Icon( Icons.account_circle, color: Colors.grey[300], size: 40.0 ),
              onPressed: (){},
            ),
          ],
          //backgroundColor: Colors.white,
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
                      collection == 'posts' ? displayPosts(snapshot):
                      collection == 'recipes' ? displayRecipes(snapshot):
                      displayUsers(snapshot)
                  );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightGreen,
          child: Icon(Icons.info_outline, color: Colors.white, size: 30.0,),
          onPressed: (){
            showAlert(collection);
          },
        ),
        bottomNavigationBar: BottomNavigationBar( //
          //backgroundColor: Colors.grey[100],// footer
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
      ),
    );
  }

  Future<void> showAlert(String collection) {
    return showDialog(context: context,builder: (BuildContext context) {
      if (collection == 'users'){
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
        ),
            home: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              title: Text('Admin Key - Users'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Wrap(
                      children: <Widget>[
                        Row(children: <Widget>[Icon(Icons.star, color: Colors.yellow,), Text('  That user an admin'),], ),
                        Padding(padding: EdgeInsets.all(8.0)),
                        Row(children: <Widget>[Icon(Icons.star_border, color: Colors.yellow,), Text('  That user is not an admin'),], ),
                        Padding(padding: EdgeInsets.all(8.0)),
                        Row(children: <Widget>[Text("Stars are clickable to turn on and \noff admin privillages"),],),
                        Padding(padding: EdgeInsets.all(8.0)),
                        Row(children: <Widget>[Text("Admin is able to view and delete \nusers\n"),],),
                        Padding(padding: EdgeInsets.all(8.0)),
                        GestureDetector(
                          child: Text( 'Close', style: TextStyle(color: Colors.redAccent)),onTap: (){Navigator.pop(context);},
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
        );
      } else if(collection == 'posts'){
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
            brightness: Brightness.light,
              primaryColor: Colors.white,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
            ),
            home: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              title: Text('Admin Key - Posts'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Wrap(
                      children: <Widget>[
                        Text("Here the admin is able to view and delete user's post\n"),
                        GestureDetector(
                          child: Text( 'Close', style: TextStyle(color: Colors.redAccent)),onTap: (){Navigator.pop(context);})
                      ],
                    ),
                  ],
                ),
              ),
            )
        );
      } else {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.white,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
            ),
          home:  AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            title: Text('Admin Key - Recipes'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Wrap(
                    children: <Widget>[
                      Text("Here the admin is able to view all the recipes that are stored in the database\nThese recipes orginally came from the api, but where stored in our database to lower api calls.\n"),
                      GestureDetector(child: Text( 'Close', style: TextStyle(color: Colors.redAccent)),onTap: (){Navigator.pop(context);}, )
                    ],
                  ),
                ],
              ),
            ),
          ));
      }
    });
  }

  Future<void> showUserAlert(BuildContext context, String userId, String email, String url, String role) {
    return showDialog(context: context,builder: (BuildContext context) {
      return new MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text('Are you want to delete ' + email + "?",),
          content: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                GestureDetector(
                  child: Text('Yes'),
                  onTap: (){
                    adminRemovePic(url);
                    AdminOperations.deleteUser(userId);
                    Navigator.pop(context);},
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text( 'Cancel',style: TextStyle(color: Colors.redAccent) ),
                  onTap: () { Navigator.pop(context);},
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> showPostAlert(BuildContext context, String postId, String role, String url) {
    return showDialog(context: context,builder: (BuildContext context) {
      return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: AlertDialog(
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
                child: Text('Cancel',style: TextStyle(color: Colors.redAccent)),
                onTap: () {Navigator.pop(context);},
              )
            ],
          ),
        ),
      ));
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