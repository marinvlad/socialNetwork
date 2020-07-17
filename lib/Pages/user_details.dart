import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Pages/chat_details.dart';
import 'package:firebase/model/user.dart';
import 'package:firebase/styleguide/colors.dart';
import 'package:firebase/styleguide/text_styles.dart';
import 'package:firebase/widgets/app_background.dart';
import 'package:firebase/widgets/label_value_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final User user;
  final FirebaseUser currentUser;
  DetailsPage({this.user, this.currentUser});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> fadeAnimation;
  int likes;
  @override
  void initState() {
    super.initState();
    getLikes();
    _controller =
        AnimationController(vsync: this, duration: Duration(microseconds: 500));
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  playAnimation() {
    _controller.reset();
    _controller.forward();
  }

  void getLikes() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('likes')
        .where('likedId', isEqualTo: widget.user.id)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    var _likes = documents.length;
    setState(() {
      likes = _likes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 100/100,
          child: Scaffold(
          body: Stack(
        children: <Widget>[
          AppBackground(
            firstColor: firstOrangeCircleColor,
            secondColor: secondOrangeCircleColor,
            thirdColor: thirdOrangeCircleColor,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
              ),
              InkWell(
                onTap: () {
                  print('current user' + widget.currentUser.uid);
                  print(widget.user.id);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatDetails(
                                user: widget.user,
                                currentUser: widget.currentUser,
                              )));
                },
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Material(
                        elevation: 10.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.message, color: priamryColor),
                        ),
                        color: Colors.white,
                        shape: CircleBorder(),
                      ),
                    )),
              ),
              FutureBuilder(
                future: playAnimation(),
                builder: (context, snap) {
                  return FadeTransition(
                    opacity: fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 100.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          LabelValueWidget(
                            value: '${likes}',
                            label: "Likes",
                            labelStyle: whiteValueLabelStyle,
                            valueStyle: whiteValueTextStyle,
                          ),
                          LabelValueWidget(
                            value: "0",
                            label: "Followers",
                            labelStyle: whiteValueLabelStyle,
                            valueStyle: whiteValueTextStyle,
                          ),
                          LabelValueWidget(
                            value: "0",
                            label: "Groups",
                            labelStyle: whiteValueLabelStyle,
                            valueStyle: whiteValueTextStyle,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              Hero(
                tag: widget.user.username,
                child: ClipRRect(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(60.0)),
                    child: Image.network(widget.user.profileImage.toString())),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(60.0)),
              child: Container(
                height: 300.0,
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Things about' + ' ${widget.user.username} :)',
                          style: subHeadingStyle),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            InfoTiles(
                              title: 'Email',
                              info: widget.user.email,
                              icon: Icon(Icons.email),
                            ),
                            InfoTiles(
                                title: 'Description',
                                info: widget.user.description,
                                icon: Icon(Icons.description))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 260.0,
            right: 20.0,
            child: Material(
              elevation: 10.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                    onTap: () {
                      Firestore.instance
                          .collection("likes")
                          .document(
                              "${setData(widget.currentUser.uid, widget.user.id)}")
                          .setData({
                        'likerId': '${widget.currentUser.uid}',
                        'likedId': '${widget.user.id}'
                      });
                      setState(() {
                        getLikes();
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              content: Container(
                                  child: Row(
                            children: <Widget>[
                              Text('You like ${widget.user.username}'),
                              Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Icon(
                                    Icons.check,
                                    color: priamryColor,
                                  ))
                            ],
                          )));
                        },
                      );
                    },
                    child: Icon(
                      Icons.thumb_up,
                      color: priamryColor,
                    )),
              ),
              color: Colors.white,
              shape: CircleBorder(),
            ),
          ),
        ],
      )),
    );
  }

  String setData(String id1, String id2) {
    return id1 + id2;
  }
}

class InfoTiles extends StatelessWidget {
  final String info;
  final String title;
  final Icon icon;
  InfoTiles({this.info, this.title, this.icon});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '$title',
                style: userDetailsStyle,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: priamryColor),
                child: icon,
              ),
            ],
          ),
          SizedBox(
            height: 4.0,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Text('$info',
                textAlign: TextAlign.center, style: userDetailsInfoStyle),
          )
        ],
      ),
    );
  }
}
