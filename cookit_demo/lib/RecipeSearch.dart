import 'package:avatar_glow/avatar_glow.dart';
import 'package:cookit_demo/recipeResults.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cookit_demo/delayed_animation.dart';

void main() => runApp(
      new MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) => new SafeArea(child: child),
        home: new RecipeSearch(),
      ),
    );

class RecipeSearch extends StatefulWidget {
  var state = new _RecipeSearchState();
  final _count=0;
  bool flag;
  List<TextField> fields;
  var listOfFields = <Widget>[];

  @override
  _RecipeSearchState createState() {
    flag=false;
    state=new  _RecipeSearchState();
    return state;
  }

  RecipeSearch();


}



class _RecipeSearchState extends State<RecipeSearch> {

  var controllerList=new List<TextEditingController>();
  var listOfFields = <Widget>[];
  int _count=0;
  bool flag=false;

  void _add() {
    controllerList.add(new TextEditingController());
    listOfFields = List.from(listOfFields)
      ..add(TextFormField(
        controller: controllerList[_count],
              obscureText: false,
              decoration: InputDecoration(
                hintText: 'Enter an ingredient',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),);
      setState(() => ++_count);
      print(_count);
  }

  List<String> getIngredients(){
    List<String> ingredients=new List<String>();
    for(int i=0;i<controllerList.length;i++){
      String tinput=controllerList[i].text.toString().trim();
      if(tinput.isNotEmpty&&RegExp(r"^[a-zA-Z ]+$").hasMatch(tinput)){
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

    final searchButton=ClipRRect(
      borderRadius: new BorderRadius.circular(15.0),
      child: new MaterialButton(
        minWidth: 120.0,
        height: 40.0,
        color: Colors.lightGreen,
        textColor: Colors.white,
        onPressed: () {
          List<String> ingredients=getIngredients();
            if(ingredients.isNotEmpty){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeResults(ingredients:ingredients)),
              );
            }
        },
        child: new Text("Search for recipes",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
           // fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Search for Recipes'
          ,style: TextStyle(color: Colors.lightGreen),
          ),
        backgroundColor: Colors.white,
          leading: IconButton(icon:Icon(Icons.arrow_back),color:Colors.lightGreen,
            onPressed: () => Navigator.pop(context),
          ),
          actions:<Widget>[IconButton(icon: Icon(Icons.add), onPressed: _add,color:Colors.lightGreen)],
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
                padding: const EdgeInsets.fromLTRB(36.0,10.0,36.0,10.0),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 10.0,),
                     Text(
                        "Enter ingredients",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.lightGreen,),
                      ),
                    SizedBox(height: 20.0,),
                    Container(
                      height:250.0,
                      child:
                      ListView(children: listOfFields),
                    ),
                    SizedBox(height: 5.0,),
                    searchButton,
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