import 'package:firebase/Pages/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  //String _email, _password;
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _validateEmail = false;
  bool _validatePassword = false;
  String errorMessage = " ";

  @override
  void initState() {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

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
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white,
                    )),
                Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 32.0, right: 32.0),
                    child: Text(
                      'LogIn',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2.8,
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, right: 32),
                    child: Text(
                      'Forgot Password ?',
                      style: TextStyle(color: Colors.grey),
                    ),
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
                  'Login'.toUpperCase(),
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
                  signIn();
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
  }

  Future<void> signIn() async {
    //validate fields

    //login to firebase
    try {
      FirebaseUser user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _email.text,
              password: _password.text);
              print('current user:'+user.uid);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Home(user: user)));
    } catch (e) {
      errorMessage = e.message;
      print(e.message);
    }
  }
}
