import 'package:cookit_demo/model/PostModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';


void main(){
  runApp(MaterialApp(
    title: 'Image Upload',
    home: ProfilePage(),
  ));
}


class ProfilePage extends StatefulWidget {



  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  FirebaseUser currentUser;
  File _image;
  TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
  }

  void loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentUser = user;
      });
    });
  }

  String showEmail() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "no current user";
    }
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
                onTap: (){
                  openGallery(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text('Camera'),
                onTap: () {
                  openCamera(context);
                },
              ),

              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.redAccent,
                    )
                ),

                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      );
    });
  }

  Widget handleNullImage(BuildContext context) {
    if (_image == null) {
      return Container (
          padding: EdgeInsets.only(top: 5.0, bottom: 30.0),
          margin: const EdgeInsets.only(bottom: 10.0),
          height: 300,
          width: 300,
          color: Colors.blueGrey[100],

        child: Center (

            child: MaterialButton(
              minWidth: 10.0,
              height: 50.0,
              color: Colors.white,
              onPressed: () {
                showOptions(context);
              },
              child: new Text('Pick Image'),
            ),


        )
      );
    } else {
      return Container(
        padding: EdgeInsets.only(top: 5.0, left: 20.0, bottom: 30.0),
         child: Image.file(_image, width: 300, height: 300),
      );
    }
  }

  void createPost(Post post) {
    Firestore.instance.collection('posts').add({
      'imageUrl': post.imageUrl,
      'description': post.description,
      'email': post.email,
    });
  }





  submitPost(BuildContext context) async {
   // uploadPic(context); // upload pic upon submit

    // make the post
    String imageUrl = await uploadPic(context);

    Post currPost = Post(
      imageUrl: imageUrl,
      description: _caption,
      email: showEmail(),

    );

    createPost(currPost);

    // clear description field
    _captionController.clear();

    setState(() {
      _caption=''; // empty the caption
      _image = null; // set image to empty
    });
  }
/*
  @override
  Widget build(BuildContext context) {

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

*/

  Future<String> uploadPic(BuildContext context) async{

    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("UserRecipes/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
    String downloadUrl = await firebaseStorageRef.getDownloadURL();
    return downloadUrl;
    setState(() {
      print("Profile Picture uploaded");
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Recipe Image Uploaded')));
    });
  }




    @override
    Widget build(BuildContext context) {

     /* Future getImage() async {
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);

        setState(() {
          _image = image;
          print('Image Path $_image');
        });
      }

      */





    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Upload Picture'),
        backgroundColor: Colors.lightGreen,
      ),
     body: Container(
       margin: EdgeInsets.all(20.0),


       child: Center(
         child: ListView(
           //mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: <Widget>[
             handleNullImage(context), // in case the image is null
             //Image.file(_image, width: 300, height: 300 ),

         ClipRRect(
           borderRadius: BorderRadius.circular(30.0),
           child: MaterialButton(
             minWidth: 10.0,
             height: 50.0,

             color: Colors.lightBlueAccent,
             textColor: Colors.white,
             onPressed: () {
               submitPost(context);
             },
             child: new Text('Upload'),
           ),
         ),
           Padding(
             padding: EdgeInsets.symmetric(horizontal: 30.0),
             child: TextField(
               controller: _captionController,
               style: TextStyle(fontSize: 18.0),
               decoration: InputDecoration(
                 labelText: 'Description',
               ),
               onChanged: (input) => _caption = input,
             ),
           ),

            /*  MaterialButton(
                minWidth: 10,
                 height: 40,
                 color: Colors.lightBlueAccent,
                 onPressed: () {
                   uploadPic(context);
                 },

                 elevation: 4.0,
                 splashColor: Colors.blueGrey,
                 child: Text(
                   'Upload',
                   style: TextStyle(color: Colors.white, fontSize: 16.0),
                 ),
               ),*/



           ],

         )

       ),
     ),
     /* body: Builder(
        builder: (context) =>  Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(


                      child: SizedBox(
                        child: new SizedBox(
                          width: 300.0,
                          height: 300.0,
                          child: (_image!=null)?Image.file(
                            _image,
                            fit: BoxFit.fill,
                          ):Image.network(
                            "http://blog.williams-sonoma.com/wp-content/uploads/2017/11/nov-18-Sweet-Potato-Pancakes-with-Walnuts-652x978.jpg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Column(
                        children: <Widget>[

                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(

                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Align(

                          ),
                          Align(

                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,

                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text('Add an image ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0, left: 20.0),

                            child: IconButton(
                              icon: Icon(
                                Icons.add_photo_alternate,
                                color: Colors.lightBlueAccent,
                                size: 40.0,
                              ),
                              onPressed: () {
                                getImage();
                              },
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(

                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: () {
                      uploadPic(context);
                    },

                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    child: Text(
                      'Upload',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),


                ],
              )

            ],
          ),

        ),
      ),*/
    );
  }
}


