import 'dart:ui';

import 'package:gazpromconnectweb/themes/colors.dart';
import 'package:gazpromconnectweb/ui/pages/Autorization.dart';
import 'package:firebase/src/firestore.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

AppBar buildAppBar(BuildContext context, {DocumentSnapshot valueSnapshot}) {
  return AppBar(

    actions: <Widget>[
      FlatButton(onPressed: () {
        Navigator.of(context).pushNamed("/profile");
      },
        child: Icon(Icons.account_circle),)
    ],flexibleSpace: Container(
    decoration: BoxDecoration(
        gradient: LinearGradient (begin: Alignment.bottomLeft,end: Alignment.topRight,colors: <Color>[ gazprombanviolet,gazprombankazure])    ),
  ),
    title: Container(
      height: 30,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              color: Colors.indigo,
              hoverColor: Colors.indigo[400],
              child: Text("Главная" ,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                  )
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/mainscreen');
              },
            ),
          ),
//          Expanded(
//            child: RaisedButton(
//              color: Colors.indigo,
//              hoverColor: Colors.indigo[400],
//              child: Text("Команда" ,
//                  style: TextStyle(
//                    color: Colors.white,
//                    fontSize: 22,
//                    fontWeight: FontWeight.w300,
//                  )
//              ),
//              onPressed: () {
//                Navigator.of(context).pushNamed('/');
//              },
//            ),
//          ),
          Expanded(
            child: RaisedButton(
              color: Colors.indigo,
              hoverColor: Colors.indigo[400],
              child: Text("Идеи",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                  )
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/');
              },
            ),
          ),
          Expanded(
              child: RaisedButton(
                color: Colors.indigo,
                hoverColor: Colors.indigo[400],
                child: Text("Проекты", style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                )
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/proekts');
                },
              )),
          Expanded(
              child: RaisedButton(
                color: Colors.indigo,
                hoverColor: Colors.indigo[400],
                child: Text("Админ панель",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                    )
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/adminpanel');
                },
            ),
          ),
          Expanded(flex: 2, child: myLogo(context)),
        ],
      ),
    ),
  );
}

Widget myLogo(BuildContext context) {
  return Container(
    height: 40,
    width: 400,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("image/gazprombankbluelogo.png"),
                      fit: BoxFit.fitHeight,
                      alignment: AlignmentDirectional.centerEnd))),
        ),
      ],
    ),
  );
}
