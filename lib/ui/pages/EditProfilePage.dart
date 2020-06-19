
import 'package:gazpromconnectweb/main.dart';
import 'package:gazpromconnectweb/ui/widgets/MyCard.dart';
import 'package:gazpromconnectweb/ui/widgets/RaisedGradientButton.dart';
import 'package:gazpromconnectweb/ui/widgets/TextFieldPadding.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';



//import 'package:sticky_headers/sticky_headers.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Firestore store = firestore();
  TextEditingController _nameTFC = TextEditingController();

  TextEditingController _emailTFC = TextEditingController();

  TextEditingController _phoneTFC = TextEditingController();

  TextEditingController _bornDateTFC = TextEditingController();




  DocumentSnapshot dsuser;
  Map dBuser;
  String photoURL;


  bool isNameValid = false;
  bool isEmailValid = false;

  Future getCurrentUser() async {


    store
        .collection("users")
        .doc(getUserId())
        .onSnapshot
        .listen((data) {
      setState(() {
        dsuser = data;
        userDataBase = data.data();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void saveChanges() async {
    await getCurrentUser();
    store.collection("users").doc(getUserId()).set({
      'time' : ServerValue.TIMESTAMP,
      'name': _nameTFC.text,
      'email': _emailTFC.text,
      'phone': _phoneTFC.text,
      'bornDate': _bornDateTFC.text
    });
  }

  Widget profileEditContentColumn(BuildContext context) {
    Map map;
    if (dsuser != null) {
      map = dsuser.data();
      if (map != null) {
        _nameTFC.text = map["name"];
        _phoneTFC.text = map["phone"];
        _bornDateTFC.text = map["bornDate"];
        _emailTFC.text = map["email"];
      }
    }

    return new ListView(
//        mainAxisSize: MainAxisSize.max,
//        mainAxisAlignment: MainAxisAlignment.start,
//        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildMyCardWithPadding(
            Column(
              children: <Widget>[
                Container ( padding: EdgeInsets.all(20.0) ,
                  child: Text( "Профиль " + ((userDataBase["role"] == "teacher") ? "учителя" : "ученика")),),

                FlatButton (
                  child: Container(
                  margin: EdgeInsets.all(26),
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      image: FirebaseImage(photoURL != null ?
                      "gs://fcnn-8e0f7.appspot.com/" + photoURL :
                      'https://st3.depositphotos.com/4111759/13425/v/450/depositphotos_134255588-stock-illustration-empty-photo-of-male-profile.jpg'),
//
                    ),
                  ),
                ),
                  onPressed: () {
//TODO загрузка фото
                  } ),

                textFieldPadding(fieldname: "Имя", controller: _nameTFC),
                textFieldPadding(fieldname: "Телефон", controller: _phoneTFC),
                textFieldPadding(
                    fieldname: "Дата рождения", controller: _bornDateTFC),
                textFieldPadding(fieldname: "Е-mail", controller: _emailTFC),
                new Padding(
                    padding: EdgeInsets.all(24),
                    child: myGradientButton( context,
                        btnText: "Применить",
                        funk: () {
                          saveChanges();
                        }))
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 75),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: buildAppBar(context),
        body:
        profileEditContentColumn(context));
  }

  void buttonPressed() {}
}
