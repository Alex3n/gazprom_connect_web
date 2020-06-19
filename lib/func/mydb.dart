import 'package:firebase/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

void addNewDoc(
    BuildContext context, String collectionPath, Map<String, Object> data,
    {whenDone()}) {
  showProgress(context);

  store.collection(collectionPath).add(data).then((value) {
    showDialogDB(context, text: "Сохраненно успешно", whenDone: whenDone );
  });
}

void updateDoc(
    BuildContext context,  Map<String, Object> data,
    { String collection , String doc ,whenDone()}) {
  showProgress(context);

  store.collection(collection).doc(doc).update(data: data).then((value) {
    showDialogDB(context, text: "Обновленно успешно", whenDone: whenDone );
  });
}

void deleteDoc(
    BuildContext context, String docPath, Map<String, Object> data,
    {whenDone()}) {
  showProgress(context);
  data["timeAtArhive"] = "${DateTime.now().millisecondsSinceEpoch}";
  var batch = store.batch();
  batch.delete(store.doc(docPath));
  batch.set(store.doc("archive" +docPath),data);
  batch.commit().then((value) {
    showDialogDB(context, text: "Успешно удаленно в архив", whenDone: whenDone );
  });
}

  showDialogDB (BuildContext context, {String text, Function() whenDone}) {
    Navigator.pop(context);
    showDialog(
         context: context,
        builder: (BuildContext context) {
          return RaisedButton(
            onPressed: () {
              Navigator.pop(context);
              whenDone();
            } ,
            child: Center(
              child: Text(text),
            ),
          );
        });
 }
 showProgress(BuildContext context) {
   showDialog(
       context: context,
       builder: (BuildContext context) {
         return Center(
           child: CircularProgressIndicator(),
         );
       });
 }