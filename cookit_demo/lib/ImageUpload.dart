import 'package:cookit_demo/UserScreen.dart';
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
    home: PostUpload(),
  ));
}


class PostUpload extends StatefulWidget {



  @override
  _PostUploadState createState() => _PostUploadState();
}

class _PostUploadState extends State<PostUpload> {

  FirebaseUser currentUser;
  File _image;
  TextEditingController titleController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  String title = '';
  String caption = '';
  bool loading = false;
  DocumentReference userRef;
  String profileImage;
  String userId;
  String username;
  @override
  void initState() {
    super.initState();
    loadCurrentUser();
    getUserRef();
  }

  void loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentUser = user;

      });
    });
  }

  Future<void> getUserRef() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;

    FirebaseUser user = await _auth.currentUser();

    setState((){
      userRef = _firestore.collection('users').document(user.uid);
      userId = user.uid;
      userRef.get().then((data) {
        if (data.exists) {
          profileImage = data.data['profileImage'].toString();
          username = data.data['user_name'].toString();



        }
      });

      //print(user.displayName.toString());
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
          padding: EdgeInsets.only(top: 5.0, bottom: 0.0),
          margin: const EdgeInsets.only(bottom: 0.0),
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
        padding: EdgeInsets.only(top: 5.0, left: 20.0, bottom: 0.0),
         child: Image.file(_image, width: 300, height: 300),
      );
    }
  }

  void createPost(Post post) {

    String id;
    Firestore.instance.collection('posts').add({
      'imageUrl': post.imageUrl,
      'title': post.title,
      'description': post.description,
      'email': post.email,
      'profileImage': profileImage,
      'userId': userId,
      'user_name': username,
      'recipeId': "",
    }).then((doc){
      id = doc.documentID;
    });

    // update the id field
    Firestore.instance.collection('posts').document(id).updateData({
      'id': id,
    });


  }





  submitPost(BuildContext context) async {
   // uploadPic(context); // upload pic upon submit
    setState(() {
    loading = true;
    });

    // make the post
    String imageUrl = await uploadPic(context);

    Post currPost = Post(
      imageUrl: imageUrl,
      title: title,
      description: caption,
      email: showEmail(),
      profileImage: profileImage,


    );

    createPost(currPost);

    // clear title
    titleController.clear();
    // clear description field
    captionController.clear();

    setState(() {
      title = '';
      caption = ''; // empty the caption
      _image = null; // set image to empty
      loading = false;
    });

    Navigator.pop(
      context,
      MaterialPageRoute(builder: (context) => UserProfile()),
    );

  }


  Future<String> uploadPic(BuildContext context) async{

    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("UserRecipes/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
    String downloadUrl = await firebaseStorageRef.getDownloadURL();

   // StorageReference imgStorageRef =

    return downloadUrl;
  }


  showLoading() {
    return Container (
      width: 300.0,
      height: 300.0,

      margin: const EdgeInsets.only(top: 16.0, left: 16.0),
      padding: const EdgeInsets.all(3.0),
      child: Center(
          child:
          CircularProgressIndicator()
      ),
    );
  }





    @override
    Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24.0,

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
             loading == true ? showLoading(): handleNullImage(context), // in case the image is null
             //Image.file(_image, width: 300, height: 300 ),


             Padding(
               padding: EdgeInsets.symmetric(horizontal: 30.0),
               child: TextField(
                 controller: titleController,
                 style: TextStyle(fontSize: 18.0),
                 decoration: InputDecoration(
                   labelText: 'Title',
                 ),
                 onChanged: (input) => title = input,
               ),
             ),
           Padding(
             padding: EdgeInsets.only(top: 5.0, left: 30.0, right:30, bottom: 35.0),
             child: TextField(
               controller: captionController,
               style: TextStyle(fontSize: 18.0),
               decoration: InputDecoration(
                 labelText: 'Description',
               ),
               onChanged: (input) => caption = input,
             ),
           ),

             FlatButton(
               //borderRadius: BorderRadius.circular(30.0),
               child: MaterialButton(
                 minWidth: 110.0,
                 height: 40.0,

                 color: Colors.lightBlueAccent,
                 textColor: Colors.white,
                 onPressed: () {
                   if(loading == false) {
                     submitPost(context);
                   }
                 },
                 child: new Text('Upload'),
               ),
             ),



           ],

         )

       ),
     ),

    );
  }
}


