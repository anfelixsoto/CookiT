import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookit_demo/delayed_animation.dart';
import 'package:cookit_demo/RegisterActivity.dart';

void main(){
  runApp(MaterialApp(
    title: 'CookiT Login',
    home: LoginActivity(),
  ));
}

class LoginActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final emailField = TextField(
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final passwordField = TextField(
      obscureText: true,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );

    final loginButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blue,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: (){},
          child: Text("Login",
            textAlign: TextAlign.center,
          ),
        )
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("CookiT Login"),
        ),
        body: Center(
            child: Container(
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 155.0,
                          //logo goes here
                        ),
                        SizedBox(height: 45.0),
                        emailField,
                        SizedBox(height: 25.0,),
                        passwordField,
                        SizedBox(height: 35.0,),
                        loginButton,
                        SizedBox(height: 100.0,),
                      ],
                    )
                )
            )
        )
    );
  }
}