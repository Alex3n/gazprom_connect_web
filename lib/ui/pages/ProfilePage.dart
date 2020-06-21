import 'package:gazpromconnectweb/ui/widgets/MyCard.dart';
import 'package:gazpromconnectweb/ui/widgets/ProfileBox.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

/// Данный класс отвечает за отображение профиля пользователя

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Auth _firebaseAuth = auth();
  User user;
  DocumentSnapshot dsuser;

  void getCurrentUser() async {
    User _user = _firebaseAuth.currentUser;
    store.collection("users").doc(_user.uid).onSnapshot.listen((data) {
      setState(() {
        user = _user;
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
        map = {
          'name': "не указано",
          'email': 'не указано',
          'phone': 'не указано',
          'bornDate': 'не указано'
        };
      }
    } else {
      map = {
        'name': "не указано",
        'email': 'не указано',
        'Roboto': 'не указано',
        'bornDate': 'не указано'
      };
    }
    return ListView(children: <Widget>[
      buildMyCardWithPadding(profileContentColumn(
        context,
        map['photoURL'] != null
            ? "https://firebasestorage.googleapis.com/v0/b/fcnn-8e0f7.appspot.com/o/userimages%2Favatars%2F${user.uid}?alt=media&token=933748ba-828c-431e-94a2-2a11fbcf3afc"
            : 'https://st3.depositphotos.com/4111759/13425/v/450/depositphotos_134255588-stock-illustration-empty-photo-of-male-profile.jpg',
        profileName: map['name'] != null ? map['name'] : "не указано",
        profilePhone: map['phone'] != null ? map['phone'] : "не указано",
        profileBornDate:
            map['bornDate'] != null ? map['bornDate'] : "не указано",
        profileMail: map['email'] != null ? map['email'] : "не указано",
      )),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildProfilePageBody(context),
    );
  }

  void buttonPressed() {}
}
