import 'package:cookit_demo/UserScreen.dart';
import 'package:cookit_demo/model/PostModel.dart';
import 'package:cookit_demo/model/User.dart';
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
    debugShowCheckedModeBanner: false,
    title: 'Edit Profile Picture',
    home: editProfile(),
  ));
}


class editProfile extends StatefulWidget {



  @override
  _editProfile createState() => _editProfile();
}

class _editProfile extends State<editProfile> {

  FirebaseUser currentUser;
  File _image;
  TextEditingController titleController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  String title = '';
  String caption = '';
  bool loading = false;
  String profilePic;
  String tempPic;

  DocumentReference userRef;
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
      userRef.get().then((data) {
        if (data.exists) {
          profilePic = data.data['profileImage'].toString();
          //print(profilePic);
          tempPic = profilePic;


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

  Widget _buildAvatar() {
    return new Container(
      width: 180.0,
      height: 180.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white30),
      ),
      margin: const EdgeInsets.only(top: 32.0, left: 16.0),
      padding: const EdgeInsets.all(3.0),
      child: ClipOval(
        child: Image.network(
          profilePic,
        ),
      ),);
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
      return new Container(
        width: 300.0,
        height: 300.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white30),
        ),
        margin: const EdgeInsets.only(top: 16.0, left: 16.0),
        padding: const EdgeInsets.all(3.0),
        child: ClipOval(
          child: Image.file(
            _image, width: 50, height: 50,
          ),
        ),);

      //return Container(
        //padding: EdgeInsets.only(top: 5.0, left: 20.0, bottom: 30.0),

      //);
    }
  }

  void setProfilePic(String imgURL) {

    List<String> posts = [];
    Firestore.instance.collection('users').document(currentUser.uid).updateData({
      'profileImage': imgURL,
      }
    );

    Firestore.instance
        .collection('posts')
        .where("userId", isEqualTo: currentUser.uid)
        .getDocuments().then((data){

          for (var doc in data.documents) {
            posts.add(doc.documentID);
          }
    });
  // update user profile pics in posts
    for (var postId in posts) {
      Firestore.instance.collection('posts').document(postId).updateData({
        'profileImage': imgURL,
      }
      );
    }

  }








  submitPic(BuildContext context) async {
    // uploadPic(context); // upload pic upon submit
    setState(() {
      loading = true;
    });
    bool clear = false;

    // clear and rm the previous prpfile pic if any


    // upload the selected image
    String profileImageUrl = await uploadPic(context);



    setProfilePic(profileImageUrl);



    setState(() {

      _image = null; // set image to empty
      loading = false;
    });

    Navigator.pop(
      context,
      MaterialPageRoute(builder: (context) => UserProfile()),
    );

  }


  Future<String> uploadPic(BuildContext context) async{
    if(profilePic.toString() != "") {

      print("removing.." + profilePic.toString());
      removeProfilePic(profilePic.toString());

    }

    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("UserProfileImage/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
    String downloadUrl = await firebaseStorageRef.getDownloadURL();

    // StorageReference imgStorageRef =

    return downloadUrl;
  }

  Future<void> removeProfilePic(String url) async{
    //Future<StorageReference> photoReference =
    print("removing..");

    try {

      print (" deleteing..." + url.toString());
      String path = url.toString().replaceAll(new RegExp(r'%2F'), '---');

      String remove = path.split('---')[1].replaceAll('?alt', '---');
      String img = remove.split('---')[0];
      print(img);
      final StorageReference storageReference =
      FirebaseStorage.instance.ref().child("UserProfileImage/" + img);

      storageReference.delete();
      print (" deleted..." );


    } catch (e) {
      print("Something went wrong");
      return null;
    }
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
                loading == true ?
                  showLoading(): handleNullImage(context),

               // in case the image is null
                //Image.file(_image, width: 300, height: 300 ),

                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    minWidth: 10.0,
                    height: 50.0,

                    color: Colors.lightBlueAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      if(loading == false) {
                        submitPic(context);
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


