import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'model/Recipe.dart';

void main() => runApp(
  new MaterialApp(
    debugShowCheckedModeBanner: false,
    builder: (context, child) => new SafeArea(child: child),
    home: new CreateRecipe(),
  ),
);

class CreateRecipe extends StatefulWidget {

  var state = new _CreateRecipe();
  final _countIngredients = 0;
  final _countInstructions = 0;
  bool flag;
  List<TextField> fields;
  var listOfIngredientsFields = <Widget>[];
  var listOfInstructionsFields = <Widget>[];

  @override
  _CreateRecipe createState() {
    flag=false;
    state=new  _CreateRecipe();
    return state;
  }
  CreateRecipe();

}

class _CreateRecipe extends State<CreateRecipe> {
  var controllerIngredientsList = new List<TextEditingController>();
  var listOfIngredientsFields = <Widget>[];
  int _countIngredients = 0;

  var controllerInstructionsList = new List<TextEditingController>();
  var listOfInstructionsFields = <Widget>[];
  int _countInstructions = 0;

  String _recipeName;
  int _prepTime = 0, _servings = 0;
  double _calories = 0.0;

  List<String> _ingredients = [];
  List<String> _instructions = [];

  bool flag=false;
  FirebaseUser currentUser;
  File _image;
  String profilePic;
  DocumentReference userRef;
  String _email;

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
    getUserRef();
  }

  void loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {this.currentUser = user;});
    });
  }

  Future<void> getUserRef() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    setState((){
      userRef = _firestore.collection('users').document(user.uid);
      userRef.get().then((data) {
        if (data.exists) {
          profilePic = data.data['profileImage'].toString();
        }
      });
      print(profilePic);
    });
  }

  openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState((){
      _image = picture;
    });
    Navigator.of(context).pop(); // pass the context
  }

  openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState((){
      _image = picture;
    });
    Navigator.of(context).pop(); // pass the context
  }

  Future<void> showOptions(BuildContext context) {
    return showDialog(context: context,builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select From: '),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text('Gallery'),
                onTap: (){ openGallery(context);}
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text('Camera'),
                onTap: () { openCamera(context);},
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text('Cancel',
                    style: TextStyle(color: Colors.redAccent)
                ),
                onTap: () { Navigator.pop(context);},
              )
            ],
          ),
        ),
      );
    });
  }

  Future<String> uploadPic(BuildContext context) async{
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("UserRecipes/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await firebaseStorageRef.getDownloadURL();
    return downloadUrl;
  }

  submitRecipe(BuildContext context) async{
    String imageURL = await uploadPic(context);
    Recipe newRecipe = Recipe(
      name: _recipeName,
      description: getUserId(),
      imageURL: imageURL,
      numCalories: _calories,
      prepTime: _prepTime,
      servings: _servings,
      ingredients: _ingredients,
      instructions: _instructions,
    );

    createRecipe(newRecipe);
  }

  void createRecipe(Recipe recipe){
    String id;
    Firestore.instance.collection('recipes').add({
      'description': recipe.description,
      'imageURL': recipe.imageURL,
      'ingredients': recipe.ingredients,
      'instructions': recipe.instructions,
      'name': recipe.name,
      'numCalories': recipe.numCalories,
      'prepTime': recipe.prepTime,
      'servings': recipe.servings,
    }).then((doc){
      id = doc.documentID;
    });

    Firestore.instance.collection('recipes').document(id).updateData({
      'id' : id,
    });
  }

  String getUserId() {
    if (currentUser != null) {
      return currentUser.uid;
    } else {
      return "no current user";
    }
  }

  void _addIngredients() {
    controllerIngredientsList.add(new TextEditingController());
    listOfIngredientsFields = List.from(listOfIngredientsFields)
      ..add(TextFormField(
        controller: controllerIngredientsList[_countIngredients],
        obscureText: false,
        decoration: InputDecoration(
            hintText: 'Enter an ingredient',
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightGreen)
            )
        ),
      ),);
    setState(() => ++_countIngredients);
    print(_countIngredients);
  }

  void _addInstructions(){
    controllerInstructionsList.add(new TextEditingController());
    listOfInstructionsFields = List.from(listOfInstructionsFields)
      ..add(TextFormField(
        controller: controllerInstructionsList[_countInstructions],
        obscureText: false,
        expands: true,
        decoration: InputDecoration(
            hintText: 'Enter an instructions',
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightGreen)
            )
        ),
      ),);
    setState(() => ++ _countInstructions);
    print("_countInstructions: " + _countInstructions.toString());
  }

  List<String> getIngredients(){
    List<String> ingredients = new List<String>();
    for(int i=0;i< controllerIngredientsList.length;i++){
      String tinput= controllerIngredientsList[i].text.toString().trim();
      if(tinput.isNotEmpty&&RegExp(r"^[a-zA-Z ]+$").hasMatch(tinput)){
        ingredients.add(controllerIngredientsList[i].text.toString().trim());
      }
    }
    if(ingredients.isEmpty){
      setState((){
        flag = true;
      });
    }
    else{
      setState((){
        flag = false;
      });
    }
    return ingredients;
  }

  List<String> getInstructions(){
    List<String> instructions = new List<String>();
    for(int i=0;i< controllerInstructionsList.length;i++){
      String tinput= controllerInstructionsList[i].text.toString().trim();
      if(tinput.isNotEmpty&&RegExp(r"^[a-zA-Z ]+$").hasMatch(tinput)){
        instructions.add(controllerInstructionsList[i].text.toString().trim());
      }
    }
    if(instructions.isEmpty){
      setState((){
        flag = true;
      });
    }
    else{
      setState((){
        flag = false;
      });
    }
    return instructions;
  }

  @override
  Widget build(BuildContext context){
    if(controllerIngredientsList.isEmpty){
      _addIngredients();
    }
    if(controllerInstructionsList.isEmpty){
      _addInstructions();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Create Recipe'
            ,style: TextStyle(color: Colors.lightGreen),
          ),
          leading: IconButton(icon:Icon(Icons.arrow_back),color:Colors.lightGreen,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return ListView(
                padding:EdgeInsets.all(15.0),
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: viewportConstraints.maxHeight*5,
                      minHeight: viewportConstraints.maxHeight,
                      maxWidth: viewportConstraints.maxWidth,
                    ),
                    child:Padding(
                      padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
                      child: ListView(
                        children: <Widget>[
                          handleNullImage(context),
                          showRecipeNameInput(),
                          showNutrition(),
                          showIngredients(),
                          showInstructions(),
                          showPrimaryButton(context),
                        ],
                      ),
                    ),
                  )
                ],
            );
          },
        ),
      ),
    );
  }

  Widget handleNullImage(BuildContext context) {
    if (_image == null) {
      return Container (
        padding: EdgeInsets.only(top: 5.0, bottom: 30.0),
        margin: const EdgeInsets.only(bottom: 10.0),
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: CircleAvatar(
            child: Center (
              child: MaterialButton(
                minWidth: 10.0,
                height: 50.0,
                onPressed: () {
                  showOptions(context);
                },
                child: new Text('Pick Image'),
              ),
            )
        ),
      );
    } else {
      return Material(
        elevation: 4.0,
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: Image.file(_image, fit: BoxFit.fitHeight, width: (MediaQuery.of(context).size.width*(2/3)), height: 200.0,),
      );
      //return Container(
      //padding: EdgeInsets.only(top: 5.0, left: 20.0, bottom: 30.0),

      //);
    }
  }

  Widget showRecipeNameInput(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.restaurant,
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
                  hintText: 'Enter your recipe name',
                  hintStyle: TextStyle(color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen)
                  )
              ),
              validator: (value) => value.isEmpty ? 'Recipe name can\'t be empty' : null,
              onChanged: (value){
                if(value.length > 0){
                  _recipeName = value;
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget showPrepTimeInput(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.timer,
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
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Prep time',
                  hintStyle: TextStyle(color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen)
                  )
              ),
              validator: (value) => value.isEmpty ? 'Prep time can\'t be empty' : null,
              onChanged: (value){
                _prepTime = int.parse(value);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget showCaloriesInput(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.info_outline,
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
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Calories',
                  hintStyle: TextStyle(color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen)
                  )
              ),
              validator: (value) => value.isEmpty ? 'Calories can\'t be empty' : null,
              onChanged: (value){
                _calories = double.parse(value);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget showServingInput(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.restaurant_menu,
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
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Servings',
                  hintStyle: TextStyle(color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreen)
                  )
              ),
              validator: (value) => value.isEmpty ? 'Servings can\'t be empty' : null,
              onChanged: (value){
                _servings = int.parse(value);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget showNutrition(){
    return Card(
      child: ExpansionTile(
        title: Text("Nutrition",
        style: TextStyle(color: Colors.lightGreen),
        ),
        children: <Widget>[
          showPrepTimeInput(),
          showCaloriesInput(),
          showServingInput(),
        ],
      )
    );
  }

  Widget showIngredients(){
    return Card(
      child: ExpansionTile(
        title: Text("Ingredients", style: TextStyle(color: Colors.lightGreen)),
        trailing: IconButton(icon: Icon(Icons.add), onPressed: _addIngredients,color:Colors.lightGreen),
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            height:250.0,
            child: ListView(children: listOfIngredientsFields),
          ),
          SizedBox(height: 5.0,),
          Visibility(
              visible:flag,
              child: Text(
                "Error: Enter at least one ingredient.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.red,),
              )),
        ],
      ),
    );
  }

  Widget showInstructions(){
    return Card(
      child: ExpansionTile(
        title: Text("Instructions", style: TextStyle(color: Colors.lightGreen)),
        trailing: IconButton(icon: Icon(Icons.add), onPressed: _addInstructions,color:Colors.lightGreen),
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            height:250.0,
            child: ListView(children: listOfInstructionsFields),
          ),
          SizedBox(height: 5.0,),
          Visibility(
              visible:flag,
              child: Text(
                "Error: Enter at least one instructions.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.red,),
              )),
        ],
      ),
    );
  }

  Widget showPrimaryButton(BuildContext context){
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
                      child: new Text(('Create Recipe').toUpperCase(),
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
                            onPressed: () {
                              String _userId = getUserId();
                              _ingredients = getIngredients( );
                              _instructions = getInstructions( );
                              print( _ingredients );
                              print( _instructions );
                              print( _recipeName );
                              print( _prepTime );
                              print( _calories );
                              print( _servings );
                              print ( _userId );
                              submitRecipe(context);
                            }
                          )
                      ),
                    )
                  ],
                ),
                onPressed: (){
                  String _userId = getUserId();
                  _ingredients = getIngredients( );
                  _instructions = getInstructions( );
                  print( _ingredients );
                  print( _instructions );
                  print( _recipeName );
                  print( _prepTime );
                  print( _calories );
                  print ( _servings );
                  print(_userId);
                  submitRecipe(context);
                },
              ))
        ],
      ),
    );
  }
}