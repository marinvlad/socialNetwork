import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Pages/posts_page.dart';
import 'package:firebase/Pages/my_profile.dart';
import 'package:firebase/model/user.dart';
import 'package:firebase/styleguide/text_styles.dart';
import 'package:firebase/widgets/tab_text.dart';
import 'package:firebase/widgets/user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HorizontalTabLayout extends StatefulWidget {
  final FirebaseUser user;
  const HorizontalTabLayout({Key key, this.user}) : super(key: key);

  @override
  _HorizontalTabLayoutState createState() => _HorizontalTabLayoutState();
}

class _HorizontalTabLayoutState extends State<HorizontalTabLayout>
    with SingleTickerProviderStateMixin {
  int selectedTab = 1;
  AnimationController _controller;
  Animation<Offset> _animation;
  Animation<double> _animationFade;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(-0.05, 0))
        .animate(_controller);
    _animationFade = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  playAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('users')
          .document(widget.user.uid)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('error : ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return usersPage();
        }
      },
    );
  }

  StreamBuilder usersPage() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('error : ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());

            default:
              return Container(
                  height: MediaQuery.of(context).size.height/1.6,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: -30,
                        bottom: 0,
                        top: 0,
                        width: 110.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 80.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TabText(
                                text: 'Posts',
                                isSelected: selectedTab == 0,
                                onTabTap: () {
                                  setState(() {
                                    selectedTab = 0;
                                  });
                                },
                              ),
                              TabText(
                                text: 'Users',
                                isSelected: selectedTab == 1,
                                onTabTap: () {
                                  setState(() {
                                    selectedTab = 1;
                                  });
                                },
                              ),
                              TabText(
                                text: 'My profile',
                                isSelected: selectedTab == 2,
                                onTabTap: () {
                                  setState(() {
                                    selectedTab = 2;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 60.0),
                          child: FutureBuilder(
                            future: playAnimation(),
                            builder: (context, snap) {
                              return FadeTransition(
                                opacity: _animationFade,
                                child: SlideTransition(
                                  position: _animation,
                                  child: selectedTab == 1
                                      ? ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              snapshot.data.documents.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return UserCard(
                                              curenUser: widget.user,
                                              user: User(
                                                  username: snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['username']
                                                      .toString(),
                                                  email: snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['name']
                                                      .toString(),
                                                  profileImage: snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['profileImage']
                                                      .toString(),
                                                  description: snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['description']
                                                      .toString()
                                                      ,
                                                  id: snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['id']),
                                            );
                                          },
                                        )
                                      : selectedTab==2? 
                                      MyProfile(widget.user)
                                        : Posts(currentUser: widget.user,),
                                ),
                              );
                            },
                          ))
                    ],
                  ));
          }
        });
  }
}
