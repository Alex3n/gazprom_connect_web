import 'package:date_format/date_format.dart';
import 'package:gazpromconnectweb/data.dart';
import 'package:gazpromconnectweb/main.dart';
import 'package:gazpromconnectweb/ui/pages/IdeasDetailPage.dart';
import 'package:gazpromconnectweb/ui/widgets/MyCard.dart';
import 'package:gazpromconnectweb/ui/widgets/RaisedGradientButton.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:gazpromconnectweb/ui/widgets/myDropdownButton.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazpromconnectweb/ui/widgets/myImageWidget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Container(width: 300,
                child: myGradientButton(context,
                                  funk:() {
                    Navigator.of(context).pushNamed('/ideapage');
                  },
                  btnText: 'Добавить идею',
                ),
              ),
              //                funk:() {
//                  Navigator.of(context).pushNamed('/ideapage');
//                },
//                btnText: Text('Добавить идею'),
              Expanded ( child: Container (
                child:         StreamBuilder<QuerySnapshot>(
                  stream: store.collection("ideas").orderBy("title").onSnapshot,
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
                                  _handleTap(snapshot.data.docs.elementAt(index),
                                     );
                                },
                              );
                            });
                    }
                  },
                )
              ),)

            ])));
  }



  void _handleTap(DocumentSnapshot document) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IdeasDetailPage(document),
        ),
      );
    });
    print("taped");
  }
}

String getDepsNames(List <dynamic> listDep) {
  String names = "";
  if (listDep !=null)
  listDep.forEach((element) {
    names = names + element['title'] + " ";
  });
  if (names == "") names= "все";
  return names;
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
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 1),
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
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
          child: Text(
            document.data()['description'],
            style: new TextStyle(
                fontSize: 14,
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
//                          custicon.MyFlutterApp.news,
                      color: Color(0xFFFF0000),
                      size: 22.0),
                  onTap: () {
                    /*_likeHandleTap(document);*/
                  },
                ),
              ),
              new GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 8, 0),
                  child: new Text(
                    document.data()['like'].toString(),
                    style: new TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFFFF0000),
                        fontWeight: FontWeight.w300,
                        fontFamily: "Roboto"),
                  ),
                ),
                onTap: () {
                  /*_likeHandleTap(document);*/
                },
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: new Text(
                  //todo подгрузка отделов
                  "отделы: " + getDepsNames(document.data()['departments']),
                  style: new TextStyle(
                      fontSize: 14.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: new Text(
                  document.data()['tags'].toString(),
                  style: new TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFFFF0000),
                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto"),
                ),
              ),
            ]),
      ]));
}
