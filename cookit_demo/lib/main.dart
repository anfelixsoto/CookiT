import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookit_demo/delayed_animation.dart';
import 'package:cookit_demo/RegisterActivity.dart';
import 'package:cookit_demo/LoginActivity.dart';

void main() {
  runApp(MaterialApp(
    title: 'Home Page',
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerButton = Material(
        child: MaterialButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterActivity())
              );
            },
            child: Text(
                "Register to CookiT",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8185E2),
                )
            )
        )
    );

    final loginButton = Material(
        child: RaisedButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginActivity())
              );
            },
            color: Colors.lightGreen,
            child: Text(
              ("I Already have An Account").toUpperCase(),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )
            )
        )
    );

    return MaterialApp(
     debugShowCheckedModeBanner: false,
     home: Scaffold(
       backgroundColor: Colors.lightGreen,
       body: Center(
        child: Column(
          children: <Widget>[
            AvatarGlow(
              endRadius: 90,
              duration: Duration(seconds: 2),
              glowColor: Colors.white24,
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
            DelayedAnimation(
              child: Text(
                "Hi There",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0,
                  color: Colors.white,),
              ),
            ),
            DelayedAnimation(
              child: Text(
                "Welcome to CookiT",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0,
                  color: Colors.white,),
              ),
            ),
            SizedBox(height: 30.0,),
            DelayedAnimation(
              child: Text("Your New Personal",
                      style: TextStyle(fontSize: 20.0, color: Colors.white,),),
            ),
            DelayedAnimation(
              child: Text("Cook Book",
                style: TextStyle(fontSize: 20.0, color: Colors.white,),),
            ),
            SizedBox(height: 45.0,),
            registerButton,
            SizedBox(height: 25.0),
            loginButton,
          ],
        )
       ),
     ),
    );
  }
}