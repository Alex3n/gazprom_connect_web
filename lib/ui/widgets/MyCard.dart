import 'package:flutter/material.dart';

Widget buildMyCard(Widget child) {
  return Card(
    semanticContainer: true,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {
        print('Card tapped.');
      },
      child: Container(
        child: child,
      ),
    ),
  );
}

Widget buildMyCardWithPadding(Widget child, {EdgeInsets padding=const EdgeInsets.fromLTRB(23.0,12.0,23.0,10.0),
  void Function() onTapFunc, BuildContext context, EdgeInsets margin=const EdgeInsets.all(4.0) } ) {
  return Padding(
    padding: margin,

    child:  Card(
      semanticContainer: true,

      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          onTapFunc();
          print('Card tapped.');
        },
        child: Container(
          padding: padding,
          child: child,
        ),
      ),
    ),
  );
}

Widget buildMyCardWithPaddingNotOnTap(Widget child, {EdgeInsets padding=const EdgeInsets.fromLTRB(23.0,12.0,23.0,10.0),
  void Function() onTapFunc, BuildContext context, EdgeInsets margin=const EdgeInsets.all(4.0) } ) {
  return Padding(
    padding: margin,

    child:  Card(
      semanticContainer: true,

      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: Container(
          padding: padding,
          child: child,
        ),
      ),
    ),
  );
}


Widget buildMyCardWithPaddingBlue(Widget child) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Card(
      color: Colors.blueAccent,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Card tapped.');
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(23.0,12.0,23.0,10.0),
          child: child,
        ),
      ),
    ),
  );
}