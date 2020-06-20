import 'package:date_format/date_format.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gazpromconnectweb/func/mydb.dart';
import 'package:gazpromconnectweb/themes/colors.dart';
import 'package:gazpromconnectweb/ui/widgets/MyTexts.dart';
import 'package:gazpromconnectweb/ui/widgets/myImageWidget.dart';
import 'package:gazpromconnectweb/ui/widgets/storageUploadImageWidget.dart';

import '../../main.dart';
import 'AdminPanel.dart';

class AdminProjectsPage extends StatefulWidget {
  @override
  _AdminProjectsPageState createState() => _AdminProjectsPageState();
}

class _AdminProjectsPageState extends State<AdminProjectsPage> {
//  List<dynamic> ideas;
//
//  @override
//  void initState() {
//    store.collection("ideas").onSnapshot.listen((event) {
//      event.docs.forEach((element) {
//        ideas.add(element.data()['title']);
//        print(element.data()['title']);
//      });
//    });
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
    switch (adminContent) {
      case AdminContent.addProject:
        return buildAddProject();
      case AdminContent.editProject:
        return buildEditProject(context, data: currentData, id: currentId);
        break;
      default:
        return buildProjectPage(context);
    }
  }

  Widget buildProjectPage(BuildContext context) {
    return ListView(
      children: <Widget>[
        FlatButton(
          onPressed: () {
            currentData = null;
            currentId = null;
            setState(() {
              adminContent = AdminContent.addProject;
            });
          },
          child: Text("Добавить проект"),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: store.collection("projects").onSnapshot,
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
                      print(snapshot.data);
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

  var solutions;
  int solutionPos;
  String solution;

  Widget buildMYColumn({DocumentSnapshot document}) {
    String imageUrl = document.data()['image'];
    solutions = document.data()['solutions'];
    solution = document.data()['solution'];
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
            padding: EdgeInsets.fromLTRB(8, 8, 0, 4),
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
            padding: const EdgeInsets.fromLTRB(8, 4, 0, 6),
            child: Text(
              "Описание: ${document.data()['description']}",
              style: new TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Roboto"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Text(
              solution,
              style: new TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFFFF0000),
                  fontWeight: FontWeight.w300,
                  fontFamily: "Roboto"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Text(
              "состав команды: ${document.data()['employees'].toString()}",
              style: new TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.w300,
                  fontFamily: "Roboto"),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: RaisedButton(

              color: mainappbarblue,
              child: Text("Открыть чат проекта"),
              onPressed: (){},
            ),
          ),
        ]));
  }

  void _handleTap(Map<String, dynamic> data, {String id}) {
    currentData = data;
    currentId = id;
    setState(() {
      adminContent = AdminContent.editProject;
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

  Widget buildEditProject(BuildContext context,
      {Map<String, dynamic> data, String id}) {
    final controllerPhotoUrl = TextEditingController();
    final controllerTitle = TextEditingController();
    final controllerDescription = TextEditingController();

    if (data == null) {
      data = Map();
    }

    if (data.isNotEmpty) {
      controllerTitle.text = data["title"].toString();
      controllerDescription.text = data["description"];
      controllerPhotoUrl.text = data["image"];
    }

    void clickWrite(BuildContext context) async {
      if (controllerTitle.text.isNotEmpty) {
        Map<String, dynamic> newProduct = {
          'title': controllerTitle.text,
          'description': controllerDescription.text,
          'solution': solution,
          'image': controllerPhotoUrl.text,
        };

        addNewDoc(context, "projects", newProduct, whenDone: () {
          setState(() {
            adminContent = AdminContent.projects;
          });
        });
      }
    }

    void clickUpdate(BuildContext context) {
      if (controllerTitle.text.isNotEmpty) {
        Map<String, Object> newProduct = {
          'title': controllerTitle.text,
          'description': controllerDescription.text,
          'solution': solution,
          'image': controllerPhotoUrl.text,
        };

        updateDoc(context, newProduct, collection: "projects", doc: id,
            whenDone: () {
          setState(() {
            adminContent = AdminContent.projects;
          });
        });
      }
    }

    void clickDelete(BuildContext context) async {
      if (data.isNotEmpty) {
        deleteDoc(context, "projects/" + id, data, whenDone: () {
          setState(() {
            adminContent = AdminContent.projects;
          });
        });
      }
    }

    return ListView(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height / 4,
            child: UploadImageWidget(controllerUrl: controllerPhotoUrl)),
        buildTextForm(controllerTitle, hint: 'идея'),
        buildTextForm(controllerDescription,
            hint: 'описание', label: 'описание'),
        _dropDownButton(),
//        buildTextForm(controllerEmployees, hint: 'сотрудники', label: 'сотрудники'),
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

  Widget _dropDownButton() {
    var list = List<String>.from(solutions);
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<String>(
          hint: Text(solution),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          value: solution,
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
            solution = value;
          },
        ));
  }

  Widget buildAddProject() {
    return ListView(
      children: <Widget>[
        Container(
            child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              child: Text("Создание проекта"),
            ),
            _dropDownIdeas(["идея 1", "идея 2"], "Выберите идею"),
            _dropDownIdeas(["решение 1", "решение 2"], "Выберите решение"),
            _dropDownIdeas(["работник 1", "работник 2"], "Пригласить участника"),
            _dropDownIdeas(["работник 1", "работник 2"], "Пригласить участника"),
            _dropDownIdeas(["работник 1", "работник 2"], "Пригласить участника"),
            _dropDownIdeas(["работник 1", "работник 2"], "Пригласить участника"),
            _dropDownIdeas(["работник 1", "работник 2"], "Пригласить участника"),
          ],
        ))
      ],
    );
  }

  Widget _dropDownIdeas(data, String hint) {
    String selected;

    var list = List<String>.from(data);
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        hint: Text(hint),
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
          selected = value;
        },
      ),
    );
  }
}
