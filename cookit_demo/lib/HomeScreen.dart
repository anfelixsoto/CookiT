import 'package:flutter/material.dart';
import 'package:cookit_demo/model/Post.dart';
import 'package:cookit_demo/model/SampleData.dart';



void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}
class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.list,
            ),
            onPressed: (){},
          ),
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
          Icons.add,



        ),
        onPressed: (){},
      ),
    );
  }
}