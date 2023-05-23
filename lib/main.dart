import 'package:flutter/material.dart';
import 'moblie_project.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     home:Noise() ,
   );
  }



}