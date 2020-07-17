import 'package:firebase/Pages/add_post.dart';
import 'package:firebase/Setup/signIn.dart';
import 'package:firebase/Setup/signUp.dart';
import 'package:firebase/Setup/welcome.dart';
import 'package:firebase/styleguide/colors.dart';
import 'package:firebase/styleguide/text_styles.dart';
import 'package:firebase/widgets/app_background.dart';
import 'package:firebase/widgets/horizontal_tab_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Home extends StatelessWidget {
  const Home({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 100/100,
          child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            AppBackground(
                firstColor: firstCircleColor,
                secondColor: secondCircleColor,
                thirdColor: thirdCircleColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Material(
                        elevation: 10.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Icon(Icons.exit_to_app, color: priamryColor),
                            onTap: () {
                              FirebaseAuth.instance.signOut();

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LoginPage()));
                            },
                          ),
                        ),
                        color: Colors.white,
                        shape: CircleBorder(),
                      )),
                ),
                HeadingSubHeadingWidget(),
                HorizontalTabLayout(
                  user: user,
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48.0, vertical: 30.0),
                    child: InkWell(
                      onTap: ()
                      {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost(user: user,)));
                      },
                      child: Text("New Post", style: buttonStyle)),
                    decoration: BoxDecoration(
                        color: priamryColor,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(40.0))),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HeadingSubHeadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'ChatApp',
            style: headingTabStyle,
          ),
          Text('Kick of the conversation', style: subHeadingStyle)
        ],
      ),
    );
  }
}
