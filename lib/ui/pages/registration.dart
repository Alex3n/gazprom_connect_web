

import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Registration extends StatelessWidget{
  TextEditingController controllerName2 = TextEditingController();
  TextEditingController controllerSuName2 = TextEditingController();
  TextEditingController controllerPatronymic = TextEditingController();
  TextEditingController controllerData = TextEditingController();
  TextEditingController controllerCountry = TextEditingController();
  TextEditingController controllerPassword2 = TextEditingController();
  final  _formKey2 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  buildAppBar(context),
      body: Center(
        child: Container(
          child: new Form(
            key: _formKey2,
            child: Column(
                children: <Widget>[
                  Text('Введите имя'),
                  TextFormField(
                    controller: controllerName2,
                  ),
                  Text('Введите фимилию'),
                  TextFormField(
                    controller: controllerSuName2,
                  ),
                  Text('Введите отчество'),
                  TextFormField(
                    controller: controllerSuName2,
                  ),
                  Text('Дату рождения'),
                  TextFormField(
                    controller: controllerSuName2,
                  ),
                  Text('Введите город'),
                  TextFormField(
                    controller: controllerSuName2,
                  ),
                  Text('Введите секретное слово'),
                  TextFormField(
                    controller: controllerPassword2,
                  ),
                  Container(
                    height: 50,
                    child: Center(
                      child: RaisedButton(
                        child: Text('Создать учетную запись'),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/dialoglogin');
                        },
                      ),
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }

}