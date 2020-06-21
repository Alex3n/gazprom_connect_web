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

/// Данный класс отвечает за отображение страниц редактора новостей в админ панеле

class AdminNewsPage extends StatefulWidget {
  @override
  _AdminNewsPageState createState() => _AdminNewsPageState();
}

class _AdminNewsPageState extends State<AdminNewsPage> {
  @override
  Widget build(BuildContext context) {
    switch (adminContent) {
      case AdminContent.editNews:
      case AdminContent.addNews:
        return buildAddNews(context, data: currentData, id: currentId);
        break;
      default:
        return buildNewsPage(context);
    }
  }

  Widget buildNewsPage(BuildContext context) {
    return ListView(
      children: <Widget>[
        FlatButton(
          onPressed: () {
            currentData = null;
            currentId = null;
            setState(() {
              adminContent = AdminContent.addNews;
            });
          },
          child: Text("Создать новость"),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: store.collection("news").orderBy("date", "desc").onSnapshot,
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
              document.data()['title'],
              style: new TextStyle(
                  fontSize: 20.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Roboto"),
            ),
          ),
          new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 0, 5),
                  child: new GestureDetector(
                    child: new Icon(Icons.star,
                        color: Color(0xFFFF0000),
                        size: 22.0),
                    onTap: () {},
                  ),
                ),
                new GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 8, 0),
                    child: new Text(
                      List.from(document.data()['like']).length.toString(),
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFFFF0000),
                          fontWeight: FontWeight.w300,
                          fontFamily: "Roboto"),
                    ),
                  ),
                  onTap: () {},
                ),
                new Text(
                  formatDate(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(document.data()['date'])),
                      [dd, '.', mm, '.', yyyy]),
                  style: new TextStyle(
                      fontSize: 14.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto"),
                )
              ]),
        ]));
  }

  void _handleTap(Map<String, dynamic> data, {String id}) {
    currentData = data;
    currentId = id;
    setState(() {
      adminContent = AdminContent.editNews;
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

  Widget buildAddNews(BuildContext context,
      {Map<String, dynamic> data, String id}) {
    final controllerFullNameText = TextEditingController();
    final controllerPushTime = TextEditingController();
    final controllerTime = TextEditingController();
    final controllerDescription = TextEditingController();
    final controllerPhotoUrl = TextEditingController();

    DateTime newsTime = DateTime.now();

    if (data == null) {
      data = Map();
    }

    if (data.isNotEmpty) {
      newsTime = DateTime.fromMillisecondsSinceEpoch(int.parse(data['date']),
          isUtc: true);
      controllerFullNameText.text = data["title"].toString();
      controllerPushTime.text = data["pushTime"].toString();
      controllerTime.text =
          '${newsTime.day} - ${newsTime.month} - ${newsTime.year}  ' +
              '${newsTime.hour} : ${newsTime.minute}';
      controllerDescription.text = data["description"].toString();
      controllerPhotoUrl.text = data["image"];
    }

    void clickWrite(BuildContext context) async {
      if (controllerFullNameText.text.isNotEmpty) {
        Map<String, dynamic> newProduct = {
          'title': controllerFullNameText.text,
          'date': "${newsTime.millisecondsSinceEpoch}",
          'pushTime': newsTime.millisecondsSinceEpoch +
              int.parse((controllerPushTime.text == null ||
                      controllerPushTime.text == "")
                  ? "0"
                  : controllerPushTime.text.toString()),
          'description': controllerDescription.text.toString(),
          'image': controllerPhotoUrl.text,
          'like': <String>{"0"}
        };

        addNewDoc(context, "news", newProduct, whenDone: () {
          setState(() {
            adminContent = AdminContent.news;
          });
        });
      }
    }

    void clickUpdate(BuildContext context) {
      if (controllerFullNameText.text.isNotEmpty) {
        Map<String, Object> newProduct = {
          'title': controllerFullNameText.text,
          'date': "${newsTime.millisecondsSinceEpoch}",
          'pushTime':
              "${newsTime.millisecondsSinceEpoch + int.parse(controllerPushTime.text)}",
          'description': controllerDescription.text,
          'image': controllerPhotoUrl.text,
          'like': <String>{"345"}
        };

        updateDoc(context, newProduct, collection: "news", doc: id,
            whenDone: () {setState(() {
              adminContent = AdminContent.news;
            });
        });
      }
    }

    void clickDelete(BuildContext context) async {
      if (data.isNotEmpty) {
        deleteDoc(context, "news/" + id, data, whenDone: () {
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
        buildTextForm(controllerFullNameText, hint: 'Заголовок'),
        buildTextForm(controllerDescription,
            hint: 'описание', label: 'описание', height: 180.0),
        buildTextForm(controllerPushTime, hint: 'время пуш уведомления'),
        buildTextForm(controllerPhotoUrl,
            hint: 'ссылка на фото', label: 'ссылка на фото'),
        buildTextForm(controllerTime,
            hint: "Текущее время", label: "Время публикации", onTap: () {
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: DateTime(2019, 3, 5),
              maxTime: DateTime(2021, 6, 7), onConfirm: (date) {
            print('confirm $date');
            controllerTime.text =
                '${date.day} - ${date.month} - ${date.year}  ' +
                    '${date.hour} : ${date.minute}';
            newsTime = date;
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
}
