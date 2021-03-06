import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazpromconnectweb/func/mydb.dart';
import 'package:gazpromconnectweb/ui/widgets/MyCard.dart';
import 'package:gazpromconnectweb/ui/widgets/MyTexts.dart';
import 'package:gazpromconnectweb/ui/widgets/myImageWidget.dart';
import 'package:gazpromconnectweb/ui/widgets/storageUploadImageWidget.dart';

import '../../main.dart';
import 'AdminPanel.dart';

class AdminDepartmentPage extends StatefulWidget {
  @override
  _AdminDepartmentPageState createState() => _AdminDepartmentPageState();
}

class _AdminDepartmentPageState extends State<AdminDepartmentPage> {
  @override
  Widget build(BuildContext context) {
    switch (adminContent) {
      case AdminContent.editDepartment:
      case AdminContent.addDepartment:
        return buildAddDepartment(context, data: currentData, id: currentId);
        break;
      default:
        return buildDepartmentsPage(context);
    }
  }

  Widget buildDepartmentsPage(BuildContext context) {
    return ListView(
      children: <Widget>[
        FlatButton(
          onPressed: () {
            currentData = null;
            currentId = null;
            setState(() {
              adminContent = AdminContent.addDepartment;
            });
          },
          child: Text("Добавить отдел"),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: store
              .collection("departments")
              .orderBy("title")
              .onSnapshot,
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

  void _handleTap(Map<String, dynamic> data, {String id}) {
    currentData = data;
    currentId = id;
    setState(() {
      adminContent = AdminContent.editDepartment;
    });
    print("taped");
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
              document.data()['title'],
              style: new TextStyle(
                  fontSize: 20.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Roboto"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              "Количество сотрудников: ",
              style: new TextStyle(
                  fontSize: 14.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w300,
                  fontFamily: "Roboto"),
            ),
          )
        ]));
  }

  Widget buildMyCardWithPadding(Widget child,
      {EdgeInsets padding = const EdgeInsets.fromLTRB(23.0, 12.0, 23.0, 10.0),
      AdminContent content,
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
          onTap: () {
            setState(() {
              adminContent = content;
            });
            print('Card tapped.');
          },
          child: Container(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }

  Widget buildAddDepartment(BuildContext context,
      {Map<String, dynamic> data, String id}) {
    final controllerFullNameText = TextEditingController();
    final controllerDescription = TextEditingController();
    final controllerPhotoUrl = TextEditingController();

    if (data == null) {
      data = Map();
    }

    if (data.isNotEmpty) {
      controllerFullNameText.text = data["title"].toString();
      controllerDescription.text = data["description"].toString();
      controllerPhotoUrl.text = data["image"];
    }

    void clickWrite(BuildContext context) async {
      if (controllerFullNameText.text.isNotEmpty) {
        Map<String, dynamic> newProduct = {
          'title': controllerFullNameText.text,
          'description': controllerDescription.text.toString(),
          'image': controllerPhotoUrl.text
        };

        addNewDoc(context, "departments", newProduct, whenDone: () {
          setState(() {
            adminContent = AdminContent.departments;
          });
        });
      }
    }

    void clickUpdate(BuildContext context) {
      if (controllerFullNameText.text.isNotEmpty) {
        Map<String, Object> newProduct = {
          'title': controllerFullNameText.text,
          'description': controllerDescription.text,
          'image': controllerPhotoUrl.text,
        };

        updateDoc(context, newProduct, collection: "departments", doc: id,
            whenDone: () {
          setState(() {
            adminContent = AdminContent.departments;
          });
        });
      }
    }

    void clickDelete(BuildContext context) async {
      if (data.isNotEmpty) {
        deleteDoc(context, "departments/" + id, data, whenDone: () {
          setState(() {
            adminContent = AdminContent.news;
          });
        });
      }
    }

    return ListView(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height / 4,
            child: UploadImageWidget(controllerUrl: controllerPhotoUrl)),
        buildTextForm(controllerFullNameText, hint: 'Название отдела'),
        buildTextForm(controllerDescription,
            hint: 'описание', label: 'описание', height: 180.0),
        buildTextForm(controllerPhotoUrl,
            hint: 'ссылка на фото', label: 'ссылка на фото'),
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
}
