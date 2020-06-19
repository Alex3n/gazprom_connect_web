import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:flutter/material.dart';

class TeamTeacher extends StatefulWidget{
  @override
  _TeamTeacherState createState() => _TeamTeacherState();
}

class _TeamTeacherState extends State<TeamTeacher> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(context),
        body: Row(
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              child: Text('ФОТО'),
            ),
            Text('Преподаватель'),
          ],
        )
    );

  }
}