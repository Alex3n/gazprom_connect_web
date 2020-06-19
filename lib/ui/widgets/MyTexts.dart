

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget myBodyTextSmall(String text) {
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: new Text(text,
      style: new TextStyle(fontSize:14.0,
//          color: const Color(0xFF000000),
//          fontWeight: FontWeight.w300,
          fontFamily: "Roboto"),
    ),
  );
}

Padding buildBodyTextMedium(String text) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: new Text(text,
      style: new TextStyle(fontSize:16.0,
//          color: const Color(0xFF000000),
//          fontWeight: FontWeight.w400,
          fontFamily: "Roboto"),
    ),
  );
}

Widget buildTextForm(TextEditingController controller,
    {String hint, String label,  Function onTap, double height ,
      bool onlyDigits = false} ) {
  return Container(
    height: height,
    padding: const EdgeInsets.all(8.0),
    child: new TextFormField(
      expands: height!=null,
      maxLines: height!=null? null: 1,
      onTap: onTap,
      controller: controller,
      inputFormatters: onlyDigits? [WhitelistingTextInputFormatter.digitsOnly] : null ,
      decoration: InputDecoration(
        labelText: label,
          border: OutlineInputBorder(),
          hintText: hint),
      style: new TextStyle(

          fontSize: 12.0,
          color: const Color(0xFF000000),
          fontWeight: FontWeight.w200,
          fontFamily: "Roboto"),
    ),
  );
}

