import 'package:cookit_demo/RecipeInstructions.dart';
import 'package:cookit_demo/model/Recipe.dart';
import 'package:cookit_demo/model/recipeId.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    title: 'CookiT Recipe Results',
    home: RecipeInstructions(recipe:null),
  ));
}

class RecipeInstructions extends StatelessWidget {
  final Recipe recipe;
  RecipeInstructions({Key key,@required this.recipe}):super(key:key);


  @override
  Widget build(BuildContext context){
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
            body: Container(
              child: /*FutureBuilder<Recipe>(
              future: recipe,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return*/ LayoutBuilder(
    builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        padding:EdgeInsets.all(15.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: viewportConstraints.maxHeight*5,
            minHeight: viewportConstraints.maxHeight,
            //maxHeight:double.infinity,
            //minWidth: viewportConstraints.maxWidth,
            maxWidth: viewportConstraints.maxWidth,
          ),
                    child:Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget>[ 
                    Container(
                      height:170.0,
                      width:600.0,
                      alignment:Alignment.center,
                      child:Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 50, 10),
                        child: ListView(
                          //scrollDirection: Axis.horizontal,
                          primary:false,
                          shrinkWrap: true,
                          children: <Widget>[
                            SizedBox(height: 5.0,),
                            new Container(
                              height:150.0,
                              width:200.0,
                              child:Image.network(
                                recipe.imageURL,
                                fit: BoxFit.fill,)
                            ),
                          ]
                        ),
                      ),
                    //]
                   ),
                      Flexible(
                         fit:FlexFit.loose,
                        //mainAxisSize: MainAxisSize.min,
                        child://children:<Widget>[
                          Container(height:120.0,child:
                          ListView(
                            scrollDirection: Axis.horizontal,
                            primary:false,
                          shrinkWrap: true,
                          
                          children: <Widget>[
                            Container(
                              width:160.0,
                              //mainAxisSize: MainAxisSize.max,
                              //children:<Widget>[
                                    child:ListView(
                                      //scrollDirection: Axis.vertical,
                                      physics:NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      primary:false,
                                      children: <Widget>[
                                        new Text(
                                          recipe.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: Colors.black,)
                                        ),
                                        new Text(
                                          "Prep time: "+recipe.prepTime.toString(),
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.grey,)
                                        ),
                                        new Text(
                                          "Calories: "+recipe.numCalories.toString(),
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.grey,)
                                        ),
                                        new Text(
                                          "Serving size: "+recipe.servings.toString(),
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.grey,)
                                        ),
                                      ]
                                    ),
                              //]
                            ),
                                     Container(
                                       width:120.0,
                                        child:ListView(
                                          physics:NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: <Widget>[Padding(
                                              padding:EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),//was 30
                                              child:Material(
                                                elevation: 5.0,
                                                borderRadius: BorderRadius.circular(10.0),
                                                color: Colors.lightGreen,
                                                child:MaterialButton(
                                                  minWidth: MediaQuery.of(context).size.width,
                                                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                                  onPressed: (){},
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
                                      ]
                                      ),
                                     ),
                                ]
                             ),
                           // ] 
                          ), ),   
                          //Expanded(
                            //mainAxisSize: MainAxisSize.min,
                            //children:<Widget>[
                              //child:
                              Flexible(
                                fit:FlexFit.loose,
                                    //width:300.0,
                                    //height:25.0,
                                    child:
                                      new Text(
                                        "Ingredients",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: Colors.black,)
                                      ),
                              ),
                           // ]
                         // ),
                          //Flexible(
                             //fit:FlexFit.loose,
                            //mainAxisSize: MainAxisSize.min,
                            //children:<Widget>[
                              //child:Container(
                               // width:300.0,
                                ListView.builder(
                                  physics:NeverScrollableScrollPhysics(),
                                  primary:false,
                                  shrinkWrap: true,
                                  //scrollDirection: Axis.vertical,
                                  itemCount: recipe.ingredients.length,
                                  itemBuilder: (context, index) {
                                    return new Text(recipe.ingredients[index],
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      )
                                    );
                                  }
                                ),
                              //),
                            //]
                          //),
                          Container(
                            //mainAxisSize: MainAxisSize.min,
                            //children:<Widget>[
                              height:50.00,
                              padding:EdgeInsets.fromLTRB(0, 30, 0, 0),
                                child:Text(
                                  "Instructions",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.black,)
                                ),
                            //]
                          ),
                          /*Row(
                            mainAxisSize: MainAxisSize.min,
                            children:<Widget>[*/
                            Flexible(
                              child:
                                ListView.builder(
                                  physics:NeverScrollableScrollPhysics(),
                                  //scrollDirection: Axis.horizontal,
                                  itemCount: recipe.instructions.length,
                                  shrinkWrap: true,
                                  primary:false,
                                  itemBuilder: (context, index) {
                                    return new Text(recipe.instructions[index],
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      )
                                    );
                                  }
                                ),)
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