import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazpromconnectweb/themes/custom_theme.dart';
import 'package:gazpromconnectweb/themes/themes.dart';
import 'package:gazpromconnectweb/ui/pages/AdminPanel.dart';
import 'package:gazpromconnectweb/ui/pages/Autorization.dart';

import 'package:gazpromconnectweb/ui/pages/EditProfilePage.dart';
import 'package:gazpromconnectweb/ui/pages/Home.dart';
import 'package:gazpromconnectweb/ui/pages/NewsPage.dart';
import 'package:gazpromconnectweb/ui/pages/ProfilePage.dart';
import 'package:gazpromconnectweb/ui/pages/ideaPage.dart';
import 'package:gazpromconnectweb/ui/pages/registration.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

AuthService authService;
bool blIsSignedIn = false;
Firestore store = firestore();
bool isDarkTheme = false;

Map <String, Object> userdata;


SharedPreferences prefs;
Map <String, dynamic> curUser;
Map <String, dynamic> userData;
Map <String, dynamic> userDataBase;
User userFB;

bool isReleaseVersion = false; //ПОСТАВИТЬ true перед деплоем, проверять всегда
String debagUserID = "CBVLsIYlJpX1RwElGvbuiUmRP6s1";
String getUserId () {
  return isReleaseVersion? userFB.uid: debagUserID;
}



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance().then((value) {
    prefs = value;
    if (prefs != null && prefs.get("isDarkTeme")!= null) {
      isDarkTheme = prefs.get("isDarkTeme");
    }
    if  (prefs != null && prefs.get("userDataList")!= null)
    {
      List <dynamic> userDataList = prefs.get("userDataList");
      curUser = {
        "id": userDataList[0],
        "api_token":     userDataList[1],
        "name" : userDataList[2],
        "phoneNumber" : userDataList[3],
        "role" : userDataList[4],
      };
      userData = curUser;
    } else {
    }
  });

  isDarkTheme = isDarkTheme == null? false : isDarkTheme;
  initializeDateFormatting().then((_) => runApp(
    CustomTheme(
      initialThemeKey: isDarkTheme? MyThemeKeys.DARKFC : MyThemeKeys.LIGHTFC,
      child: MyApp(),
    ),
  ));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(BuildContext context) => Home(),
        '/mainscreen':(BuildContext context) => NewsPage(),
        '/dialoglogin':(BuildContext context) => DialogLogin(),
        '/registration':(BuildContext context) => Registration(),
        '/profile':(BuildContext context) => ProfilePage(),
        '/editprofile':(BuildContext context) => EditProfilePage(),
        '/adminpanel': (BuildContext context) => AdminPanel(),
        '/ideapage':(BuildContext context) => IdeaPage(),
      },
      theme: CustomTheme.of(context),
    );
  }
}