import 'package:gazpromconnectweb/data.dart';
import 'package:gazpromconnectweb/main.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:gazpromconnectweb/ui/widgets/myDropdownButton.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    store.collection("lections").onSnapshot.listen((event) {
      if (event.docs.isNotEmpty) {
        setState(() {
          lectionsDataDocs = event.docs;
        });
      }
    });
    store
        .collection("users")
        .where("role", "==", "student")
        .onSnapshot
        .listen((event) {
      if (event.docs.isNotEmpty) {
        setState(() {
          studentsAllDataDocs = event.docs;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Container(
            width: 2000,
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(margin: EdgeInsets.all(20.00) , child: Image.network('https://firebasestorage.googleapis.com/v0/b/diplom-ff938.appspot.com/o/main%2Fmainimage.png?alt=media&token=0ccd9c80-78bf-4da7-84ad-ae7ddc6c7ce3')),
                ),
                Expanded(
                  flex: 2,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(40.0),
                          child: Text(
                            "Обучение основам программирования",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Добро пожаловать, дорогой Друг!\n\nМы находимся на сайте, на котором ты можешь познакомиться с основными понятиями программирования.\nА для желающих обучаться в нашем доме есть индивидуальные комнаты.",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.headline5
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Программирование - это удивительная возможность воплотить свои идеи в жизнь.\nГлубоко внутри тебе уже известно, как создавать программы.\nТы Творец, а Код - твой помощник. И вы обязательно подружитесь! \n\nМечтай! Твори! Развивайся! ",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ]),
                ),
              ],
            )));
  }
}
