import 'package:firebase/Pages/home.dart';
import 'package:firebase/Setup/signIn.dart';
import 'package:firebase/Setup/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  void getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setCurrentUser(user);
  }
  void setCurrentUser(FirebaseUser userF){
    setState(() {
      user = userF;
    });
  }
  FirebaseUser user;
  @override
  void initState() {
    getCurrentUser();
    //SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? Scaffold(
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
                            Icons.all_inclusive,
                            size: 80,
                            color: Colors.white,
                          )),
                      Spacer(),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 100.0),
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
                        navigateToSignIn();
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFFeb3349), Color(0xFFf45c43)]),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: Center(
                    child: FlatButton(
                      child: Text(
                        'Sign Up'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        navigateToSignUp();
                      },
                    ),
                  ),
                )
              ],
            ),
          ))
        : Home(user: user);
  }

  void navigateToSignIn() {
    if (user!= null)
      print('yes' + user.uid);
    else
      print('no');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(), fullscreenDialog: true));
  }

  void navigateToSignUp() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignUpPage(), fullscreenDialog: true));
  }
}
