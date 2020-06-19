import 'package:gazpromconnectweb/func/mydb.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:gazpromconnectweb/ui/widgets/myDropdownButton.dart';
import 'package:gazpromconnectweb/ui/widgets/storageUploadImageWidget.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data.dart';
import '../../main.dart';


List<DocumentSnapshot> studentsDataDocs;

class RoomTeacher extends StatefulWidget {
  DocumentSnapshot studentsAllDataDocs;

  RoomTeacher({this.studentsAllDataDocs});

  @override
  _RoomTeacherState createState() => _RoomTeacherState();
}

class _RoomTeacherState extends State<RoomTeacher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Center(
          child: Container(
            height: 1000,
            width: 1500,
            color: Colors.yellowAccent[100],
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: studentsColumn(context),
                ),
                Expanded(
                  child: classesColumn(context),
                ),
                Expanded(
                  child: lectionColumn(context),
                ),
              ],
            ),
          ),
        ));
  }

  Widget studentsColumn(BuildContext context) {
    return Container(
      height: 1000,
      width: 500,
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              " Ученики",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.indigo[900],
              ),
            ),
            padding: EdgeInsets.all(10.0),
          ),
          Expanded(
            child: Container(
              height: 300,
              child: StreamBuilder(
                stream: store
                    .collection("users")
                    .where("role", "==", 'student')
                    .onSnapshot,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                     studentsDataDocs =
                        snapshot.data.docs;

                    return ListView.builder(
                        itemCount: studentsDataDocs.length,
                        itemBuilder: (context, item) {
                          return Container(
                              height: 80,
                              child: Column(
                                children: <Widget>[
                                  Text("Имя : " +
                                      studentsDataDocs[item]
                                          .data()["name"]
                                          .toString()),
                                  Text("e-mail : " +
                                      studentsDataDocs[item].data()["email"]),
                                ],
                              ));
                        });
                  } else {
                    return Container(
                      child: Text(" нет учеников"),
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

  Widget classesColumn(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      height: 1000,
      width: 500,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text(" Занятия",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.indigo[900])),
          ),
          FlatButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_context) {
                    return AddLessonWidget();
                  });
            },
            child: Text("Добавить"),
          ),
          Expanded(
            child: Container(
              height: 800,
              child: StreamBuilder(
                stream: store
                    .collection("classes")
                    .where("teacher", "==", getUserId())
                    .onSnapshot,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> classesDataDocs = snapshot.data.docs;

                    return ListView.builder(
                        itemCount: classesDataDocs.length,
                        itemBuilder: (context, item) {
                          return InkWell(
                            onTap: ()
                            {
                              showDialog(
                                  context: context,
                                  builder: (_context) {
                                    return AddLessonWidget(data: classesDataDocs[item],);
                                  });
                            },
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                padding: EdgeInsets.all(5.0),

                                decoration: BoxDecoration(border: Border.all(), color: Colors.white,),
                                height: 100,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text("Дата : " +
                                        classesDataDocs[item]
                                            .data()["data"]
                                            .toString()),
                                    Text("Студент : " +
                                        classesDataDocs[item]
                                            .data()["studentName"]
                                            .toString()),
                                    Text("Тема : " +
                                        classesDataDocs[item]
                                            .data()["themeName"]
                                            .toString()),
                                    Text("Домашнее задание : " +
                                        classesDataDocs[item]
                                            .data()["dz"]
                                            .toString()),
                                    Text("Статус урока : " +
                                        classesDataDocs[item]
                                            .data()["status"]
                                            .toString()),
                                  ],
                                )),
                          );
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

  Widget lectionColumn(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      height: 1000,
      width: 500,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text("Лекции",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.indigo[900])),
          ),
          FlatButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_context) {
                    return AddLectionWidget();
                  });
            },
            child: Text("Добавить"),
          ),
          Expanded(
            child: Container(
              height: 800,
              child: StreamBuilder(
                stream: store
                    .collection("lections")
                    .onSnapshot,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> lectionsDataDocs = snapshot.data.docs;

                    return ListView.builder(
                        itemCount: lectionsDataDocs.length,
                        itemBuilder: (context, item) {
                          return InkWell(
                            onTap: ()
                            {
                              showDialog(
                                  context: context,
                                  builder: (_context) {
                                    return AddLectionWidget(data: lectionsDataDocs[item],);
                                  });
                            },
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                padding: EdgeInsets.all(5.0),

                                decoration: BoxDecoration(border: Border.all(), color: Colors.white,),
                                height: 100,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: <Widget>[

                                    Text(
                                        lectionsDataDocs[item]
                                            .data()["name"]
                                            .toString()),


                                  ],
                                )),
                          );
                        });
                  } else {
                    return Container(
                      child: Text(" нет лекций"),
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

class AddLessonWidget extends StatefulWidget {
  DocumentSnapshot data;
  AddLessonWidget ({this.data});

  @override
  _AddLessonWidgetState createState() => _AddLessonWidgetState();
}

class _AddLessonWidgetState extends State<AddLessonWidget> {



  TextEditingController themeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  TextEditingController homeworkController = TextEditingController();
  bool isAdding;


  @override
  void initState() {
    if (widget.data != null) {
      isAdding = false;
      themeController.text = widget.data.data()["themeName"]
          .toString();
      dateController.text = widget.data.data()["data"]
          .toString();
      statusController.text = widget.data.data()["status"]
          .toString();
      homeworkController.text = widget.data.data()["dz"]
          .toString();


      studentsAllDataDocs.forEach((element) {
        if (element.id == widget.data.data()['student'])  {
          questionController = element;
        }
      });


    } else {
      questionController = null;

      isAdding = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Container(
              width: 400,
              height: 40,
              padding: EdgeInsets.all(8),
              child: Text(
                "Запланировать урок",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.indigo[900]),
              ),
            ),
            Container(
              width: 400,
              height: 40,
              padding: EdgeInsets.all(8),
              child: buildDropdownStudentsButton(context,
                  valueSnapshot: questionController, function: (valueSnapshot) {
                setState(() {
                  questionController = valueSnapshot;
                });
              }),
            ),
            Container(
              width: 400,
              height: 40,
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: dateController,
                decoration: InputDecoration(hintText: "Введите дату урока"),
              ),
            ),
            Container(
              width: 400,
              height: 40,
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: themeController,
                decoration: InputDecoration(hintText: "Введите тему урока"),
              ),
            ),
            Container(
              width: 400,
              height: 40,
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: statusController,
                decoration: InputDecoration(hintText: "Введите статус урока"),
              ),
            ),
            Container(
              width: 400,
              height: 40,
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: homeworkController,
                decoration:
                    InputDecoration(hintText: "Введите домашнее задание"),
              ),
            ),
            FlatButton(
              onPressed: () {
                if (questionController != null) {
                  Map<String, dynamic> newProduct = {
                    "themeName": themeController.text,
                    "data": dateController.text,
                    "status": statusController.text,
                    "student": questionController.id,
                    "studentName": questionController.data()['name'],
                    "dz": homeworkController.text,
                    "teacher": getUserId()
                  };
                  if (isAdding) {
                    addNewDoc(context, "classes", newProduct, whenDone: () {});
                  } else {
                    updateDoc(context, newProduct, collection: "classes", doc: widget.data.id, whenDone: ( ) {});
                  }
                }
              },
              child: Text(isAdding?  "Сохранить" :" Сохранить изменения"),
            ),
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
  }
}

