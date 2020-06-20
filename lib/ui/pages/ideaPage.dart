import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gazpromconnectweb/func/mydb.dart';
import 'package:gazpromconnectweb/main.dart';
import 'package:gazpromconnectweb/themes/colors.dart';
import 'package:gazpromconnectweb/ui/widgets/MyTexts.dart';
import 'package:gazpromconnectweb/ui/widgets/RaisedGradientButton.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:gazpromconnectweb/ui/widgets/storageUploadImageWidget.dart';

class IdeaPage extends StatefulWidget {
  @override
  _IdeaPageState createState() => _IdeaPageState();
}

class _IdeaPageState extends State<IdeaPage> {
  TextEditingController nameProblemcontroller = TextEditingController();
  TextEditingController overviewProblemcontroller = TextEditingController();
  TextEditingController otdelcontroller = TextEditingController();
  TextEditingController decisionController = TextEditingController();
  final controllerPhotoUrl = TextEditingController();
  List <Map<String, dynamic>> listDeps = [];

  String getDepsNames() {
    String names = "";
    listDeps.forEach((element) {
      names = names + element['title'] + " ";
    });
    return names;
  }

  void chooseDep(Map <String, dynamic> data) {
    setState(() {
      listDeps.add(data);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.all(10),
              width: 1200,
              decoration: BoxDecoration(
                  border: Border.all(color: maingazpromsilver),
                  borderRadius: BorderRadius.all(Radius.circular(40.0))),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('Проблема'),
                  ),
                  buildTextForm(nameProblemcontroller,
                      label: 'Название проблемы'),
                  buildTextForm(overviewProblemcontroller,
                      label: 'описание проблемы'),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('актуально для: ' + (listDeps.isEmpty
                            ? "всех сотрудников"
                            : getDepsNames())),
                        myGradientButton(context,
                          funk: () {
                            showDialog(
                                context: context,
                                builder: (_) =>
                                new Dialog(
                                  child: Container(
                                    width: 800,
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Выберите отдел'),
                                        ),
                                        Expanded(
                                          child: Container(child: StreamBuilder(
                                            stream: store
                                                .collection("departments")
                                                .onSnapshot,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<
                                                    dynamic> snapshot) {
                                              if (snapshot.hasError)
                                                return new Text(
                                                    'Error: ${snapshot.error}');
                                              switch (snapshot
                                                  .connectionState) {
                                                case ConnectionState.waiting:
                                                  return new Text(
                                                      'Загрузка...');
                                                default:
                                                  return new ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      itemCount: snapshot.data
                                                          .docs.length,
                                                      itemBuilder: (
                                                          BuildContext ctx,
                                                          int index) {
                                                        return GestureDetector(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .all(10),
                                                            child: Text(
                                                              snapshot.data.docs
                                                                  .elementAt(
                                                                  index)
                                                                  .data()['title']
                                                                  .toString(),),),
                                                          onTap: () {
                                                            chooseDep(
                                                                snapshot.data
                                                                    .docs
                                                                    .elementAt(
                                                                    index)
                                                                    .data());
                                                            Navigator.pop(context);
                                                          },
                                                        );
                                                      }
                                                  );
                                              }
                                            },),),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                          },
                          btnText: 'Выбрать отдел',
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height / 4,
                      child: UploadImageWidget(controllerUrl: controllerPhotoUrl)),
                  Text('Решение'),
                  buildTextForm(decisionController,
                      label: 'Напишите решение'),
                  Center(
                    child: Container(
                      height: 60,
                      width: 130,
                      child: myGradientButton(context,
                      funk: () {
                        clickWrite(context);
                      },
                      btnText:
                        'Сохранить',
                    ),
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void clickWrite(BuildContext context) async {
    if (nameProblemcontroller.text.isNotEmpty) {
      Map<String, dynamic> newProduct = {
        'title': nameProblemcontroller.text,
        'description': overviewProblemcontroller.text.toString(),
        'image': controllerPhotoUrl.text,
        'departments' : listDeps
      };

      addNewDoc(context, "ideas", newProduct, whenDone: () {
        Navigator.pop(context);
      });
    }
  }
}



