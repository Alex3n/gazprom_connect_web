import 'package:flutter/material.dart';

import 'colors.dart';

enum MyThemeKeys {LIGHTFC, DARKFC}

class MyThemes {

  static final ThemeData lightThemeFcNnFonts = ThemeData(

    primaryColor: gazprombankazure,
    primaryColorDark: gazprombankgraymouse,
    backgroundColor: gazprombanksilvermoon,
    accentColor:  gazprombankasphaltorange,
    scaffoldBackgroundColor: gazprombankwhite,
    dialogBackgroundColor: gazprombanviolet,
    brightness: Brightness.light,
    cardColor: boxlight,
    appBarTheme: AppBarTheme(
      color: Colors.white,
    ),
    textTheme: TextTheme(

//     Используется для вспомогательного текста, связанного с изображениями.
      caption: TextStyle(color: gazprombankred, fontFamily: "ProximaNovaBold",fontSize: 16 ),

//     Используется для выделения текста, который в противном случае был бы bodyText2 .
      bodyText1: TextStyle(color: gazprombankazure,
        fontSize: 13,
        fontFamily: "ProximaNovaBold",
      ),
//     Стиль текста по умолчанию для материала .
      bodyText2:TextStyle(
          color: gazprombanknight,
          fontSize: 16,
          fontFamily: "ProximaNovaBold",
          letterSpacing: 1.1),
//    для кнопок
//     button: TextStyle(
//     color: gazprombanknight,
//        fontSize: 15,
//        fontFamily: "ProximaNovaBold",
//
//     ),

//    Используется для основного текста в списках (например, ListTile.title ).
      subtitle1: TextStyle(color: appbartexstlight, fontSize: 20),

//      Для текста со средним акцентом это немного меньше, чем subtitle1 .
      subtitle2: TextStyle(color: appbartexstlight, fontSize: 20),

//        Используется для основного текста в панелях приложений и диалоговых окнах (например, AppBar.title и AlertDialog.title ).
      headline6: TextStyle(
        color: gazprombanknight,
        backgroundColor:gazprombankwhite,
        fontSize: 15,
        fontFamily: "ProximaNovaBold",
      ),
// Используется для большого текста в диалогах (например, месяц и год в диалоге, показанном showDatePicker ).
      headline5: TextStyle(
        fontSize: 15,
        fontFamily: "ProximaNovaBold",
        color: Colors.white,
        decorationColor: gazprombanknight,
      ),

//       Большой текст
      headline4: TextStyle(
          color: noactivsdrawericonlight,
          fontSize: 16,
          fontFamily: "ProximaNovaBold",
          letterSpacing: 1.1),
//      Очень большой текст.
      headline3: TextStyle(
          color: gazprombankazure,
          fontSize: 18,
          fontFamily: "ProximaNovaBold",
          ),
//      очень,очень большой тест
      headline2: TextStyle(
          color: gazprombankclearskies,
          fontSize: 22,
          fontFamily: "ProximaNovaBold",
          ),
//      мега большой текст
      headline1: TextStyle(
        color: gazprombankclearskies,
        fontSize: 40,
        fontFamily: "ProximaNovaBold",
      ),

    ),
    primaryIconTheme: IconThemeData(color: appbartexstlight),
    tabBarTheme: TabBarTheme(
        unselectedLabelStyle: TextStyle(color: noactivbottombariconlight),
        labelStyle: TextStyle(color: activbottombariconlight),
        labelColor: activbottombariconlight,
        unselectedLabelColor: noactivbottombariconlight),
  );

  static final ThemeData darkThemeFcNnFonts = ThemeData(
    primaryColor: mainbackgrounddark,
    primaryColorDark: mainbackgrounddark,
    backgroundColor: mainbackgrounddark,
    accentColor: activbottombaricondark,
    scaffoldBackgroundColor: mainbackgrounddark,
    dialogBackgroundColor: Colors.orange,
    brightness: Brightness.dark,
    cardColor: boxdark,
    appBarTheme: AppBarTheme(
      color: mainbackgrounddark,
    ),
    textTheme: TextTheme(
      caption: TextStyle(color: redSelected, fontFamily: "DinPro",fontSize: 16 ),
      bodyText1: TextStyle(color: greytextbodydark,
        fontSize: 15,
      ),
      bodyText2: TextStyle(color: greytextbodydark,
        fontSize: 15,
        fontFamily: "DinPro",
      ),

      headline5: TextStyle(
        fontFamily: "Helious",
        fontSize: 16,
        color: appbartexstdark,
      ),

      headline6: TextStyle(
          color: maingazprom,
          fontSize: 16,
          fontFamily: "Helious",
         ),

      subtitle2: TextStyle(color: appbartexstdark, fontSize: 16),

      headline4: TextStyle(
          color: noactivsdrawericondark,
          fontSize: 16,
          fontFamily: "Helious",
          letterSpacing: 1.1),
      headline2: TextStyle(
          color: maingazprom,
          fontSize: 22,
          fontFamily: "HeliousBold",
          letterSpacing: 1.1),



      // боковое меню  Веделенное текст и цвет иконок
      headline3: TextStyle(
          color: activbottombariconlight,
          fontSize: 18,
          fontFamily: "Helious",
          letterSpacing: 1.1),
    ),


    primaryIconTheme: IconThemeData(color: appbartexstdark),
    tabBarTheme: TabBarTheme(
        unselectedLabelStyle: TextStyle(color: noactivbottombaricondark),
        labelStyle: TextStyle(color: activbottombariconlight),
        labelColor: activbottombariconlight,
        unselectedLabelColor: noactivbottombaricondark),
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHTFC:
        return lightThemeFcNnFonts;
      case MyThemeKeys.DARKFC:
        return darkThemeFcNnFonts;
      default:
        return lightThemeFcNnFonts;
    }
  }
}
