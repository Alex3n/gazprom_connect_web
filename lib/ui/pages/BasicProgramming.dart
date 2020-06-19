import 'package:flutter/material.dart';

class BasicProgramming extends StatefulWidget{
  @override
  _BasicProgrammingState createState() => _BasicProgrammingState();
}

class _BasicProgrammingState extends State<BasicProgramming> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          RaisedButton(child: Text("Основы программирования"),onPressed: () {Navigator.of(context).pushNamed('/basicprogramming');},),
          RaisedButton(child: Text("Команда"),onPressed: () {Navigator.of(context).pushNamed('/team');},),
          RaisedButton(child: Text("Дом"),onPressed: () {Navigator.of(context).pushNamed('/');},),
          RaisedButton(child: Text("Моя комната"),onPressed: () {Navigator.of(context).pushNamed('/dialoglogin');},)
        ],
      ),
    );

  }
}