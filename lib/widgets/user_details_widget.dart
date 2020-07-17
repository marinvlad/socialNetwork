import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/user.dart';
import 'package:firebase/styleguide/text_styles.dart';
import 'package:firebase/widgets/label_value_widget.dart';
import 'package:flutter/material.dart';

class UserDetailsWidget extends StatefulWidget {
  final User user;
  UserDetailsWidget({this.user});

  @override
  _UserDetailsWidgetState createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget> {
  int likes=0;
 void getLikes() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('likes')
        .where('likedId', isEqualTo:widget.user.id)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    var _likes = documents.length;
    setState(() {
      likes = _likes;
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLikes();
  }
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyCustomClipper(),
      child: Container(
        height: 180.0,
        padding: const EdgeInsets.only(
            left: 20.0, right: 16.0, top: 24.0, bottom: 12.0),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.4), width: 2.0)),
                    height: 40.0,
                    width: 40.0,
                    child: Center(
                      child: Text(
                        "0",
                        style: rankStyle,
                      ),
                    ),
                  ),
                  Text("new",style: valueLabelStyle,),
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                LabelValueWidget(
                  value: likes.toString(),
                  label: "Likes",
                  labelStyle: valueLabelStyle,
                  valueStyle: valueTextStyle,
                ),
                LabelValueWidget(
                  value: "0",
                  label: "Followers",
                  labelStyle: valueLabelStyle,
                  valueStyle: valueTextStyle,
                ),
                LabelValueWidget(
                  value: "0",
                  label: "Groups",
                  labelStyle: valueLabelStyle,
                  valueStyle: valueTextStyle,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  final double distanceFromWall = 12;
  final double controlPointDistanceFromWall = 2;
  @override
  Path getClip(Size size) {
    final double height = size.height;
    final double halfHeight = size.height * 0.5;
    final double width = size.width;

    Path clippedPath = Path();
    clippedPath.moveTo(0, halfHeight);
    clippedPath.lineTo(0, height - distanceFromWall);
    clippedPath.quadraticBezierTo(0 + controlPointDistanceFromWall,
        height - controlPointDistanceFromWall, 0 + distanceFromWall, height);
    clippedPath.lineTo(width, height);
    clippedPath.lineTo(width, 0 + 30.0);
    clippedPath.quadraticBezierTo(width - 5, 0 + 5.0, width - 35, 0 + 15.0);
    clippedPath.close();
    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
