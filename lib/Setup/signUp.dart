import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Setup/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //String _email, _password;

  @override
  void initState() {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _validateEmail = false;
  bool _validatePassword = false;
  String errorMessage = " ";
  File _profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
                ),
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Icon(
                        Icons.add_a_photo,
                        size: 80,
                        color: Colors.white,
                      ),
                      onTap: () {
                        getImageFromGallery();
                      },
                    )),
                Center(
                  child: _profileImage == null
                      ? Text(
                          "Add a profile photo",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "Image selected!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 32.0, right: 32.0),
                    child: Text(
                      'SignUp',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 62.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 70,
                  padding: EdgeInsets.only(top: 10, left: 16, bottom: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5)
                      ]),
                  child: TextField(
                    controller: _email,
                    decoration: InputDecoration(
                        errorText:
                            _validateEmail ? 'Value Can\'t Be Empty' : null,
                        border: InputBorder.none,
                        icon: Icon(Icons.email, color: Colors.grey),
                        hintText: 'Email'),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 70,
                  margin: EdgeInsets.only(top: 32),
                  padding: EdgeInsets.only(top: 10, left: 16, bottom: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5)
                      ]),
                  child: TextField(
                    obscureText: true,
                    controller: _password,
                    decoration: InputDecoration(
                        errorText:
                            _validatePassword ? 'Value Can\'t Be Empty' : null,
                        border: InputBorder.none,
                        icon: Icon(Icons.vpn_key, color: Colors.grey),
                        hintText: 'Password'),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width / 1.2,
            child: Center(
              child: Text(
                '${errorMessage}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFFf45d27), Color(0xFFf5851f)]),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Center(
              child: FlatButton(
                child: Text(
                  'Sign Up'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  setState(() {
                    _email.text.isEmpty
                        ? _validateEmail = true
                        : _validateEmail = false;
                    _password.text.isEmpty
                        ? _validatePassword = true
                        : _validatePassword = false;
                  });
                  signUp();
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            height: 50,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFFeb3349), Color(0xFFf45c43)]),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Center(
              child: FlatButton(
                child: Text(
                  'Cancel'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    ));
    //  return Scaffold(
    //    appBar: AppBar(
    //      title: Text('Sign Up'),
    //    ),
    //    body: Form(
    //      key: _formKey,
    //      child: Column(
    //        children: <Widget>[
    //          TextFormField(
    //            validator: (input){
    //              if(input.isEmpty)
    //              {
    //                return 'Please type an email';
    //              }
    //            },
    //            onSaved: (input){
    //               _email=input;
    //            },
    //            decoration: InputDecoration(
    //              labelText: 'Email',
    //            ),
    //          ),
    //            TextFormField(
    //            validator: (input){
    //              if(input.length < 6)
    //              {
    //                return 'Your password is to short';
    //              }
    //            },
    //            onSaved: (input){
    //               _password=input;
    //            },
    //            decoration: InputDecoration(
    //              labelText: 'Password',
    //            ),
    //            obscureText: true,
    //          ),
    //          RaisedButton(
    //            onPressed: (){
    //               signUp();
    //            },
    //            child: Text('Sign Up'),
    //          )
    //        ],
    //      )
    //    ),
    //  );
  }

  Future<void> getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = image;
    });
  }

  Future<void> signUp() async {
    //validate fields

    try {
      FirebaseUser user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email.text.toString(),
              password: _password.text.toString());

      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child(user.uid);
      final StorageUploadTask uploadTask = storageRef.putFile(
        File(_profileImage.path),
        StorageMetadata(
          contentType: "profileImage" + '/' + "jpg",
        ),
      );
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      Firestore.instance.collection("users").document(user.uid).setData({
        'description': 'Seams that this field has not been edited yet',
        'id': '${user.uid}',
        'name': '${_email.text.toString()}',
        'role': 'user',
        'profileImage': url
      });
     
      //user.sendEmailVerification();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      setState(() {
        errorMessage = e.message;
      });
      print(e.message);
    }
  }
}
