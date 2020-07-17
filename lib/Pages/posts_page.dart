import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/styleguide/colors.dart';
import 'package:firebase/styleguide/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Posts extends StatefulWidget {
  final FirebaseUser currentUser;
  Posts({@required this.currentUser});
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  String userPhoto;
  void getPhoto() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: widget.currentUser.uid)
        .getDocuments();

    String _snapshot = result.documents[0].data['profileImage'];
    setState(() {
      userPhoto = _snapshot;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhoto();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('error : ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());

            default:
              return Container(
                child: Stack(
                  children: <Widget>[
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, index) {
                          return Card(
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        CircleAvatar(
                                            radius: 20,
                                            backgroundImage:
                                                NetworkImage(userPhoto)),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 5, left: 10),
                                            child: Text(snapshot
                                                .data
                                                .documents[index]
                                                .data['user']??"",style: subHeadingStyle,)),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: snapshot.data.documents[index]
                                                  .data['image'] !=
                                              null
                                          ? Image.network(
                                              snapshot.data.documents[index]
                                                  .data['image'],
                                            )
                                          : Text(''),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        child: Row(
                                          children: <Widget>[
                                            SingleChildScrollView(
                                                child: Text(
                                              snapshot.data.documents[index]
                                                  .data['text'],
                                              maxLines: 3,
                                              overflow: TextOverflow.fade,
                                            )),
                                          ],
                                        )),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.comment,size: 30,color: Colors.blueGrey ,),
                                          Padding(
                                            padding: const EdgeInsets.only(left:82.0),
                                            child: Icon(Icons.thumb_down,size: 30,color: Colors.blueGrey,),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left:82.0),
                                            child: Icon(Icons.thumb_up,size: 30,color:Colors.blueGrey),
                                          ),                                         
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left:10.0),
                                            child: Text('0',style: TextStyle(color: Colors.grey),),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left:102.0),
                                            child: Text('0',style: TextStyle(color: Colors.grey)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left:102.0),
                                            child: Text('0',style: TextStyle(color: Colors.grey)),
                                          )
                                        ]
                                      )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              );
          }
        });
  }
}
