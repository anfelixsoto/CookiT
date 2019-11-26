import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cookit_demo/model/PostModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';



void main(){
  runApp(MaterialApp(
    title: 'CookiT Recipe Results',
    home: CreatePost(),
  ));
}

class CreatePost extends StatefulWidget {
@override
_CreatePost createState() => _CreatePost();
}

class _CreatePost extends State<CreatePost> {
  File _image;
  TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool _isLoading = false;
  final postsData = Firestore.instance.collection('posts');


  createPost(Post post) {
    postsData.document(post.username).collection('userPosts').add({
      'imageUrl' : post.imageUrl,
      'description': post.description,
      'username' : post.username
    });
  }

  Future<String> getUsername() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String username = user.email;
    return username;
  }

  Future<File> compressImage(String photoId, File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70,
    );
    return compressedImageFile;
  }

  Future<String> uploadPost(File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);
    StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child('images/posts/post_$photoId.jpg').putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Add Photo'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Take Photo'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            CupertinoActionSheetAction(
              child: Text('Choose From Gallery'),
              onPressed: () => _handleImage(ImageSource.gallery),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  _androidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Add Photo'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Take Photo'),
              onPressed: () => _handleImage(ImageSource.camera),
            ),
            SimpleDialogOption(
              child: Text('Choose From Gallery'),
              onPressed: () => _handleImage(ImageSource.gallery),
            ),
            SimpleDialogOption(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      imageFile = await imageFile;
      setState(() {
        _image = imageFile;
      });
    }
  }





  _submit() async {
    if (!_isLoading && _image != null && _caption.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      // Create post
      String imageUrl = await uploadPost(_image);
      Post post = Post(
        imageUrl: imageUrl,
        description: _caption,
        username: getUsername().toString(),
      );
      createPost(post);

      // Reset data
      _captionController.clear();

      setState(() {
        _caption = '';
        _image = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Create Post',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _submit,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: height,
            child: Column(
              children: <Widget>[
                _isLoading
                    ? Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                )
                    : SizedBox.shrink(),
                GestureDetector(
                  onTap: _showSelectImageDialog,
                  child: Container(
                    height: width,
                    width: width,
                    color: Colors.grey[300],
                    child: _image == null
                        ? Icon(
                      Icons.add_a_photo,
                      color: Colors.white70,
                      size: 150.0,
                    )
                        : Image(
                      image: FileImage(_image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    controller: _captionController,
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      labelText: 'Caption',
                    ),
                    onChanged: (input) => _caption = input,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}