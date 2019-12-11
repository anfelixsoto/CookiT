import 'package:avatar_glow/avatar_glow.dart';
import 'package:cookit_demo/recipeResults.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookit_demo/delayed_animation.dart';

void main(){
  runApp(MaterialApp(
    title: 'CookiT Login',
    home: RecipeSearch(),
  ));
}

class RecipeSearch extends StatefulWidget {
  final state = _RecipeSearchState();
  final _count=0;
  bool flag;
  List<TextField> fields;
  var listOfFields = <Widget>[];

  @override
  _RecipeSearchState createState() {
    flag=false;
  return _RecipeSearchState();
  }

  RecipeSearch();


}



class _RecipeSearchState extends State<RecipeSearch> {

  static var controllerList=new List<TextEditingController>();
  static var listOfFields = <Widget>[];
  int _count=0;
  static bool flag=false;

  void _add() {
    controllerList.add(new TextEditingController());
    listOfFields = List.from(listOfFields)
      ..add(TextField(
        decoration: InputDecoration(hintText: "Enter an ingredient...",border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(24.0))),
        controller:controllerList[_count],
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ));
      setState(() => ++_count);
  }

  List<String> getIngredients(){
    List<String> ingredients=new List<String>();
    for(int i=0;i<controllerList.length;i++){
      String tinput=controllerList[i].text.toString().trim();
      if(tinput.isNotEmpty&&RegExp(r"^[a-zA-Z]+$").hasMatch(tinput)){
        ingredients.add(controllerList[i].text.toString().trim());
      }
    }
    if(ingredients.isEmpty){
      setState((){
        flag=true;
      });
    }
    else{
      setState((){
        flag=false;
      });
    }
    return ingredients;
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    if(controllerList.isEmpty){
      _add();
    }
    final ingredientField = TextField(
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter an ingredient...",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );


    final loginButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.lightGreen,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

          onPressed: (){
            List<String> ingredients=getIngredients();
            if(ingredients.isNotEmpty){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeResults(ingredients:ingredients)),
              );
            }
          },
          child: Text("Search for recipes",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
    );

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
          actions:<Widget>[IconButton(icon: Icon(Icons.add), onPressed: _add)],
        ),
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              padding:EdgeInsets.all(15.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: viewportConstraints.maxHeight*5,
                  minHeight: viewportConstraints.maxHeight,
                  maxWidth: viewportConstraints.maxWidth,
                ),
                child:Padding(
                padding: const EdgeInsets.all(36.0),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20.0,),
                     Text(
                        "Enter ingredients",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35.0,
                          color: Colors.lightGreen,),
                      ),
                    SizedBox(height: 5.0,),
                    Container(
                      height:250.0,
                      child:
                      ListView(children: listOfFields),
                    ),
                    SizedBox(height: 5.0,),
                    loginButton,
                    SizedBox(height: 5.0,),
                    Visibility(
                      visible:flag,
                      child:Text(
                      "Error: enter at least one ingredient.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.red,),
                    )),
                  ],
                ),
              ),
            )
        );
          },
      ),
      ),
    );
  }
}