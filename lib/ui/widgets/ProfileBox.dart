import 'package:flutter/cupertino.dart';
import 'package:gazpromconnectweb/themes/colors.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import 'MyCard.dart';
import 'MyContainerNoPading.dart';

Widget profileContentColumn(
  BuildContext context,
  String profilePhotoUrl, {
  String profileName = " ",
  String profilePhone = "телефон не указан ",
  String profileBornDate = " дата не указана",
  String profileMail = " имэйл не указан",
  String profileDepatment = "департамент",
  String profilePosition = "должность",
      int problemsEnteret = 0,
      int problemslikes = 0,
      int solutionsTrue = 0,
      int solutions = 0,
  int solutionsLikes = 0,
  String statusText = "",
  int reiting = 0,
}) {
  return new Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            authService.signOut();
            Navigator.pushNamed(context, "/");
          },
          child: Icon(Icons.exit_to_app),
        ),
        Container(
          margin: EdgeInsets.all(20),
          width: 120.0,
          height: 120.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              alignment: Alignment.topCenter,
              image: NetworkImage(profilePhotoUrl),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 18),
          child: new Text(
            profileName,
            style: new TextStyle(
                fontSize: 22.0,
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w400,
                fontFamily: "Roboto"),
          ),
        ),
        Row(
          //строка с телефоном
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(14.0),
                child: Icon(
                  Icons.phone,
                  size: 30.0,
                  color: Color(0xff6C6C6C),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  profilePhone,
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: const Color(0xFF000000),
//                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto"),
                ),
              ),
            ),
          ],
        ),
        Row(
          //строка с датой рождения
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(14.0),
                child: Icon(
                  Icons.event,
                  size: 30.0,
                  color: Color(0xff6C6C6C),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  profileBornDate,
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: const Color(0xFF000000),
//                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto"),
                ),
              ),
            ),
          ],
        ),
        Row(
          //строка с имэйлом
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(14.0),
                child: Icon(
                  Icons.mail,
                  size: 30.0,
                  color: Color(0xff6C6C6C),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  profileMail,
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: const Color(0xFF000000),
//                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto"),
                ),
              ),
            ),
          ],
        ),
        Row(
          //строка с департаментом
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(child: Center(
//                padding: const EdgeInsets.all(14.0),
                child: Text('Департамент:'),
//                child: Icon(
//                  Icons.account_balance,
//                  size: 30.0,
//                  color: Color(0xff6C6C6C),
//                ),
              ),
              )
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  profileDepatment,
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: const Color(0xFF000000),
                      //                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto"),
                ),
              ),
            ),
          ],
        ),
        Row(
          //строка с позицией
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(child: Center(child: Text('Должность:'),
//                padding: const EdgeInsets.all(14.0),
//                child: Icon(
//                  Icons.mail,
//                  size: 30.0,
//                  color: Color(0xff6C6C6C),
//                ),
              ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  profilePosition,
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: const Color(0xFF000000),
                      //                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto"),
                ),
              ),
            ),
          ],
        ),
        Row(
          //строка с кол-ом предложенных проблем
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(child: Center(
                child: Text('Количство предложеных проблем:'),
//                padding: const EdgeInsets.all(14.0),
//                child: Icon(
//                  Icons.mail,
//                  size: 30.0,
//                  color: Color(0xff6C6C6C),
//                ),
              ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  problemsEnteret.toString(),
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: const Color(0xFF000000),
                      //                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto"),
                ),
              ),
            ),
          ],
        ),
        Row(
          //строка с кол-ом лайков на предложенной тобою проблеме
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(child: Center(
                child: Text('кол-во лайков на предложенной проблеме:'),
//                padding: const EdgeInsets.all(14.0),
//                child: Icon(
//                  Icons.mail,
//                  size: 30.0,
//                  color: Color(0xff6C6C6C),
//                ),
              ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  problemslikes.toString(),
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: const Color(0xFF000000),
                      //                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto"),
                ),
              ),
            ),
          ],
        ),
        Row(
          //рейтинг
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(child: Center(child: Text('Рейтинг:'),
//                padding: const EdgeInsets.all(14.0),
//                child: Icon(
//                  Icons.mail,
//                  size: 30.0,
//                  color: Color(0xff6C6C6C),
//                ),
              ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  reiting.toString(),
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: const Color(0xFF000000),
                      //                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto"),
                ),
              ),
            ),
          ],
        ),
        Row(
          //решение
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(child: Center(child: Text('Предложено решений:'),
//                padding: const EdgeInsets.all(14.0),
//                child: Icon(
//                  Icons.mail,
//                  size: 30.0,
//                  color: Color(0xff6C6C6C),
//                ),
              ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  solutions.toString(),
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: const Color(0xFF000000),
                      //                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto"),
                ),
              ),
            ),
          ],
        ),
        Row(
          //ваше решение понравилось:
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(child: Center(child: Text('Ваше решение понравилось:'),
//                padding: const EdgeInsets.all(14.0),
//                child: Icon(
//                  Icons.mail,
//                  size: 30.0,
//                  color: Color(0xff6C6C6C),
//                ),
              ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  solutionsLikes.toString(),
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: const Color(0xFF000000),
                      //                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto"),
                ),
              ),
            ),
          ],
        ),
        Row(
          //статус текст
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(child: Center(child: Text('Статус:'),
//                padding: const EdgeInsets.all(14.0),
//                child: Icon(
//                  Icons.mail,
//                  size: 30.0,
//                  color: Color(0xff6C6C6C),
//                ),
              ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  statusText,
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: const Color(0xFF000000),
                      //                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto"),
                ),
              ),
            ),
          ],
        ),



        Padding(
          padding: const EdgeInsets.all(20.0),
          child: RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/editprofile");
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0),
                side: BorderSide(color: Colors.grey)),
            padding: const EdgeInsets.all(0.0),
            child: Ink(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(80.0)),
              ),
              child: Container(
                padding: EdgeInsets.all(14),
                width: 180,
//        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0, maxWidth: 123),
                // min sizes for Material buttons
                alignment: Alignment.center,
                child: Text(
                  "Редактировать",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ]);
}
