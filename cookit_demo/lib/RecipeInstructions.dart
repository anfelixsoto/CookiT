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
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 220.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text("Instructions", style: TextStyle(color:Colors.lightGreen, fontWeight: FontWeight.bold),),
                background: Image.network(recipe.imageURL, fit: BoxFit.cover,),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color:Colors.lightGreen),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
            SliverFillRemaining(
              child: new Container(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints viewportConstraints){
                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: viewportConstraints.maxHeight*5,
                          minHeight: viewportConstraints.maxHeight,
                          maxWidth: viewportConstraints.maxWidth,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(0.0),
                              width: MediaQuery.of(context).size.width,
                              height: 160,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 150.0,
                                    child: Row(
                                      children: <Widget>[
                                        new Container(
                                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                          width: MediaQuery.of(context).size.width,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Container(
                                                width: MediaQuery.of(context).size.width,
                                                child: Text(
                                                  recipe.name,
                                                  style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20.0),
                                                ),
                                              ),
                                              new Padding(
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
                                                    new Padding(
                                                      padding:EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),//was 30
                                                      child: Material(
                                                        elevation: 5.0,
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        color: Colors.lightGreen,
                                                        child: MaterialButton(
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
                                                          },
                                                          child: Text("Take a photo",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white
                                                          ),),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 25.0,
                              padding:EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),//was 30
                              child: new Text(
                                  "Ingredients",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20.0,)
                              ),
                            ),
                            Container(
                              padding:EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),//was 30
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                primary: false,
                                shrinkWrap: true,
                                itemCount: recipe.ingredients.length,
                                itemBuilder: (context, index){
                                  return new Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                              child: new Icon(
                                                Icons.add_circle_outline,
                                                size: 17,
                                                color: Colors.lightGreen,
                                              ),
                                            ),
                                            Expanded(
                                              child: new Text(recipe.ingredients[index],
                                              style: TextStyle(fontSize: 17.0, color: Colors.grey),),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                            Container(
                              height: 40.0,
                              padding:EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),//was 30
                              child:Text(
                                  "Instructions",
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0,)
                              ),
                            ),
                            Flexible(
                              child: Container(
                                padding:EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 0.0),//was 30
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: recipe.instructions.length,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemBuilder: (context,index){
                                    return new Text((index + 1).toString() + ". " + recipe.instructions[index] + "\n\n",
                                      style: TextStyle(fontSize: 17.0, color: Colors.grey, ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            )
          ],
        )
      ),
    );
  }

}