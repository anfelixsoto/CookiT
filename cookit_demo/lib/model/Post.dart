import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  final String dp;
  final String name;
  final String time;
  final String img;


  Post({
    Key key,
    @required this.dp,
    @required this.name,
    @required this.time,
    @required this.img
  }) : super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  "https://picsum.photos/250?image=9",
                ),
              ),

              contentPadding: EdgeInsets.all(0),
              title: Text(
                "User",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "Magherita Naan Pizza",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
              ),
            ),

            Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTo_RH4Vl6pi414D21ul-heYSkJgjFyz3GolWgidi3G--KbTbkUSQ&s",
              height: 170,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),

          ],
        ),
        onTap: (){},
      ),
    );
  }
}