import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/service/Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'model/Recipe.dart';

void main() => runApp(SavePage());

class SavePage extends StatefulWidget{
  SavePage({Key key, this.auth, this.userId}) : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  _SavedPage createState() => new _SavedPage();
}

class _SavedPage extends State<SavePage>{

  FirebaseUser currentUser;

  bool isLoading = false;
  DocumentReference userRef;
  String userId;
  List<int> savedRecipes;
  Recipe recipe;

  @override
  void initState(){
    super.initState();
    loadCurrentUser;
    getUserRef();
  }

  void loadCurrentUser(){
    FirebaseAuth.instance.currentUser().then((FirebaseUser user){
      setState(() {
        this.currentUser = user;
      });
    });
  }

  Future<void> getUserRef() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;

    FirebaseUser user = await _auth.currentUser();

    setState(() {
      userRef = _firestore.collection('users').document(user.uid);
      userId = user.uid;
      userRef.get().then((data){
        if(data.exists){
         savedRecipes = List.from(data.data['saved']);
        }
      });
    });
  }

  Future<List<String>> getSavedRecipes() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(userId)
        .get();
    if(querySnapshot.exists &&
      querySnapshot.data.containsKey('saved') &&
    querySnapshot.data['saved'] is List){
      return List<String>.from(querySnapshot.data['saved']);
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('BookMarks',
        style: TextStyle(color: Colors.lightGreen,),),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.lightGreen,
          ),
          onPressed: (){Navigator.pop(context);},
        ),
      ),
      body: FutureBuilder<List<String>>(
          future: getSavedRecipes(),
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator());
            else if(snapshot.data.length == 0){
              return Container(
                  alignment: FractionalOffset.center,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text('No Bookmarked Items!')
              );
            } else{
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) =>
                    ListTile(
                      leading: FlutterLogo(size: 56.0),
                      title: Text(snapshot.data[i]),
                      subtitle: Text("Recipe description\n More information"),
                      trailing: IconButton(
                        icon: Icon(Icons.more_vert,
                        color: Colors.lightGreen,
                        ),
                        onPressed: (){},
                      ),
                      isThreeLine: true,
                      onTap: () {
                      },
                    ),
              );
            }
          }
      ),
    );
  }

}