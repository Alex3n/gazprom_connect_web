import 'package:date_format/date_format.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gazpromconnectweb/func/mydb.dart';
import 'package:gazpromconnectweb/ui/widgets/MyTexts.dart';
import 'package:gazpromconnectweb/ui/widgets/myImageWidget.dart';
import 'package:gazpromconnectweb/ui/widgets/storageUploadImageWidget.dart';

import '../../main.dart';
import 'AdminPanel.dart';

class AdminEmployeesPage extends StatefulWidget {
  @override
  _AdminEmployeesPageState createState() => _AdminEmployeesPageState();
}

class _AdminEmployeesPageState extends State<AdminEmployeesPage> {
  @override
  Widget build(BuildContext context) {
    switch (adminContent) {
      case AdminContent.editEmployee:
      case AdminContent.addEmployee:
        return buildAddEmployee(context, data: currentData, id: currentId);
        break;
      default:
        return buildEmployeesPage(context);
    }
  }

  Widget buildEmployeesPage(BuildContext context) {
    return ListView(
      children: <Widget>[
        FlatButton(
          onPressed: () {
            currentData = null;
            currentId = null;
            setState(() {
              adminContent = AdminContent.addEmployee;
            });
          },
          child: Text("Добавить сотрудника"),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: store.collection("employees").orderBy("name").onSnapshot,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return GestureDetector(
                        child: buildMYColumn(
                            document: snapshot.data.docs.elementAt(index)),
                        onTap: () {
                          _handleTap(snapshot.data.docs.elementAt(index).data(),
                              id: snapshot.data.docs.elementAt(index).id);
                        },
                      );
                    });
            }
          },
        ),
      ],
    );
  }

  Widget buildMYColumn({DocumentSnapshot document}) {
    String imageUrl = document.data()['image'];
    return buildMyCardWithPaddingNotOnTap(Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
                height: (imageUrl == null || imageUrl.isEmpty) ? 1.0 : 100,
                child: (imageUrl == null || imageUrl.isEmpty)
                    ? Container()
                    : MyImageWidget(url: document.data()['image'])),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              document.data()['name'],
              style: new TextStyle(
                  fontSize: 20.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Roboto"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Text(
              document.data()['department'],
              style: new TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFFFF0000),
                  fontWeight: FontWeight.w300,
                  fontFamily: "Roboto"),
            ),
          ),
        ]));
  }

  void _handleTap(Map<String, dynamic> data, {String id}) {
    currentData = data;
    currentId = id;
    setState(() {
      adminContent = AdminContent.editEmployee;
    });
    print("taped");
  }

  Widget buildMyCardWithPaddingNotOnTap(Widget child,
      {EdgeInsets padding = const EdgeInsets.fromLTRB(23.0, 12.0, 23.0, 10.0),
      void Function() onTapFunc,
      BuildContext context,
      EdgeInsets margin = const EdgeInsets.all(4.0)}) {
    return Padding(
      padding: margin,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          child: Container(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }

  String department;

  Widget buildAddEmployee(BuildContext context,
      {Map<String, dynamic> data, String id}) {
    final controllerFullNameText = TextEditingController();
    final controllerPhoneNumber = TextEditingController();
    final controllerEmail = TextEditingController();
    final controllerStartDay = TextEditingController();
    final controllerPhotoUrl = TextEditingController();

    DateTime dateTime = DateTime.now();

    if (data == null) {
      data = Map();
    }

    if (data.isNotEmpty) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(data['date']),
          isUtc: true);
      controllerFullNameText.text = data["name"].toString();
      department = data["department"];
      controllerPhoneNumber.text = data["phoneNumber"];
      controllerEmail.text = data["email"];
      controllerPhotoUrl.text = data["image"];
      controllerStartDay.text =
          '${dateTime.day} - ${dateTime.month} - ${dateTime.year}  ' +
              '${dateTime.hour} : ${dateTime.minute}';
    }

    void clickWrite(BuildContext context) async {
      if (controllerFullNameText.text.isNotEmpty) {
        Map<String, dynamic> newProduct = {
          'name': controllerFullNameText.text,
          'department': department,
          'phoneNumber': controllerPhoneNumber.text,
          'email': controllerEmail.text,
          'image': controllerPhotoUrl.text,
          'date': "${dateTime.millisecondsSinceEpoch}",
        };

        addNewDoc(context, "employees", newProduct, whenDone: () {
          setState(() {
            adminContent = AdminContent.employees;
          });
        });
      }
      print(department);
    }

    void clickUpdate(BuildContext context) {
      if (controllerFullNameText.text.isNotEmpty) {
        Map<String, Object> newProduct = {
          'name': controllerFullNameText.text,
          'department': department,
          'phoneNumber': controllerPhoneNumber.text,
          'email': controllerEmail.text,
          'image': controllerPhotoUrl.text,
          'date': "${dateTime.millisecondsSinceEpoch}",
        };

        updateDoc(context, newProduct, collection: "employees", doc: id,
            whenDone: () {
          setState(() {
            adminContent = AdminContent.employees;
          });
        });
      }
      print(department);
    }

    void clickDelete(BuildContext context) async {
      if (data.isNotEmpty) {
        deleteDoc(context, "employees/" + id, data, whenDone: () {
          setState(() {
            adminContent = AdminContent.employees;
          });
        });
      }
    }

    return ListView(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height / 4,
            child: UploadImageWidget(controllerUrl: controllerPhotoUrl)),
        buildTextForm(controllerFullNameText, hint: 'ФИО'),
        //todo подгрузка списка
        _dropDownButton(['hr', 'it']),
        buildTextForm(controllerPhoneNumber, hint: 'номер телефона'),
        buildTextForm(controllerEmail, hint: 'e-mail'),
        buildTextForm(controllerPhotoUrl,
            hint: 'ссылка на фото', label: 'ссылка на фото'),
        buildTextForm(controllerStartDay,
            hint: "дата приема на работу",
            label: "дата приема на работу", onTap: () {
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: DateTime(2019, 3, 5),
              maxTime: DateTime(2021, 6, 7), onConfirm: (date) {
            print('confirm $date');
            controllerStartDay.text =
                '${date.day} - ${date.month} - ${date.year}  ' +
                    '${date.hour} : ${date.minute}';
          }, currentTime: DateTime.now(), locale: LocaleType.ru);
        }),
        new FlatButton(
            key: null,
            onPressed: () =>
                data.isEmpty ? clickWrite(context) : clickUpdate(context),
            child: new Text(
              data.isEmpty ? "Сохранить" : "Сохранить изменения",
              style: new TextStyle(
                  fontSize: 12.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
            )),
        data.isNotEmpty
            ? new FlatButton(
                key: null,
                onPressed: () => clickDelete(context),
                child: new Text(
                  "Удалить",
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Roboto"),
                ))
            : Container()
      ],
    );
  }

  Widget _dropDownButton(List<String> list) {
    String selected;
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<String>(
          hint: Text(department),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          value: selected,
          items: list
              .map((_value) => DropdownMenuItem(
                    child: Text(
                      _value,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w200,
                          fontFamily: "ProximaNovaBold"),
                    ),
                    value: _value,
                  ))
              .toList(),
          onChanged: (value) {
            department = value;
          },
        ));
  }
}
