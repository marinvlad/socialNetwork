import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/user.dart';
import 'package:firebase/styleguide/colors.dart';
import 'package:firebase/styleguide/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyProfile extends StatefulWidget {
  final FirebaseUser currentUser;

  MyProfile(this.currentUser);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final _description = TextEditingController();
  File _profileImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _description.dispose();
  }

  Future<void> getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('users')
            .where('id', isEqualTo: widget.currentUser.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('error : ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());

            default:
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        await getImageFromGallery();                       
                        final StorageReference storageRef = FirebaseStorage
                            .instance
                            .ref()
                            .child(widget.currentUser.uid);
                            //storageRef != null ?FirebaseStorage.instance.ref().child(widget.currentUser.uid).delete():null;
                        final StorageUploadTask uploadTask = storageRef.putFile(
                          File(_profileImage.path),
                          StorageMetadata(
                            contentType: "profileImage" + '/' + "jpg",
                          ),
                        );
                        final StorageTaskSnapshot downloadUrl =
                            (await uploadTask.onComplete);
                        String url = (await downloadUrl.ref.getDownloadURL());
                         Firestore.instance
                            .collection('users')
                            .document(widget.currentUser.uid)
                            .updateData({
                          'profileImage': url,
                        });
                      },
                      child: CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(
                              snapshot.data.documents[0].data['profileImage'])),
                    ),
                    Text(
                      'Tap to Edit',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        snapshot.data.documents[0].data['username']??"",
                        style: headingTabStyle,
                      ),
                    ),
                    Text(
                      snapshot.data.documents[0].data['name']??"",
                      style: subHeadingStyle,
                    ),
                    SizedBox(
                      height: 20,
                      width: 200,
                      child: Divider(
                        color: Colors.teal.shade700,
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: TextFormField(
                        controller: _description,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                            hintText: 'Description'),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        Firestore.instance
                            .collection('users')
                            .document(widget.currentUser.uid)
                            .updateData({
                          'description': _description.text,
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                content: Container(
                                    child: Row(
                              children: <Widget>[
                                Text('Description updated'),
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
                        _description.text = '';
                      },
                      elevation: 0,
                      backgroundColor: priamryColor,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    )
                  ]);
          }
        });
  }
}
