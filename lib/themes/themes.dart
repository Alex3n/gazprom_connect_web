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
    dialogBackgroundColor: Colors.orange,
    brightness: Brightness.light,
    cardColor: boxlight,
    appBarTheme: AppBarTheme(
      color: Colors.white,
    ),
    textTheme: TextTheme(

      caption: TextStyle(color: gazprombankred, fontFamily: "ProximaNovaBold",fontSize: 16 ),
      bodyText1: TextStyle(color: gazprombankazure,
        fontSize: 13,
        fontFamily: "ProximaNovaBold",
      ),
      bodyText2:TextStyle(
          color: gazprombankwhite,
          fontSize: 16,
          fontFamily: "ProximaNovaBold",
          letterSpacing: 1.1),

      headline5: TextStyle(
        fontSize: 14,
        fontFamily: "ProximaNovaBold",
        color: Colors.white,

      ),

      headline6: TextStyle(
          color: maingazprom,
          fontSize: 16,
          fontFamily: "ProximaNovaBold",
          ),

      subtitle2: TextStyle(color: appbartexstlight, fontSize: 20),

      headline4: TextStyle(
          color: noactivsdrawericonlight,
          fontSize: 16,
          fontFamily: "ProximaNovaBold",
          letterSpacing: 1.1),



      // боковое меню  Веделенное текст и цвет иконок
      headline3: TextStyle(
          color: gazprombankazure,
          fontSize: 18,
          fontFamily: "ProximaNovaBold",
          ),
      headline2: TextStyle(
          color: gazprombankclearskies,
          fontSize: 22,
          fontFamily: "ProximaNovaBold",
          ),
      headline1: TextStyle(
        color: gazprombankclearskies,
        fontSize: 28,
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
