import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';


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


  File _image;


  Widget createButton(
      String text, {
        Color backgroundColor = Colors.transparent,
        Color textColor = Colors.white,
      }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: 150.0,
        height: 50.0,

        color: Colors.lightBlueAccent,
        textColor: textColor,
        onPressed: () {},
        child: new Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future uploadPic(BuildContext context) async{
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
      setState(() {
        print("Profile Picture uploaded");
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Recipe Image Uploaded')));
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.camera_alt,
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
      body: Builder(
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
                          width: 360.0,
                          height: 360.0,
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
                margin: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                 createButton(
                   'Cancel',
                   backgroundColor: Colors.lightBlueAccent,
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
      ),
    );
  }
}


