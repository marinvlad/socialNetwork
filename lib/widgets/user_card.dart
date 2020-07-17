import 'package:firebase/Pages/user_details.dart';
import 'package:firebase/styleguide/colors.dart';
import 'package:firebase/styleguide/text_styles.dart';
import 'package:firebase/widgets/user_details_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase/model/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final FirebaseUser curenUser;
  UserCard({this.user,this.curenUser});
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: user.username,
          child: InkWell(
        onTap: (){
          print('current user:'+curenUser.uid);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsPage(user: user,currentUser: curenUser,)));
        },
            child: SizedBox(
          width: 280.0,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 60.0),
            elevation: 20.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(
                    user.profileImage,
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: UserDetailsWidget(user: user),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 80,
                    child: Material(
                      elevation: 20.0,
                      color: priamryColor,
                      shape: CustomShapeBorder(),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 18.0, left: 20.0, right: 16.0, bottom: 10.0),
                        child: Text(
                          user.username,
                          style: userNameStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomShapeBorder extends ShapeBorder {
  final double distanceFromWall = 12;
  final double controlPointDistanceFromWall = 2;
  @override
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return getClip(Size(130.0, 60.0));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return null;
  }

  Path getClip(Size size) {
    Path clippedPath = Path();
    clippedPath.moveTo(0 + distanceFromWall, 0);
    clippedPath.quadraticBezierTo(0 + controlPointDistanceFromWall,
        0 + controlPointDistanceFromWall, 0, 0 + distanceFromWall);
    clippedPath.lineTo(0, size.height - distanceFromWall);
    clippedPath.quadraticBezierTo(
        0 + controlPointDistanceFromWall,
        size.height - controlPointDistanceFromWall,
        0 + distanceFromWall,
        size.height);
    clippedPath.lineTo(size.width - distanceFromWall, size.height);
    clippedPath.quadraticBezierTo(
        size.width - controlPointDistanceFromWall,
        size.height - controlPointDistanceFromWall,
        size.width,
        size.height - distanceFromWall);
    clippedPath.lineTo(size.width, size.height * 0.6);
    clippedPath.quadraticBezierTo(
        size.width - 1,
        size.height * 0.6 - distanceFromWall,
        size.width - distanceFromWall,
        size.height * 0.6 - distanceFromWall - 3);
    clippedPath.lineTo(0 + distanceFromWall + 6, 0);
    clippedPath.close();
    return clippedPath;
  }
}
