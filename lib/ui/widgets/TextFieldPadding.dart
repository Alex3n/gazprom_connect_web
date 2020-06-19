import 'package:flutter/material.dart';

Padding textFieldPadding({
  String fieldname = " ",
  double lr = 0,
  double tb = 5,
  TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: lr, vertical: tb),
    child: new TextField(
      keyboardType: keyboardType,

      controller: controller,
//      focusNode: ,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffCBCBCB),
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff2C98F0),
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
//                prefixIcon: Icon(Icons.search),
//          filled: true,
        fillColor: Colors.white,
        hintText: fieldname,
      ),
      minLines: 1,
      style: new TextStyle(
          fontSize: 16.0,
          height: 1.0,
          color: Color(0xff616161),
//                                color: const Color(0xFF000000),
//          fontWeight: FontWeight.w200,
          fontFamily: "Roboto"),
    ),
  );
}
