import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:firebase/styleguide/colors.dart';
import 'package:firebase/styleguide/colors.dart' as prefix0;
import 'package:firebase/styleguide/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  final FirebaseUser user;
  
  AddPost({this.user});
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _post = TextEditingController();
  File _postImage;
  var uuid = Uuid();
String userName;
  void getName() async{
  final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo:widget.user.uid)
        .getDocuments();
    
    String _snapshot = result.documents[0].data['username'];
    setState(() {
      userName = _snapshot;
    });
}
  @override
  Widget build(BuildContext context) {
    return Container(
      color: priamryColor,
      child: Card(
        margin: EdgeInsets.only(left: 10, right: 10, top: 60, bottom: 60),
        child: ListView(
          children: <Widget>[
            Text(
              'Write a post',
              style: subHeadingStyle,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10.0),
              child: InkWell(
                onTap: () async{
                  var image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _postImage = image;
                  });
                },
                child: Icon(
                  Icons.image,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
            ),
            TextField(
              textAlign: TextAlign.start,
              controller: _post,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Post...'),
            ),
            FloatingActionButton(
              child: Icon(Icons.send),
              backgroundColor: prefix0.priamryColor,
              elevation: 0,
              onPressed: () {
                add_post();
              },
            )
          ],
        ),
      ),
    );
  }
  void add_post() async{
    getName();
    try {
      

      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child('posts').child(uuid.v4());
      final StorageUploadTask uploadTask = storageRef.putFile(
        File(_postImage.path),
        StorageMetadata(
          contentType: "postImage" + '/' + "jpg",
        ),
      );
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      Firestore.instance.collection("posts").document(uuid.v4()).setData({ 
        'user': userName,      
        'text': _post.text,
        'image': url
      });
     
      //user.sendEmailVerification();
      
    } catch (e) {
      
      print(e.message);
    }
  }
}
