import 'package:flutter/material.dart';
import 'package:untitled/Signup.dart';
import 'Options.dart';
import 'Login.dart';
import 'HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Select Option UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.black,
          canvasColor: Colors.transparent,
      ),
      home: HomePage(),
    );
  }
}