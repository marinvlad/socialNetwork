import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatDetails extends StatefulWidget {
  final User user;
  final FirebaseUser currentUser;
  ChatDetails({this.user, this.currentUser});
  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  FirebaseUser userF;
  File _image=null;
  final _messageSendText = TextEditingController();
  ScrollController _scrollController = ScrollController();
  // List<CameraDescription> cameras;
  // CameraDescription firstCamera;
  // CameraController _cameraController;
  Future<void> _initializeControllerFuture;

  int marime;

  Future<void> setCurrentUser() async {
    userF = await FirebaseAuth.instance.currentUser();
    // cameras = await availableCameras();
    // firstCamera = cameras.first;
  }

  @override
  void dispose() {
    _messageSendText.dispose();
    _scrollController.dispose();
    // _cameraController.dispose();
    super.dispose();
  }

  Future<void> getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    setCurrentUser();
    // _cameraController = CameraController(
    //   // Get a specific camera from the list of available cameras.
    //   firstCamera,
    //   // Define the resolution to use.
    //   ResolutionPreset.medium,
    // );
    super.initState();
    //_initializeControllerFuture = _cameraController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Container(
              width: 40.0,
              height: 40.0,
              margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.user.profileImage),
                backgroundColor: Colors.grey[200],
                minRadius: 30,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.user.username,
                  style: TextStyle(color: Colors.black),
                ),
                Text('Online',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ))
              ],
            )
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Flexible(
                  child:
                      Padding(padding: EdgeInsets.all(10), child: usersPage()),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(-2, 0),
                  blurRadius: 5,
                ),
              ]),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => FutureBuilder<void>(
                        //               future: _initializeControllerFuture,
                        //               builder: (context, snapshot) {
                        //                 if (snapshot.connectionState ==
                        //                     ConnectionState.done) {
                        //                   // If the Future is complete, display the preview.
                        //                   return CameraPreview(
                        //                       _cameraController);
                        //                 } else {
                        //                   // Otherwise, display a loading indicator.
                        //                   return Center(
                        //                       child:
                        //                           CircularProgressIndicator());
                        //                 }
                        //               },
                        //             )));
                      },
                      child: Icon(
                        Icons.camera,
                        color: Color(0xff3E8DF3),
                      ),
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: InkWell(
                        onTap: () async{
                          await getImageFromGallery();
                          setState(() {
                            if (_image != null)
                              _messageSendText.text = 'Images';
                          });
                        },
                        child: Icon(Icons.image, color: Color(0xff3E8DF3))),
                    onPressed: () {},
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _messageSendText,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'Enter Message', border: InputBorder.none),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      String url = null;
                      print('current user:' + widget.currentUser.uid);
                      FirebaseUser userF =
                          await FirebaseAuth.instance.currentUser();
                      if(_image!=null)
                        {final StorageReference storageRef =
                            FirebaseStorage.instance.ref().child('images').child(widget.currentUser.uid);
                        final StorageUploadTask uploadTask = storageRef.putFile(
                          File(_image.path),
                          StorageMetadata(
                            contentType: "chatImage" + '/' + "jpg",
                          ),
                        );
                        
                        final StorageTaskSnapshot downloadUrl =
                            (await uploadTask.onComplete);
                        
                         url =
                            (await downloadUrl.ref.getDownloadURL());
                            final uid = userF.uid;
                            print(url);
                        }
                      if (_messageSendText.text != "")
                        Firestore.instance
                            .collection("messeges")
                            .document(
                                "${setData(widget.user.id, widget.currentUser.uid)}")
                            .collection("chatMessages")
                            .document()
                            .setData({
                          'receiverId': widget.user.id,
                          'senderId': widget.currentUser.uid,
                          'message':
                              url != null ? url : _messageSendText.text,
                          'isLink': _image!=null
                        });
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeOut);
                      _messageSendText.text = "";
                      _image=null;
                    },
                    child: Icon(
                      Icons.send,
                      color: Color(0xFFFDA085),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String setData(String id1, String id2) {
    if (id1.compareTo(id2) == -1)
      return id1 + id2;
    else
      return id2 + id1;
  }

  Future<int> getLength() async {
    FirebaseUser userF = await FirebaseAuth.instance.currentUser();
    final uid = userF.uid;
    final QuerySnapshot result = await Firestore.instance
        .collection('messeges')
        .where('sender', isEqualTo: uid)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length;
  }

  void getInt() async {
    marime = await getLength();
  }

  StreamBuilder usersPage() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('messeges')
            .document(setData(widget.currentUser.uid, widget.user.id))
            .collection('chatMessages')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('error : ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              switch (userF) {
                case null:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  return Container(
                      height: MediaQuery.of(context).size.height - 150,
                      child: Stack(children: <Widget>[
                        ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.only(bottom: 60),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, index) {
                            return Bubble(
                              object: snapshot
                                  .data.documents[index].data['message'],
                              isMe: snapshot
                                      .data.documents[index].data['senderId'] ==
                                  widget.currentUser.uid,
                              isLink: snapshot.data.documents[index].data['isLink'],
                            );
                          },
                        )
                      ]));
              }
          }
        });
  }
}

class Bubble extends StatelessWidget {
  final bool isMe;
  final String object;
  final bool isLink;
  Bubble({this.isMe, this.object,this.isLink});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: isMe ? EdgeInsets.only(left: 40) : EdgeInsets.only(right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    gradient: isMe
                        ? LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: [0.1, 1],
                            colors: [Color(0xFFF6D365), Color(0xFFFDA085)])
                        : LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: [0.1, 1],
                            colors: [Color(0xFFEBF5FC), Color(0xFFEBF5FC)]),
                    borderRadius: isMe
                        ? BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(0),
                            bottomLeft: Radius.circular(15))
                        : BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(0))),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    isLink != true ? Text(
                      object,
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                      style:
                          TextStyle(color: isMe ? Colors.white : Colors.grey),
                    ) : Image.network(object)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
