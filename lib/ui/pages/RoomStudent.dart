import 'package:gazpromconnectweb/func/mydb.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class RoomStudent extends StatefulWidget {
  DocumentSnapshot studentsAllDataDocs;
  RoomStudent({this.studentsAllDataDocs});
  @override
  _RoomStudentState createState() => _RoomStudentState();
}

class _RoomStudentState extends State<RoomStudent> {
  Map<String, dynamic> roomstudentMap;

  @override
  void initState() {

    //var roomstudent = widget.studentsAllDataDocs.data();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Center(child:
        Container(
          height: 1000,
          width:1500,
          color: Colors.yellow[100],
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(isReleaseVersion? userData['name'] : "имя студента", textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.indigo[800],
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: classesColumn(context),
              ),
              Expanded(
                flex: 2,
                child: studentsColumn(context),
              ),
            ],
          ),
        ),)
    );
  }

  Widget classesColumn(BuildContext context) {
    return Container(
      decoration: BoxDecoration( color: Colors.lightBlue[50],
        border: Border.all(
        color: Colors.indigo[200],
        width: 4)),
      height: 1000,
      width:500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child:
                  Text("Занятия", style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: Colors.indigo[900])
            ),
          ),

          Expanded(
            flex: 8,
            child: Container(
              height:800,
              child: StreamBuilder(
                stream: store
                    .collection("classes")
                    .where("student", "==", getUserId())
                    .onSnapshot,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> classesDataDocs = snapshot.data.docs;

                    return ListView.builder(
                        itemCount: classesDataDocs.length,
                        itemBuilder: (context, item) {
                          return Container(
                             margin: EdgeInsets.all(8.0),
                              padding:EdgeInsets.all(8.0),
                              decoration: BoxDecoration( border: Border.all()),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  ListTile(
                                    title: Text("Дата : " +
                                        classesDataDocs[item]
                                        .data()["data"]
                                        .toString()), // Основной текст (название)
                                   subtitle: Text("Тема : " +
                                          classesDataDocs[item]
                                          .data()["themeName"].toString()), // Текст описания
                                       ),

                                  Container (child: Text("Домашнее задание : " + classesDataDocs[item].data()["dz"].toString()))
                                ],
                              ));
                        });
                  } else {
                    return Container(
                      child: Text(" нет уроков"),
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget studentsColumn(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        border: Border.all(
        color: Colors.indigo[200],
            width: 4),),
      height: 1000,
      width: 500,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text("Мой опыт", style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w500,
              color: Colors.indigo[900],

            ),),

          ),
          FlatButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_context)  {

                    TextEditingController userCommentController = TextEditingController();
                    TextEditingController dateController = TextEditingController();
                    TextEditingController homeWorkStudentController = TextEditingController();


                    return Dialog(
                      child: Container(
                        width: 1600,
                        height: 600,
                        padding: EdgeInsets.all(8),


                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 1500,
                              height: 100,
                              padding: EdgeInsets.all(8),
                              child: Text("Добавление итогов занятия", textAlign: TextAlign.center, style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.indigo[900]

                              ),

                              ),
                            ),

                            Container(
                              width: 1400,
                              height: 100,
                              padding: EdgeInsets.all(8),
                              child: TextFormField(
                                controller: userCommentController,
                                decoration: InputDecoration(
                                    hintText: "Напиши, что нового и интересного сегодня было на уроке. Что понравилось и запомнилось? Какие моменты остались непонятыми и наиболее трудными?"),
                              ),
                            ),

                            Container(
                              width: 1400,
                              height: 100,
                              padding: EdgeInsets.all(8),
                              child: TextFormField(
                                controller: dateController,
                                decoration: InputDecoration(
                                    hintText: "Введите дату урока"),
                              ),
                            ),

                            Container(
                              width: 1400,
                              height: 100,
                              padding: EdgeInsets.all(8),
                              child: TextFormField(
                                controller: homeWorkStudentController,
                                decoration: InputDecoration(
                                    hintText: "Ответ на домашнее задание"),
                              ),
                            ),
                            FlatButton (onPressed: () {
                              Map<String, dynamic> newProduct = {
                                "userComment" : userCommentController.text,
                                "data" : dateController.text,
                                "dsAnswer" : homeWorkStudentController.text,
                                "student":getUserId()

                              };

                              addNewDoc(_context, "classes", newProduct, whenDone: () {

                              });

                            },
                              child: Text("Сохранить",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.yellow[900])
                              ),),
                            Expanded(
                              child: Container(
                                child: Column(
                                  children: <Widget>[],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );

                  });
            },
            child: Text("Добавить",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.yellow[900])
            ),
          ),




          Expanded(
            child: Container(
              height: 300,
              child: StreamBuilder(
                stream: store
                    .collection("classes")
                    .where("student", "==", getUserId())
                    .onSnapshot,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> studentsDataDocs = snapshot.data.docs;

                    return ListView.builder(
                        itemCount: studentsDataDocs.length,
                        itemBuilder: (context, item) {
                          return Container(
                              height: 100,
                              child: Column(
                                children: <Widget>[
                                  Text("Ответ : " +
                                      studentsDataDocs[item]
                                          .data()["userComment"]
                                          .toString()),
                                  Text("Выполнение домашнего задания : " +
                                      studentsDataDocs[item].data()["dsAnswer"].toString()),

                                ],
                              ));
                        });
                  } else {
                    return Container(
                      child: Text(" нет ответов"),
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
