import 'package:gazpromconnectweb/data.dart';
import 'package:gazpromconnectweb/main.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:gazpromconnectweb/ui/widgets/myDropdownButton.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    store.collection("lections").onSnapshot.listen((event) {
      if (event.docs.isNotEmpty) {
        setState(() {
          lectionsDataDocs = event.docs;
        });
      }
    });
    store
        .collection("users")
        .where("role", "==", "student")
        .onSnapshot
        .listen((event) {
      if (event.docs.isNotEmpty) {
        setState(() {
          studentsAllDataDocs = event.docs;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(children: <Widget>[
              RaisedButton(
                onPressed:() {
                  Navigator.of(context).pushNamed('/ideapage');
                },
                  child: Text('Добавить идею'),
              )
            ])));
  }
}
