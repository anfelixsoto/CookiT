import 'package:avatar_glow/avatar_glow.dart';
import 'package:cookit_demo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookit_demo/delayed_animation.dart';

void main(){
  runApp(MaterialApp(
      title: 'RegisterActivity',
      home: RegisterActivity(),
  ));
}

class RegisterActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nFirstField = TextField(
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "First Name",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final nLastName = TextField(
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Last Name",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final nEmailField = TextField(
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final nPasswordField = TextField(
      obscureText: true,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final nPasswordRepeatField = TextField(
      obscureText: true,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Repeat Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final registerComplete = Material(
        child: MaterialButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginActivity())
              );
            },
            child: Text(
                ("Create Account").toUpperCase(),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                )
            )
        )
    );

    final cancelButton = Material(
        child: RaisedButton(

            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage())
              );
            },
            color: Colors.lightGreen,
            child: Text(
                ("Cancel").toUpperCase(),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
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
                    "Account Registeration",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                      color: Colors.white,),
                  ),
                ),
                SizedBox(height: 20.0,),
                nFirstField,
                SizedBox(height: 20.0,),
                nLastName,
                SizedBox(height: 20.0,),
                nEmailField,
                SizedBox(height: 20.0,),
                nPasswordField,
                SizedBox(height: 20.0,),
                nPasswordRepeatField,
                SizedBox(height: 10.0,),
                registerComplete,
                SizedBox(height: 5.0),
                cancelButton,
              ],
            )
        ),
      ),
    );
  }
}