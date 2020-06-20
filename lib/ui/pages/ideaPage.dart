import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gazpromconnectweb/themes/colors.dart';
import 'package:gazpromconnectweb/ui/widgets/MyTexts.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';

class IdeaPage extends StatefulWidget {
  @override
  _IdeaPageState createState() => _IdeaPageState();
}

class _IdeaPageState extends State<IdeaPage> {
  TextEditingController nameProblemcontroller = TextEditingController();
  TextEditingController overviewProblemcontroller = TextEditingController();
  TextEditingController otdelcontroller = TextEditingController();
  TextEditingController decisionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.all(10),
              width: 1200,
              decoration:
                  BoxDecoration(border: Border.all(color: maingazpromsilver),borderRadius: BorderRadius.all(Radius.circular(40.0))),
              child: Column(
                children: <Widget>[
                  Text('Проблема'),
                  buildTextForm(nameProblemcontroller,label: 'Название проблемы'),
                  buildTextForm(overviewProblemcontroller,label: 'описание проблемы'),
                  buildTextForm(otdelcontroller,label: 'отделение'),
                  Divider(height: 50,),
                  Text('Решение'),
                  buildTextForm(nameProblemcontroller,label: 'Напишите решение'),
                  Center(child: RaisedButton(onPressed: (){},child: Text('Сохранить',),),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
