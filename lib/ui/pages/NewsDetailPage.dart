import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:gazpromconnectweb/main.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:gazpromconnectweb/ui/widgets/myImageWidget.dart';
import 'package:gazpromconnectweb/ui/widgets/topTabBarSilver.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

class NewsDetailPage extends StatefulWidget {
  String _title;
  String _description;
  String _image;
  String _date;
  String _likes;
  String _documentID;
  bool _liked;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewsDetailState(
        _documentID, _title, _description, _image, _date, _likes, _liked);
  }

  NewsDetailPage(this._documentID, this._title, this._description, this._image,
      this._date, this._likes, this._liked);
}

class NewsDetailState extends State<NewsDetailPage> {
  Firestore store = firestore();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _title;
  String _description;
  String _image;
  String _date;
  String _likes;
  String _documentID;
  bool _liked;
  Color _color;

  String _userId;
  bool _result;

  NewsDetailState(this._documentID, this._title, this._description, this._image,
      this._date, this._likes, this._liked);

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
        _likes = (int.parse(_likes) - 1).toString();
      } else {
        //не делал лайк
        _result = true;
        store.collection("news").doc(documentID).update(
                data: Map.from({
              "like": FieldValue.arrayUnion(List.unmodifiable([_userId]))
            }));
        _color = Color(0xFFFF0000);
        _likes = (int.parse(_likes) + 1).toString();
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
          buildDateAndLikes(_documentID, _title, _description, _date, _likes)
        ],
        titleMain:  '',
        headers: [""],
        imageHeader:
        MyImageWidget(url: _image),
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
              ]),
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
}
