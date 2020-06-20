import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:gazpromconnectweb/core/models/CommentModel.dart';
import 'package:gazpromconnectweb/main.dart';
import 'package:gazpromconnectweb/ui/AddCommentPage.dart';
import 'package:gazpromconnectweb/ui/widgets/CommentWidget.dart';
import 'package:gazpromconnectweb/ui/widgets/RaisedGradientButton.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:gazpromconnectweb/ui/widgets/myImageWidget.dart';
import 'package:gazpromconnectweb/ui/widgets/topTabBarSilver.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

class IdeasDetailPage extends StatefulWidget {
DocumentSnapshot document;
bool commentsBlocked=false;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return IdeasDetailState(document);
  }

  IdeasDetailPage(this.document);
}

class IdeasDetailState extends State<IdeasDetailPage> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  DocumentSnapshot document;
  bool _liked;
  Color _color;

  String _userId;
  bool _result;
  List<CommentModel> _commentList = new List();

  IdeasDetailState(this.document);

  @override
  void initState() {
    _getIdeas(document.id);
    super.initState();

  }

  void _getCurrentUser() async {
    setState(() {

      _userId = getUserId();
    });
  }

  void _handleTap(String documentID) async {
    await _getCurrentUser();
    bool result = await _retrieveItems(documentID);
    setState(() {
      _result = result;
      if (result) {
        // уже сделал лайк
        _result = false;
        store.collection("news").doc(documentID).update(
                data: Map.from({
              "like": FieldValue.arrayRemove(List.unmodifiable([_userId]))
            }));
        _color = Color(0xFF000000);
        document.data()['like'] = (int.parse(document.data()['like']) - 1).toString();
      } else {
        //не делал лайк
        _result = true;
        store.collection("news").doc(documentID).update(
                data: Map.from({
              "like": FieldValue.arrayUnion(List.unmodifiable([_userId]))
            }));
        _color = Color(0xFFFF0000);
        document.data()['like'] = (int.parse(document.data()['like']) + 1).toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_liked != null && _liked) {
      _color = Color(0xFFFF0000);
      _liked = null;
    } else if (_liked != null && !_liked) {
      _color = Color(0xFF000000);
      _liked = null;
    }
    // TODO: implement build
    return Scaffold(
      body: MainCollapsingToolbar(
        pages: <Widget>[
          buildDateAndLikes(document.id, document.data()['title'].toString(), document.data()['description'].toString(), document.data()['date'].toString(), document.data()['like'].toString())
        ],
        titleMain:  '',
        headers: [""],
        imageHeader:
        MyImageWidget(url: document.data()['image']),
        expandleHeight: 500,
      ),

    );
  }

  Column buildDateAndLikes(String documentID, String title, String description,
      String date, String likes) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              title,
              style: new TextStyle(
                  fontSize: 22.0,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Roboto"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              description,
              style: new TextStyle(
                  fontSize: 18.0,
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
                      color: _color, size: 34.0),
                  onTap: () {
                    _handleTap(documentID);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: new Text(
                    likes,
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: _color,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto"),
                  ),
                ),
                widget.commentsBlocked
                    ? Container()
                    : GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        10.0, 10.0, 4.0, 10.0),
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
                widget.commentsBlocked
                    ? Container()
                    : GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: new Text(
                      _commentList.length.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
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
                      DateTime.fromMillisecondsSinceEpoch(int.parse(date)),
                      [dd, '.', mm, '.', yyyy]),
                  style: new TextStyle(
                      fontSize: 20.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto"),
                )
              ]),_commentList.isNotEmpty
              ? singleComment(context, _commentList.first, false)
              : Container(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentWidget(
                    document.id,
                    commentsBlocked: widget.commentsBlocked,
                  ),
                ),
              );
            },
            child: Text("Показать все комментарии (" +
                _commentList.length.toString() +
                ")"),
          ),
          Container(width: 300,
            child: widget.commentsBlocked
                ? Container()
                : Padding(
              padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
              child: myGradientButton(context,
                  btnText: "Оставить комментарий", funk: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCommentPage(document.id),
                      ),
                    );
                  }),
            ),
          )
        ]);
  }

  Future<bool> _retrieveItems(String newsId) async {
    var snapshot = await store.collection("news").doc(newsId).get();
    List<String> likes = List.from(snapshot.data()['like']);
    if (likes.contains(_userId)) {
      return true;
    } else {
      return false;
    }
  }
  Future<List<CommentModel>> _getIdeas(String newsId) async {
    List<CommentModel> commModelList = new List();
    await store
        .collection("ideas")
        .doc(document.id)
        .collection("solutions")
        .onSnapshot
        .listen((snapshot) => snapshot.docs
        .forEach((i) => commModelList.add(CommentModel.fromMap(i.data()))));
    debugPrint("comms:" + commModelList.toString());
    setState(() {
      _commentList = commModelList;
    });
    return commModelList;
  }

}
