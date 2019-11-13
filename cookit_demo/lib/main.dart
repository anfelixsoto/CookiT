import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookit_demo/delayed_animation.dart';
import 'package:cookit_demo/RegisterActivity.dart';
import 'package:cookit_demo/LoginActivity.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Home Page',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: HomePage(),
        title: new Text('CookiT',
          style: new TextStyle(
              color: Colors.white,
              backgroundColor: Colors.lightGreen,
              fontWeight: FontWeight.bold,
              fontSize: 60.0
          ),),
        backgroundColor: Colors.lightGreen,
        styleTextUnderTheLoader: new TextStyle(),
        onClick: ()=>print("Clicked screen"),
        loaderColor: Colors.white
    );
  }
}


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerButton = Material(
        borderRadius: BorderRadius.circular(100.0),
        color: Colors.white,
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
        borderRadius: BorderRadius.circular(100.0),
        color: Colors.lightGreen,
        child: MaterialButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginActivity())
              );
            },
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
            SizedBox(height: 200.0, width: 270,),
            registerButton,
            SizedBox(height: 10.0),
            loginButton,
          ],
        )
       ),
     ),
    );
  }
}