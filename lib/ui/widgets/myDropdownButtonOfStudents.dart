import 'package:gazpromconnectweb/ui/pages/lectionPage.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';

import '../../data.dart';

DropdownButton<DocumentSnapshot> buildDropdownButton(BuildContext context ,{DocumentSnapshot valueSnapshot}) {
  return DropdownButton(
      hint: Text('Ученики'),
      elevation: 0,
      value:     valueSnapshot,
      items: lectionsDataDocs.map((DocumentSnapshot value) {
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
        Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (BuildContext context) {
          return LectionPage( lectionData: value, );
        } ));
      });
}