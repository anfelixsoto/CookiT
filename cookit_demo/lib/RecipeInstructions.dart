import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit_demo/RecipeInstructions.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:cookit_demo/model/recipeId.dart';
import 'package:cookit_demo/ImageUpload.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'CookiT Recipe Results',
    home: RecipeInstructions(recipe:Recipe.fetchRecipe(508108)),
  ));
}

class RecipeInstructions extends StatelessWidget {
  final Recipe recipe;
  final Recipe rId;
  final RecipeId dbId;
  RecipeInstructions({Key key,@required this.recipe, this.rId, this.dbId}):super(key:key);



  @override
  Widget build(BuildContext context){
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
          centerTitle: true,
          title: Text(
            'Instructions',
            style: TextStyle(
              color: Colors.lightGreen,

            ),
          ),
          leading: IconButton(
            icon:Icon(Icons.arrow_back),
            color: Colors.lightGreen,
            onPressed: () => Navigator.pop(context, false),
          ),

        ),
        body: Container(
          child: /*FutureBuilder<Recipe>(
              future: recipe,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return*/ LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: viewportConstraints.maxHeight*5,
                          minHeight: viewportConstraints.maxHeight,
                          maxWidth: viewportConstraints.maxWidth,
                        ),

                        child:Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            //mainAxisAlignment: MainAxisAlignment.start,
                            children:<Widget>[

                              Center(
                                child: Container(
                                  height:300.0,

                                  width: MediaQuery.of(context).size.width,
                                  alignment:Alignment.center,
                                  child:Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Container(
                                      //scrollDirection: Axis.horizontal,

                                      // SizedBox(height: 5.0,),

                                      child: Center(
                                        child: Container(
                                            height:300.0,
                                            width: MediaQuery.of(context).size.width,
                                            child:Image.network(
                                              recipe.imageURL,
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.cover,
                                              //fit: BoxFit.fill,
                                            )
                                        ),
                                      ),

                                    ),
                                  ),

                                  //]
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width,
                                height: 160,
                                child:
                                Row(

                                    crossAxisAlignment: CrossAxisAlignment.center,

                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children:[
                                      Container(
                                        height:150.0,
                                        child: Row(


                                            children: <Widget>[



                                              Container(


                                                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                                width: MediaQuery.of(context).size.width,
                                                //mainAxisSize: MainAxisSize.max,
                                                //children:<Widget>[
                                                child:Column(
                                                  //scrollDirection: Axis.vertical,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      new Container(
                                                        width: MediaQuery.of(context).size.width,
                                                        child: Text(
                                                            recipe.name,
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 20.0,)
                                                        ),
                                                      ),

                                                      new Padding (
                                                        padding:EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),//was 30
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                                          children: <Widget>[
                                                            new Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,

                                                              children: <Widget>[
                                                                new Text(
                                                                    "Prep time: "+recipe.prepTime.toString(),
                                                                    style: TextStyle(
                                                                      fontSize: 17.0,
                                                                      color: Colors.blueGrey,)
                                                                ),
                                                                new Text(
                                                                    "Calories: "+recipe.numCalories.toString(),
                                                                    style: TextStyle(
                                                                      fontSize: 17.0,
                                                                      color: Colors.blueGrey,)
                                                                ),
                                                                new Text(
                                                                    "Serving size: "+recipe.servings.toString(),
                                                                    style: TextStyle(
                                                                      fontSize: 17.0,
                                                                      color: Colors.blueGrey,)
                                                                ),
                                                              ],
                                                            ),
                                                            new SizedBox(width: (MediaQuery.of(context).size.width/6)), // add some space

                                                            // the save button


                                                            new Padding(
                                                              padding:EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),//was 30
                                                              child:Material(
                                                                elevation: 5.0,
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                color: Colors.lightGreen,
                                                                child:MaterialButton(
                                                                  minWidth: (MediaQuery.of(context).size.width/3),
                                                                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                                                  onPressed: (){
                                                                    print("Rec Instsructions");
                                                                    print(recipe);
                                                                    if(dbId != null){
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder: (context) => PostUpload(recipe:recipe, rid: dbId.rid.toString() ,))
                                                                      );

                                                                    } else {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder: (context) => PostUpload(recipe:recipe, rid:rId.id ,))
                                                                      );
                                                                    }

                                                                    //print(recipe.id);
                                                                    /*
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => PostUpload(recipe:recipe, rid: ,))
                                                      );*/
                                                                  },
                                                                  child: Text("Take a photo",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                      fontSize: 15.0,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.white,


                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),



                                                          ],
                                                        ),

                                                      ),


                                                    ]
                                                ),
                                                //]
                                              ),

                                            ]
                                        ),
                                      ),
                                    ]
                                ),
                              ),

                              //Expanded(
                              //mainAxisSize: MainAxisSize.min,
                              //children:<Widget>[
                              //child:


                              Container(
                                padding:EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),//was 30

                                child: new Text(
                                    "Ingredients",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20.0,)
                                ),

                              ),
                              // ]
                              // ),
                              //Flexible(
                              //fit:FlexFit.loose,
                              //mainAxisSize: MainAxisSize.min,
                              //children:<Widget>[
                              Container(
                                padding:EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),//was 30

                                child: ListView.builder(
                                    physics:NeverScrollableScrollPhysics(),
                                    primary:false,
                                    shrinkWrap: true,
                                    //scrollDirection: Axis.vertical,
                                    itemCount: recipe.ingredients.length,
                                    itemBuilder: (context, index) {
                                      return new Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                          children:<Widget> [
                                            Padding(
                                              padding:EdgeInsets.fromLTRB(00.0, 00.0, 00.0, 00.0),//was 30
                                              child:  Row(

                                                children: <Widget>[



                                                  Padding(
                                                    //alignment: Alignment.topRight,
                                                    padding:EdgeInsets.fromLTRB(00.0, 00.0, 10.0, 00.0),//was 30
                                                    child:
                                                    new Icon(
                                                      Icons.add_circle_outline,
                                                      size: 17,
                                                      color: Colors.lightGreen,
                                                    ),
                                                  ),





                                                  Expanded(

                                                    child: new Text(recipe.ingredients[index],
                                                        style: TextStyle(
                                                          fontSize: 17.0,
                                                          color: Colors.grey,
                                                        )
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ]








                                      );
                                    }
                                ),
                              ),
                              //),
                              //]
                              //),
                              Container(
                                //mainAxisSize: MainAxisSize.min,
                                //children:<Widget>[
                                height:50.00,
                                padding:EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),//was 30
                                child:Text(
                                    "Instructions",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20.0,)
                                ),
                                //]
                              ),
                              /*Row(
                            mainAxisSize: MainAxisSize.min,
                            children:<Widget>[*/
                              Flexible(
                                  child:Container(
                                    padding:EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),//was 30

                                    child:
                                    ListView.builder(
                                        physics:NeverScrollableScrollPhysics(),
                                        //scrollDirection: Axis.horizontal,
                                        itemCount: recipe.instructions.length,
                                        shrinkWrap: true,
                                        primary:false,
                                        itemBuilder: (context, index) {
                                          return new Text((index+1).toString() + ". " +recipe.instructions[index]+"\n\n",
                                              style: TextStyle(
                                                fontSize: 17.0,
                                                color: Colors.grey,
                                              )
                                          );
                                        }
                                    ),
                                  )
                              )
                              /* ]
                          ),*/
                            ]
                        )));}),
          /*} else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
              ),*/
          //]
        ),

      ),
    );
  }

}