import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/CreateRecipePage.dart';
import 'package:cookit_demo/RecipeDetails.dart';
import 'package:cookit_demo/SavePage.dart';
import 'package:cookit_demo/Favorite.dart';
import 'package:cookit_demo/RecipeSearch.dart';
import 'package:cookit_demo/service/Authentication.dart';
import 'package:cookit_demo/EditProfile.dart';
import 'package:cookit_demo/service/UserOperations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'AdminPage.dart';
import 'model/PostModel.dart';
import 'model/Recipe.dart';

void main(){
  runApp(new MaterialApp(
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
    debugShowCheckedModeBanner: false,
    home: UserProfile(),
  ));
}


class UserProfile extends StatefulWidget {
  UserProfile({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);
  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;



  @override
  _UserProfile createState() => new _UserProfile();
}


class _UserProfile extends State<UserProfile> {

  FirebaseUser currentUser;
  String username;
  int postCount = 0;
  int recipeCount = 0;
  DocumentReference userRef;
  String currEmail;
  String currId;
  String role;
  bool isAdmin = false;
  String profilePic;
  int _currentIndex = 0;
  String collection = "Posts";

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
    getUserRef();
    //showEmail();
    //showUsername();
  }

  void _onItemTapped(int index){
    setState(() {
      _currentIndex = index;
    });

    if(index == 0){
      collection = 'Posts';
    }else{
      collection = 'Recipes';
    }
    print(collection);
  }

  void loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentUser = user;
        //userRef.get().then()

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

  String showUserId() {
    if (currentUser != null) {
      return currentUser.uid;
    } else {
      return "no current user";
    }
  }
  String getRole() {
    return role;
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
          log(username);
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


  showAvatar(String pic) {
    return GestureDetector(
        child: ClipOval(
          child: profilePic == null
              ? new CircleAvatar(
            child: Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbEs2FYUCNh9EJ1Hl_agLEB6oMYniTBhZqFBMoJN2yCC1Ix0Hi&s',
            ),
          )
              : new CircleAvatar(
            child: Image.network(
                profilePic
            ),
          ),
        ),
        onTap:(){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => editProfile()),
          );
        }
    );

  }

  Widget _buildAvatar() {
    return new GestureDetector(
        child: Container(
          width: (MediaQuery.of(context).size.width/3),
          height: (MediaQuery.of(context).size.width/3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white30),
          ),
          margin: const EdgeInsets.only(top: 32.0, left: 16.0),
          padding: const EdgeInsets.all(3.0),
          child:  ClipOval(
            child: (profilePic == null || profilePic.toString() == "")
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => editProfile()),
          );
        }
    );
  }



  Widget findRecipes(String text, {
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.white,
  }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(15.0),
      child: new MaterialButton(
        minWidth: (MediaQuery.of(context).size.width/3),
        height: 40.0,

        color: Colors.lightGreen,
        textColor: textColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => new RecipeSearch()),
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
      borderRadius: new BorderRadius.circular(15.0),
      child: new MaterialButton(
        minWidth: (MediaQuery.of(context).size.width/3),
        height: 40.0,
        color: Colors.lightGreen,
        textColor: textColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Favorites()),
          );
        },
        child: new Text(text),
      ),
    );
  }


  Future<List<Post>> getPosts() async {
    List<Post> posts = [];
    var snap = await Firestore.instance
        .collection('posts')
        .where('userId', isEqualTo: showUserId())
        .getDocuments();
    for (var doc in snap.documents) {
      posts.add(Post.fromDoc(doc));
    }
    setState(() {
      postCount = snap.documents.length;
    });
    return posts.toList();
  }

  Future<List<Recipe>> getRecipes() async {
    List<Recipe> recipes = [];
    var snap = await Firestore.instance
        .collection('recipes')
        .where('description', isEqualTo: showUserId())
        .getDocuments();
    for (var doc in snap.documents) {
      recipes.add(Recipe.fromDoc(doc));
    }
    setState(() {
      recipeCount = snap.documents.length;
    });
    return recipes.toList();
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
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(username.toString(),
            style: TextStyle(color: Colors.lightGreen),),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.bookmark_border,
                color: Colors.lightGreen,
                size: 40.0,),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavePage()),
                );
              },
            )
          ],
          leading: new IconButton(icon: new Icon(Icons.arrow_back, color: Colors.lightGreen,),
            onPressed: () {
              Navigator.pop(context,true);
            },),
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
              //buildImageViewButtonBar(),
              Divider(height: 0.0),
              collection == 'Posts' ? displayPosts() : displayRecipes(),
              //Divider(height: 10.0),
            ]
        ),
        bottomNavigationBar: BottomNavigationBar( //
          //backgroundColor: Colors.grey[100],// footer
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.image),
              title: Text('Post'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              title: Text('Recipes Created'),
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Colors.lightGreen,
          onTap: _onItemTapped,
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            backgroundColor: Colors.lightGreen,
            child:
              collection == 'Posts' ? Icon(Icons.portrait, color: Colors.white):
                            Icon(Icons.add, color: Colors.white),
            onPressed: (){
              collection == 'Posts' ? Navigator.push(context ,MaterialPageRoute(builder: (context) => new AdminPage())):
                  Navigator.push(context, MaterialPageRoute(builder: (context) => new CreateRecipe()));
            },
          ),
          visible: isAdmin || collection == "Recipes",
        ),
      ),
    );
  }

  Widget displayPosts(){
    return Container (
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
                child: Text( collection == 'Posts' ? 'No Posts' : 'No Recipes')
            );
          }
          else {
            // build the grid
            return GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                mainAxisSpacing: 1.5,
                crossAxisSpacing: 1.5,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: snapshot.data.map((Post post) {
                  return GridTile(
                    child: showPosts(context, post, post.imageUrl, currId, currEmail, profilePic),
                  );
                }).toList());
          }
        },
      ),
    );
  }

  Widget displayRecipes(){
    return Container (
      child: FutureBuilder<List<Recipe>>(
        future: getRecipes(),
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
                child: Text( collection == 'Posts' ? 'No Posts' : 'No Recipes')
            );
          }
          else {
            // build the grid
            return GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                mainAxisSpacing: 1.5,
                crossAxisSpacing: 1.5,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: snapshot.data.map((Recipe recipe) {
                  return GridTile(
                    child: showRecipes(context, recipe, recipe.imageURL, currId, currEmail, profilePic),
                  );
                }).toList());
          }
        },
      ),
    );
  }
}

