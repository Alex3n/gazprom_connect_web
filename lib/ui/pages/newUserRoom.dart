import 'package:gazpromconnectweb/main.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:flutter/material.dart';

class NewUserRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     appBar: buildAppBar(context),
     body: Center(
       child: Container(
         padding: EdgeInsets.all(20.0),
         child: Column ( mainAxisAlignment: MainAxisAlignment.spaceAround,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget> [
               Center(
                 child: Container     (
                   child: Text("Здравствуй, " +  userDataBase['name'] + " У вас нет еще своей компанты в нашей школе,  что бы ее создать, нужно пройти полную регистрацию :") ,
                 ),
               ),
                FlatButton ( child: Text ("Я учитель"),  onPressed: ( ) {
                  store.collection("users").doc(getUserId()).update(data: {
                    "role" : "teacher"
                  }).then((value) => Navigator.pushNamed(context, "/editprofile"));
                },),
           FlatButton ( child: Text ("Я ученик"),  onPressed: ( ) {
             store.collection("users").doc(getUserId()).update(data: {
               "role" : "student"
             }).then((value) => Navigator.pushNamed(context, "/editprofile"));
           },)


         ]
         ),
       ),
     ),
   );
  }

}