import 'package:date_format/date_format.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gazpromconnectweb/main.dart';
import 'package:gazpromconnectweb/ui/pages/NewsPage.dart';
import 'package:gazpromconnectweb/ui/widgets/CommentWidget.dart';
import 'package:gazpromconnectweb/ui/widgets/RaisedGradientButton.dart';
import 'package:gazpromconnectweb/ui/widgets/TextFieldPadding.dart';

/// Данный класс отвечает за отображение страницы добавления комментария

class AddCommentPage extends StatefulWidget {
  String newsId;
  String commentId;
  AddCommentPage (this.newsId, {this.commentId});

  @override
  _AddCommentPageState createState() => _AddCommentPageState(newsId, commentId: commentId);
}

class _AddCommentPageState extends State<AddCommentPage> {
  String newsId;
  String commentId;
  _AddCommentPageState (this.newsId, {this.commentId});

  TextEditingController commentController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  FirebaseUser user;
  Map dBuser;
  String photoURL;

  bool isNameValid = false;
  bool isEmailValid = false;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  Widget commentColumn(BuildContext context) {
    return Column(
      children: <Widget>[
        textFieldComment(fieldname: "Оставьте комментарий", controller: commentController),
        new Padding(
            padding: EdgeInsets.all(24),
            child: myGradientButton( context,
                btnText: "Написать",
                funk: () {
                  setState(() {
                    addComment(commentController.text, newsId);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentWidget(newsId),
                      ),
                            (Route<dynamic> route) => false
                    );
                  });
                })
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body:commentColumn(context),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text("Напишите комментарий",
            style: Theme.of(context).textTheme.headline6,
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsPage()),
              );
            },
          ),
      )
    );
  }

  void addComment(String comment, String newsId) async {
    String avatar =userDataBase["photoURL"] != null ? userDataBase["photoURL"] : "";
    String name = userDataBase["name"] != null ? userDataBase["name"] : "";
    String id = getUserId();
    commentId == null ? await store
        .collection("news")
        .doc(newsId)
        .collection("comments")

        .add(Map.from({
      "comment" : comment,
      "author" : name,
      "authorId" : id,
      "avatar" : avatar,
      "date" : formatDate(DateTime.now(), [  hh, ':', mm, ':', ss, ' ', dd, '.', mm, '.', yyyy]),
        }
      )
    ) : await store
        .collection("news")
        .doc(newsId)
        .collection("comments")
        .doc(commentId)
        .update(data:Map.from({
      "subcomms" : FieldValue.arrayUnion(List.unmodifiable([Map.from({
        "comment" : comment,
        "author" : name,
        "authorId" : id,
        "avatar" : avatar,
        "parent" : commentId,
        "id" : DateTime.now().millisecondsSinceEpoch.toString(),
        "date" : formatDate(DateTime.now(), [  hh, ':', mm, ':', ss, ' ', dd, '.', mm, '.', yyyy]
                      ),
                    }
                )
              ]
            )
          )
        })
    );
  }

  void buttonPressed() {}
}
