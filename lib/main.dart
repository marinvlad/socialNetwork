import 'package:firebase/Setup/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase/Setup/signIn.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Firebase",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
    );
  }
  
}

