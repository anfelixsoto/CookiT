import 'package:cookit_demo/service/Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cookit_demo/model/Post.dart';
import 'package:cookit_demo/model/SampleData.dart';

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
  @override
  void initState(){
    super.initState();
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
          new FlatButton(onPressed: signOut,
              child: new Text('Logout',
              style: new TextStyle(
                fontSize: 17.0,
                color: Colors.white,
              ))),
        ],
      ),
      body: ListView.builder(
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
      ),
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