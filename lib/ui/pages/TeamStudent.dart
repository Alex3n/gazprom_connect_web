import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../main.dart';

class TeamStudent extends StatefulWidget {
  @override
  _TeamStudentState createState() => _TeamStudentState();
}

class _TeamStudentState extends State<TeamStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          alignment: Alignment.topCenter,
          width: 600,
          height: 800,
          decoration: BoxDecoration(
            color: Colors.indigo[50],
            border: Border.all(
              color: Colors.yellowAccent[700],
              width: 8,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: <Widget>[
            Expanded(
                flex: 1,
                child: Text("Наша команда",
                    style: Theme.of(context).textTheme.headline5)),
            Expanded(
              flex: 10,
              child: teamColumn(context),
            ),
          ]),
        ),
      ),
    );
  }
}

Widget teamColumn(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10),
    height: 1000,
    width: 500,
    child:
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Expanded(
        child: Container(
          child: StreamBuilder(
            stream: store
                .collection("users")
                //.where("role", "==", 'teacher')
                .onSnapshot,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                List<DocumentSnapshot> studentsDataDocs = snapshot.data.docs;

                return ListView.builder(
                    itemCount: studentsDataDocs.length,
                    itemBuilder: (context, item) {
                      return Container(
                          height: 80,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Имя : " +
                                    studentsDataDocs[item]
                                        .data()["name"]
                                        .toString(),
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Text(
                                "e-mail : " +
                                    studentsDataDocs[item].data()["email"],
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Text(
                                studentsDataDocs[item]
                                    .data()["role"]
                                    .toString(),
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ],
                          ));
                    });
              } else {
                return Container(child: Text(" нет участников"));
              }
            },
          ),
        ),
      )
    ]),
  );
}
