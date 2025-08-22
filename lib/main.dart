import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Practica 1'),
          backgroundColor: Colors.pink,
        ),
        body: Container(
          child: Center(child: Text("Hello World")),
          
        ),
      ),
    );
  }
}