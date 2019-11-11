import 'package:avatar_glow/avatar_glow.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookit_demo/delayed_animation.dart';

void main(){
  runApp(MaterialApp(
    title: 'CookiT Recipe Results',
    home: RecipeDetails(),
  ));
}

class RecipeDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context){

    final imageView=Image.network(
  'https://www.jessicagavin.com/wp-content/uploads/2019/01/baked-salmon-8-1200.jpg',);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          automaticallyImplyLeading: true,
          title: Text('CookiT'),
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        backgroundColor: Colors.white,
        body: Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: ListView(
                  children: <Widget>[
                    AvatarGlow(
                      endRadius: 90,
                      duration: Duration(seconds: 2),
                      glowColor: Colors.lightGreen,
                      repeat: true,
                      repeatPauseDuration: Duration(seconds: 2),
                      startDelay: Duration(seconds: 1),
                      child: Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            child: FlutterLogo(
                              size: 50.0,
                            ),
                            radius: 50.0,
                          )),
                    ),
                    SizedBox(height: 20.0,),
                    imageView,
                    SizedBox(height: 20.0,),
                    //passwordField,
                    SizedBox(height: 20.0,),
                    //loginButton,
                  ],
                ),
              ),
            )
        ),
      ),
    );

  }
}