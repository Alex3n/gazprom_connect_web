import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:gazpromconnectweb/ui/widgets/storageUploadImageWidget.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LectionPage extends StatefulWidget {
  DocumentSnapshot lectionData;
  LectionPage({this.lectionData});
  @override
  _LectionPageState createState() => _LectionPageState();
}

class _LectionPageState extends State<LectionPage> {
  Map<String, dynamic> lectionMap;

  @override
  void initState() {
    lectionMap = widget.lectionData.data();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: buildAppBar(context, valueSnapshot: widget.lectionData), backgroundColor:  Colors.yellowAccent[100],
      body:
      Container(
        padding: EdgeInsets.all(20),
        child: ListView (
          children: <Widget>[
            Container( padding: EdgeInsets.all(10.0),
              child: Text(lectionMap['title'], textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),),
            Container( padding: EdgeInsets.all(5.0),
              child: Text(lectionMap['text'], textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),),
            Center(
              child: Container(padding: EdgeInsets.all(5.0),
               height: 400,
                width: 610,
                child:UploadImageWidget(url: lectionMap['photoURL'], onlyShow: true,
                ),),
            ),
            Container( padding: EdgeInsets.all(5.0),
              child: Text(lectionMap['question'], textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),),




          ],
        ),
      )

      , );
  }
}
