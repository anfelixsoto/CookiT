import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as prefix1;
import 'package:cookit_demo/model/PostModel.dart';
import 'package:cookit_demo/service/Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cookit_demo/model/User.dart';

import 'package:cookit_demo/UserScreen.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}
class Home extends StatefulWidget {
  Home({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final String userId;
  final VoidCallback logoutCallback;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  List<Post> postsFeed = [];

  @override
  void initState(){
    super.initState();


      print(getPosts());



  }
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




  List<Widget> displayPosts(AsyncSnapshot snapshot) {
    return snapshot.data.documents.map<Widget>((document){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Card(
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
                    "Recipe Name",
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
                  //alignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Save'),
                      textColor: Colors.lightBlueAccent,
                      onPressed: () { print('pressed'); },
                    ),

                  ],
                ),


      ]
      ),
      ),
      );
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
        centerTitle: true,
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
                MaterialPageRoute(builder: (context) => UserProfile(userId: widget.userId,)),
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
                  return CircularProgressIndicator();
                default:

                  return ListView(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    children:
                    displayPosts(snapshot),

                    //Text(snapshot.data)
                    // Text(snapshot.data.documents[0]['email'])



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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade400,
        child: Icon(
          Icons.add,),
        onPressed: (){},
      ),
    );
  }

  Widget getUserId(){
    return Scaffold(
      body: FutureBuilder(
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