class AddLectionWidget extends StatefulWidget {
  DocumentSnapshot data;
  AddLectionWidget ({this.data});

  @override
  _AddLectionWidgetState createState() => _AddLectionWidgetState();
}

class _AddLectionWidgetState extends State<AddLectionWidget> {



  TextEditingController nameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController imageURLController = TextEditingController();
  bool isAdding;


  @override
  void initState() {
    if (widget.data != null) {
      isAdding = false;
      nameController.text = widget.data.data()["name"]
          .toString();
      titleController.text = widget.data.data()["title"]
          .toString();
      textController.text = widget.data.data()["text"]
          .toString();
      questionController.text = widget.data.data()["question"]
          .toString();
      imageURLController.text = widget.data.data()["photoURL"]
          .toString();


    } else {
      isAdding = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Container(
              width: 400,
              height: 40,
              padding: EdgeInsets.all(8),
              child: Text(
                "Создать лекцию",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.indigo[900]),
              ),
            ),

            Container(
              width: 400,
              height: 40,
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: titleController,
                decoration: InputDecoration(hintText: "Введите название лекции"),
              ),
            ),
            Container(
                height:  MediaQuery.of(context).size.height/5 ,
                child: UploadImageWidget(controllerUrl: imageURLController)),

            Container(
              width: 400,
              height: 40,
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(hintText: "Введите тему урока"),
              ),
            ),
            Container(
              width: 400,
              height: 40,
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: textController,
                decoration: InputDecoration(hintText: "Введите статус урока"),
              ),
            ),
            Container(
              width: 400,
              height: 40,
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: imageURLController,
                decoration:
                InputDecoration(hintText: "Введите домашнее задание"),
              ),
            ),
            FlatButton(
              onPressed: () {
                if (questionController != null) {
                  Map<String, dynamic> newProduct = {
                    "name": nameController.text,
                    "title": titleController.text,
                    "text": textController.text,
                    "question": questionController.text,
                    "photoURL": imageURLController.text,
                  };
                  if (isAdding) {
                    addNewDoc(context, "lections", newProduct, whenDone: () {});
                  } else {
                    updateDoc(context, newProduct, collection: "lections", doc: widget.data.id, whenDone: ( ) {});
                  }
                }
              },
              child: Text(isAdding?  "Сохранить" :" Сохранить изменения"),
            ),
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
  }
}
