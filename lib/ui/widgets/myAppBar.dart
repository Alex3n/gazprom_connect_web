import 'dart:ui';

import 'package:gazpromconnectweb/ui/pages/Autorization.dart';
import 'package:firebase/src/firestore.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'myDropdownButton.dart';

AppBar buildAppBar(BuildContext context, {DocumentSnapshot valueSnapshot}) {
  return AppBar(
    backgroundColor: Color(0xFF8C9EFF),
    actions: <Widget>[
      FlatButton(onPressed: () {
        Navigator.of(context).pushNamed("/profile");
      },
        child: Icon(Icons.account_circle),)
    ],
    title: Container(
      height: 30,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: buildDropdownButton(context, valueSnapshot: valueSnapshot),
          ),
          Expanded(
            child: RaisedButton(
              color: Colors.indigo,
              hoverColor: Colors.indigo[400],
              child: Text("Команда" ,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                  )
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/teamstudent');
              },
            ),
          ),
          Expanded(
            child: RaisedButton(
              color: Colors.indigo,
              hoverColor: Colors.indigo[400],
              child: Text("Дом",
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
                child: Text("Моя комната", style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                )
                ),
                onPressed: () {
                  if (isReleaseVersion) {
                    authService = new AuthService();
                    authService.checkIsSignedIn().then((_isSignedIn) {
                      if (_isSignedIn) {
                        store.collection("users").doc(getUserId()).get().then((
                            value) {
                          if (value.data() == null || value
                              .data()
                              .isEmpty) {
                            store.collection("users").doc(getUserId()).set({
                              "name": userFB.displayName,
                              "phone": userFB.phoneNumber,
                              "email": userFB.email,
                              "role": "user"
                            }).then((value) =>
                                Navigator.pushNamed(context, '/newuserroom'));
                          } else {
                            userDataBase = value.data();
                            if (userDataBase["role"] == "teacher") {
                              Navigator.pushNamed(context, '/roomteacher');
                            } else if (userDataBase["role"] == "student") {
                              Navigator.pushNamed(context, '/roomstudent');
                            } else {
                              Navigator.pushNamed(context, '/newuserroom');
                            }
                          }
                        });
                      }
                      else {
                        Navigator.of(context).pushNamed('/dialoglogin');
                      }
                    });
                  }  else {
                    Navigator.pushNamed(context, '/roomstudent');

                  }
                },
              )),
        ],
      ),
    ),
  );
}
