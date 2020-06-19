import 'package:gazpromconnectweb/ui/pages/RoomStudent.dart';
import 'package:gazpromconnectweb/ui/pages/lectionPage.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';

import '../../data.dart';

DropdownButton<DocumentSnapshot> buildDropdownButton(BuildContext context ,{DocumentSnapshot valueSnapshot}) {
  return DropdownButton(
      hint: Text('Основы программирования', style: TextStyle(
        color: Colors.indigo[900],
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),),
      elevation: 0,
      value:     valueSnapshot,
      items: lectionsDataDocs.map((DocumentSnapshot value) {
        return DropdownMenuItem(
          value: value,
          child: Column(
            children: <Widget>[
              Text('${value.data()['name']}'),
            ],
          ),
        );
      }).toList(),
      onChanged: (DocumentSnapshot value) {
        Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (BuildContext context) {
          return LectionPage( lectionData: value, );
        } ));
      });
}
DropdownButton<DocumentSnapshot> buildDropdownStudentsButton(BuildContext context ,{DocumentSnapshot valueSnapshot, Function(DocumentSnapshot) function}) {


  return DropdownButton(
    focusColor: Colors.indigoAccent[100],
      hint: Text('Ученики', style: TextStyle(
          color: Colors.indigo[900],
          fontSize: 24,
          fontWeight: FontWeight.w500
      ),),
      elevation: 0,
     value: questionController,

      items: studentsAllDataDocs.map((DocumentSnapshot value) {
        return DropdownMenuItem(
          value: value,
          child: Row(
            children: <Widget>[
              Text('${value.data()['name']}'),
            ],
          ),
        );
      }).toList(),
      onChanged: (DocumentSnapshot value) {
              questionController=value;
        function(value);

      });
}