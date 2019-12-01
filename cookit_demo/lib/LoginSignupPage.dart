import 'package:flutter/material.dart';
import 'package:cookit_demo/service/Authentication.dart';

import 'main.dart';

class LoginSignupPage extends StatefulWidget{
  LoginSignupPage({this.auth,this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignupPage>{
  final _formKey = new GlobalKey<FormState>();

  String _email, _password, _errorMessage;
  bool _isLoginForm, _isLoading;
  bool isEmpty = true;

  bool validateAndSave(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async{
    setState(() {
      _errorMessage = " ";
      _isLoading = true;
    });
    if(validateAndSave()){
      String userId = " ";
      try{
        if(_isLoginForm){
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        }else{
          userId = await widget.auth.signUp(_email, _password);
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if(userId.length > 0 && userId != null && _isLoginForm){
          widget.loginCallback();
        }
      }catch(e){
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState(){
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm(){
    _formKey.currentState.reset();
    _errorMessage = " ";
  }

  void toggleFormMode(){
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('CookiT',
        style: TextStyle(color: Colors.lightGreen,),),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(icon:Icon(Icons.arrow_back, color: Colors.lightGreen,),
        onPressed: () {
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => StartPage()));
        },),
      ),
      body: Stack(
        children: <Widget>[
          showForm(),
        ],
      )
    );
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/images/user_login.png'),
        ),
      ),
    );
  }

  Widget showWelcomText(){
    return Material(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0),
        child: Text(
          ("Please login or create an account to start cooking!").toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.lightGreen,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget showForm(){
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Form(
        key: _formKey,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            showLogo(),
            showWelcomText(),
            showEmailInput(),
            showPasswordInput(),
            showPrimaryButton(),
            showSecondaryButton(),
            showErrorMessage(),
            showCircularProgress(),
          ],
        ),
      )
    );
  }


  Widget showEmailInput(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Icon(
            Icons.person_outline,
            color: Colors.grey,
          ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          new Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
              onSaved: (value) => _email = value.trim(),
            ),
          )
        ],
      ),
    );
  }

  Widget showPasswordInput(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.lock_open,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          new Expanded(
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
              onSaved: (value) => _password = value.trim(),
            ),
          )
        ],
      ),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? ('Create an account').toUpperCase() : ('Have an account? Sign in').toUpperCase(),
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  Widget showPrimaryButton(){
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                splashColor: Colors.lightGreen,
                color: Colors.lightGreen,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: new Text(_isLoginForm ? ('Login').toUpperCase() : ('Create account').toUpperCase(),
                          style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                    ),
                    new Expanded(
                        child: Container()),
                    new Transform.translate(offset: Offset(15.0,0.0),
                      child: new Container(
                        padding: const EdgeInsets.all(5.0),
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(28.0)
                          ),
                          splashColor: Colors.white,
                          color: Colors.white,
                          child: Icon(Icons.arrow_forward,
                          color: Colors.lightGreen,
                          ),
                          onPressed: () => {},
                        )
                      ),
                    )
                  ],
                ),
                onPressed: validateAndSubmit,
              ))
        ],
      ),
    );
  }

  Widget showErrorMessage(){
    if(_errorMessage.length > 0 && _errorMessage != null){
      isEmpty =true;
      return new Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300),
      );
    }else{
      isEmpty = false;
      return new Container(
        height: 0.0,
      );
    }}

    Widget showCircularProgress(){
      if(_isLoading){
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return Container(
        height: 0.0,
        width: 0.0,
      );
    }
}