import 'dart:ui';


import 'package:gazpromconnectweb/ui/widgets/MyCard.dart';
import 'package:gazpromconnectweb/ui/widgets/ProfileBox.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

//import 'package:sticky_headers/sticky_headers.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
 Auth _firebaseAuth = auth();
 User user;

  //FirebaseUser user;
  DocumentSnapshot dsuser;

  void getCurrentUser() async {

     store
        .collection("users")
        .doc(getUserId())
        .onSnapshot
        .listen((data) {
      setState(() {
        dsuser = data;
      });
    });

  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Widget buildProfilePageBody(BuildContext context) {
    Map map;
    if (dsuser != null) {
      map = dsuser.data();
      if (map == null) {
        map = {'name': "не указано", 'email': 'не указано', 'phone': 'не указано', 'bornDate': 'не указано', "department": 'не указано',"position": 'не указано'};
      }
    } else {
      map = {'name': "не указано", 'email': 'не указано', 'Roboto': 'не указано', 'bornDate': 'не указано', "department": 'не указано',"position": 'не указано',
        "problemsEnteret": 'не указано',"problemslikes": 'не указано',"solutionsTrue": 'не указано',"solutions": 'не указано',"solutionsLikes": 'не указано',"statusText": 'не указано',"reiting": 'не указано',

      };
    }
    return ListView(children: <Widget>[
      buildMyCardWithPadding(
        profileContentColumn(context, map['photoURL'] != null ?
        "https://firebasestorage.googleapis.com/v0/b/fcnn-8e0f7.appspot.com/o/userimages%2Favatars%2F${user.uid}?alt=media&token=933748ba-828c-431e-94a2-2a11fbcf3afc" :
        'https://st3.depositphotos.com/4111759/13425/v/450/depositphotos_134255588-stock-illustration-empty-photo-of-male-profile.jpg',
            profileName: map['name'] != null ? map['name'] : "не указано",
            profilePhone: map['phone']!= null ? map['phone'] : "не указано",
            profileBornDate: map['bornDate']!= null ? map['bornDate'] : "не указано",
            profileMail: map['email']!= null ? map['email'] : "не указано",
            profileDepatment: map['department']!= null ? map['department'] : "не указано",
            problemsEnteret: map['problemsEnteret']!= null ? map['problemsEnteret'] : "не указано",
            problemslikes: map['problemslikes']!= null ? map['problemslikes'] : "не указано",
            solutionsTrue: map['solutionsTrue']!= null ? map['solutionsTrue'] : "не указано",
            solutions: map['solutions']!= null ? map['solutions'] : "не указано",
            solutionsLikes: map['solutionsLikes']!= null ? map['solutionsLikes'] : "не указано",
            statusText: map['statusText']!= null ? map['statusText'] : "не указано",
            reiting: map['reiting']!= null ? map['reiting'] : "не указано",
            profilePosition: map['position']!= null ? map['position'] : "не указано",)
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold ( appBar: buildAppBar(context),
      body: buildProfilePageBody(context),);
  }

  void buttonPressed() {}
}

//class Example extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new ListView.builder(itemBuilder: (context, index) {
//      return new StickyHeader(
//        header: new Container(
//          height: 50.0,
//          color: Colors.blueGrey[700],
//          padding: new EdgeInsets.symmetric(horizontal: 16.0),
//          alignment: Alignment.centerLeft,
//          child: new Text('Header #$index',
//            style: const TextStyle(color: Colors.white),
//          ),
//        ),
//        content: new Container(
//          child: new Image.network(imageForIndex(index), fit: BoxFit.cover,
//              width: double.infinity, height: 200.0),
//        ),
//      );
//    });
//  }
//}

//new Container(decoration: BoxDecoration(
////                      border: Border.all(width: 10, color: Colors.black38),
//                borderRadius: const BorderRadius.all(const Radius.circular(8)),
//                color: Colors.white,
//                boxShadow: <BoxShadow>[
//                  BoxShadow(
//                    color: Colors.black,
//                    offset: Offset(1.0, 1.0,),
//                    blurRadius: 2.0,
//                  ),
//                ],
//
//              ),
//
////                padding: const EdgeInsets.fromLTRB(22.0,22.0,22.0,22.0),
//                margin: const EdgeInsets.only(bottom: 24.0),
//                child:
//
//                new Row(
//                    mainAxisSize: MainAxisSize.max,
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//
//                      new Image(image:AssetImage("assets/player2.png")),
//                      new Padding(
//                        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
//                        child:
//                        new Column (
//                            mainAxisSize: MainAxisSize.max,
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              new Text(
//                                "Бородько Михаил",
//                                style: new TextStyle(fontSize:22.0,
//                                    color: const Color(0xFF000000),
//                                    fontWeight: FontWeight.w400,
//                                    fontFamily: "Roboto"),
//                              ), new Text(
//                                "Россия",
//                                style: new TextStyle(fontSize:18.0,
//                                    color: const Color(0xFF000000),
//                                    fontWeight: FontWeight.w300,
//                                    fontFamily: "Roboto"),
//                              ), new Text(
//                                "12.07.1994",
//                                style: new TextStyle(fontSize:18.0,
//                                    color: const Color(0xFF000000),
//                                    fontWeight: FontWeight.w300,
//                                    fontFamily: "Roboto"),
//                              ),
//
//                            ]
//                        ),
//
//
//
//
//                      ),
//                      new Padding(
//                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
//                        child:
//                        new Column (
//                            mainAxisSize: MainAxisSize.max,
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            crossAxisAlignment: CrossAxisAlignment.stretch,
//                            children: <Widget>[
//
//                            ]
//                        ),
//                      )
//                    ]
//                ),
////              ),
//              new Container(decoration: BoxDecoration(
////                      border: Border.all(width: 10, color: Colors.black38),
//                borderRadius: const BorderRadius.all(const Radius.circular(8)),
//                color: Colors.white,
//                boxShadow: <BoxShadow>[
//                  BoxShadow(
//                    color: Colors.black,
//                    offset: Offset(1.0, 1.0,),
//                    blurRadius: 2.0,
//                  ),
//                ],
//              ),
//                padding: const EdgeInsets.fromLTRB(22.0,22.0,22.0,22.0),
//                margin: const EdgeInsets.only(bottom: 24.0),
//                child:
//                new Row(
//                    mainAxisSize: MainAxisSize.max,
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//
//                      new Image(image:AssetImage("assets/player3.png")),
//                      new Padding(
//                        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
//                        child:
//                        new Column (
//                            mainAxisSize: MainAxisSize.max,
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              new Text(
//                                "Шильников Виталий",
//                                style: new TextStyle(fontSize:22.0,
//                                    color: const Color(0xFF000000),
//                                    fontWeight: FontWeight.w400,
//                                    fontFamily: "Roboto"),
//                              ), new Text(
//                                "Россия",
//                                style: new TextStyle(fontSize:18.0,
//                                    color: const Color(0xFF000000),
//                                    fontWeight: FontWeight.w300,
//                                    fontFamily: "Roboto"),
//                              ), new Text(
//                                "23.09.1997",
//                                style: new TextStyle(fontSize:18.0,
//                                    color: const Color(0xFF000000),
//                                    fontWeight: FontWeight.w300,
//                                    fontFamily: "Roboto"),
//                              ),
//
//                            ]
//                        ),
//
//
//
//
//                      ),
//                      new Padding(
//                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
//                        child:
//                        new Column (
//                            mainAxisSize: MainAxisSize.max,
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            crossAxisAlignment: CrossAxisAlignment.stretch,
//                            children: <Widget>[
//
//                            ]
//                        ),
//
//
//
//
//                      )
//                    ]
//                ),
//
//
//
//              )
//            ),
//              ,

//            ),
