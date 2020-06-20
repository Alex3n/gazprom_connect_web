import 'dart:async';
import 'dart:core';
import 'dart:ui';
import 'package:date_format/date_format.dart';
import 'package:gazpromconnectweb/core/models/CommentModel.dart';
import 'package:gazpromconnectweb/main.dart';
import 'package:gazpromconnectweb/ui/AddCommentPage.dart';
import 'package:gazpromconnectweb/ui/widgets/CommentWidget.dart';
import 'package:gazpromconnectweb/ui/widgets/MyCard.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:gazpromconnectweb/ui/widgets/myImageWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core_web/firebase_core_web.dart';

import 'NewsDetailPage.dart';

class NewsPage extends StatefulWidget {
  NewsPage({Key key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser _user;
  int _likes;
  Color _color;
  Map<String, bool> _result;
  Map<String, String> _eventsInfo;
  Firestore store = firestore();
  bool commentsBlocked = false;
  Map<String, List<CommentModel>> _commModelMap = new Map();

  @override
  void initState() {
    super.initState();
    _getComments();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void getCurrentUser() async {
    _getLikesResult().then((res) {
      setState(() {
        _result = res;
      });
    });
  }

  Future<Map<String, bool>> _getLikesResult() async {
    Map<String, bool> result = new Map();
    store.collection("news").onSnapshot.listen((snapshot) {
      snapshot.docs.forEach((doc) => result.putIfAbsent(
          doc.id, () => List.from(doc.data()['like']).contains(getUserId())
          //     () => debugPrint("likesResultForEach:" + List.from(doc['like']).toString() +" " + _user.uid) as bool
          ));
    });
    //кладем результаты foreach в map, выводим все в виджете
    return result;
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  get iconButtonPressed => null;

  get buttonPressed => null;

  Widget actionWidget(BuildContext context) {
    return new Image(image: FirebaseImage(_eventsInfo["imageAction"]));
  }

  @override
  Widget build(BuildContext context) {
//    расскоментить чтобы работала авторизация
//    if ( _user == null) {
//      return PhoneLogin();
//    }
    return Scaffold(
      body: buildNewsPage(context),
      appBar: buildAppBar(context),
    );
  }

  void _handleTap(String documentID, String title, String description,
      String image, String date, String like,String comments) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailPage(documentID, title, description,
              image, date, like, _result[documentID],
              commentsBlocked: commentsBlocked),
        ),
      );
    });
  }

  void _likeHandleTap(DocumentSnapshot document) async {
    setState(() {
      if (_result[document.id]) {
        // уже сделал лайк
        _result[document.id] = false;
        store.collection("news").doc(document.id).update(
                data: Map.from({
              "like": FieldValue.arrayRemove(List.unmodifiable([getUserId()]))
            }));
        _color = Color(0xFF000000);
        _likes = _likes - 1;
      } else {
        //не делал лайк
        _result[document.id] = true;
        store.collection("news").doc(document.id).update(
                data: Map.from({
              "like": FieldValue.arrayUnion(List.unmodifiable([getUserId()]))
            }));
        _color = Color(0xFFFF0000);
        _likes = _likes + 1;
      }
    });
  }

  Container buildNewsPage(BuildContext context) {
    return new Container(
        child: new ListView(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
          stream: store.collection("news").orderBy("date", "desc").onSnapshot,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                Map<String, bool> result = new Map();
                snapshot.data.docs.forEach((doc) => result.putIfAbsent(doc.id,
                    () => List.from(doc.data()['like']).contains(getUserId())
                    //     () => debugPrint("likesResultForEach:" + List.from(doc['like']).toString() +" " + _user.uid) as bool
                    ));
                _result = result;
                return new ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return GestureDetector(
                        child: buildMYColumn(
                            document: snapshot.data.docs.elementAt(index)),
                        onTap: () {
                          _handleTap(
                              snapshot.data.docs.elementAt(index).id,
                              snapshot.data.docs
                                  .elementAt(index)
                                  .data()['title']
                                  .toString(),
                              snapshot.data.docs
                                  .elementAt(index)
                                  .data()['description']
                                  .toString(),
                              snapshot.data.docs
                                  .elementAt(index)
                                  .data()['image']
                                  .toString(),
                              snapshot.data.docs
                                  .elementAt(index)
                                  .data()['date']
                                  .toString(),
                              List.from(snapshot.data.docs
                                      .elementAt(index)
                                      .data()['like'])
                                  .length
                                  .toString(),
                            snapshot.data.docs
                                .elementAt(index).data()['commentsCount']
                                .toString(),
                              //   snapshot.data.documents.elementAt(index)['like'],
                              );
                        },
                      );
                    });
            }
          },
        )
      ],
    ));
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
                    : MyImageWidget(url: imageUrl)),
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
                new GestureDetector(
                  child: new Icon(Icons.favorite,
                      color: _result[document.id]
                          ? Color(0xFFFF0000)
                          : Theme.of(context).tabBarTheme.unselectedLabelColor,
                      size: 24.0),
                  onTap: () {
                    _likeHandleTap(document);
                  },
                ),
                new GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: new Text(
                      List.from(document.data()['like']).length.toString(),
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: _result[document.id]
                              ? Color(0xFFFF0000)
                              : Theme.of(context)
                                  .tabBarTheme
                                  .unselectedLabelColor,
                          fontWeight: FontWeight.w300,
                          fontFamily: "Roboto"),
                    ),
                  ),
                  onTap: () {},
                ),
                commentsBlocked
                    ? Container()
                    : GestureDetector(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 10.0, 4.0, 10.0),
                          child: new Icon(Icons.insert_comment,
                              color: Theme.of(context)
                                  .tabBarTheme
                                  .unselectedLabelColor,
                              size: 28.0),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddCommentPage(document.id),
                            ),
                          );
                        },
                      ),
                commentsBlocked
                    ? Container()
                    : GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: new Text(
                            _commModelMap[document.id]
                                .length
                                .toString(),
                            style: new TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context)
                                    .tabBarTheme
                                    .unselectedLabelColor,
                                fontWeight: FontWeight.w300,
                                fontFamily: "Roboto"),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddCommentPage(document.id),
                            ),
                          );
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
                )
              ]),          _commModelMap[document.id].isNotEmpty
              ? singleComment(
              context, _commModelMap[document.id].first, true)
              : Container(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentWidget(document.id,
                      commentsBlocked: commentsBlocked),
                ),
              );
            },
            child: Text("Показать все комментарии (" +
                _commModelMap[document.id].length.toString() +
                ")"),
          ),
        ]));
  }
  void _getComments() async {
    Map<String, List<CommentModel>> commModelMap = new Map();
    List<String> docsId = new List();
    final QuerySnapshot result =
    await store.collection("news").get();
    final List<DocumentSnapshot> documents = result.docs;
    setState(() {
      documents.forEach((i) => docsId.add(i.id));
      docsId.forEach((element) {
        List<CommentModel> commList = new List();
        store
            .collection("news")
            .doc(element)
            .collection("comments")
            .onSnapshot
            .listen((snapshot) => snapshot.docs
            .forEach((i) => commList.add(CommentModel.fromMap(i.data()))));
        commModelMap.putIfAbsent(element, () => commList);
      });
      _commModelMap = commModelMap;
    });
  }

}