Widget showPosts(BuildContext context, Post post, url, String currId, String currEmail, String profileImage){
  return InkWell(
    //  onTap: () => print("Post " + post.id +" pressed"),
    onTap:() {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => PostDetails(post: post, currId: currId, currEmail: currEmail, profileImage: profileImage,),
      ),
      );
    },
    child: Container (
      child: new Image.network(
        url,
        fit: BoxFit.cover
      ),
    ),
  );
}

Widget showRecipes(BuildContext context, Recipe recipe, url, String currId, String currEmail, String profileImage){
  return InkWell(
    onTap:() {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => RecipeDetails(recipe: recipe, recid: recipe,)
      ));
    },
    child: Container (
      child: new Image.network(
        url,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget showDelete(String postId, String role, String url) {
  return  Visibility(
    child: IconButton(
        icon: Icon(
          Icons.remove_circle,
          color: Colors.redAccent,
          size: 30.0,
        ),
        onPressed: () {
          removeImage(url);
          UserOperations.deletePost(postId);
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



class PostDetails extends StatelessWidget {
  final Post post;
  String currId;
  String currEmail;
  String profileImage;

  // In the constructor, require a Post.
  PostDetails({Key key, @required this.post, @required this.currId, @required this.currEmail, @required this.profileImage}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // Use the Post to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title,
        style: TextStyle(color: Colors.lightGreen),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.lightGreen,),
          onPressed: (){Navigator.pop(context);},
        ),
        //backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              icon: profileImage != null ? CircleAvatar(radius:15.0, backgroundImage: NetworkImage(profileImage)):
              Icon(Icons.account_circle, color: Colors.grey[300], size: 40.0),
              onPressed: () {}
          ),
          ]
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          height: 500.0,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            //color: Colors.grey[200],
            child: Padding(
              padding:EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: post.profileImage == null ? NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbEs2FYUCNh9EJ1Hl_agLEB6oMYniTBhZqFBMoJN2yCC1Ix0Hi&s',
                        ): NetworkImage(
                          post.profileImage,
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
                        onTap: () {},
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
                        child:Image.network(
                          post.imageUrl,
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                          post.description,
                          style: TextStyle(fontWeight: FontWeight.w500)
                      ),
                      trailing: post.email == currEmail ?
                      showUserOptions(context, post, currId, currEmail): Container(),
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


Widget showUserOptions(BuildContext context, Post post, String userId, String email) {
  return  Visibility(
    child: IconButton(
        icon: Icon(
          Icons.more_vert,
          color: Colors.redAccent,
          size: 30.0,
        ),
        onPressed: () {
          showAlert(context, userId, email, post.id, post.email, post.imageUrl);
        }
    ),
  );
}

Future<void> showAlert(BuildContext context, String userId, email, String postId, String postEmail, url) {
  return showDialog(context: context,builder: (BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure you want to delete this post? '),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            GestureDetector(
              child: Text('Yes'),
              onTap: (){

                removeImage(url);
                UserOperations.deletePost(postId);
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