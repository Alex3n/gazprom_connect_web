import 'package:gazpromconnectweb/ui/widgets/RaisedGradientButton.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as WebFirebase;
import 'package:firebase/firestore.dart' as WebFirestore;

import '../../main.dart';
import '../../main.dart';

//MobFirebaseAuth.FirebaseUser firebaseUser;
WebFirebase.User webFirebaseUser;
//For storing user Profile info
Map<String, dynamic> userProfile = new Map();

//This is the main Firebase auth object
//MobFirebaseAuth.FirebaseAuth mobAuth = MobFirebaseAuth.FirebaseAuth.instance;
WebFirebase.Auth webAuth = WebFirebase.auth();

// For google sign in
//final GoogleSignIn mobGoogleSignIn = GoogleSignIn();
WebFirebase.GoogleAuthProvider webGoogleSignIn;

//CloudFireStore
//MobFirebaseFirestore.Firestore dbFirestore = MobFirebaseFirestore.Firestore.instance;
WebFirestore.Firestore webFirestore = WebFirebase.firestore();

//
//
//
//


class AuthService {
  // constructor


  //Checks if the user has signed in
  Future<bool> checkIsSignedIn() async {
//    if (!kIsWeb) {
//      //For mobile
//      if (mobAuth != null && (await mobGoogleSignIn.isSignedIn())) {
//        firebaseUser = await mobAuth.currentUser();
//
//        if (firebaseUser != null) {
//          //User is already logged in
//          blIsSignedIn = true;
//        } else {
//          blIsSignedIn = false;
//        }
//      } else {
//        blIsSignedIn = false;
//      }
//    } else {
      //For web
      if (webAuth != null) {
        webFirebaseUser = await webAuth.onAuthStateChanged.first;
        print(webFirebaseUser);

        if (webFirebaseUser != null) {
          //User is already logged in
          blIsSignedIn = true;
          userData =  {
            "id": webFirebaseUser.uid,
            "name" : webFirebaseUser.displayName,
            "phoneNumber" :  webFirebaseUser.phoneNumber,
          };
          curUser = userData;
          userFB = webFirebaseUser;



        } else {
          blIsSignedIn = false;
        }
      } else {
        blIsSignedIn = false;
      }
//    }
    return blIsSignedIn;
  }

  //Log in using google
  Future<dynamic> googleSignIn() async {
//    if (!kIsWeb) {
//      //For mobile
//
//      // Step 1
//      GoogleSignInAccount googleUser = await mobGoogleSignIn.signIn();
//
//      // Step 2
//      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//      final AuthCredential credential = GoogleAuthProvider.getCredential(
//        accessToken: googleAuth.accessToken,
//        idToken: googleAuth.idToken,
//      );
//      AuthResult _res = await mobAuth.signInWithCredential(credential);
//      firebaseUser = _res.user;
//
//      return firebaseUser;
//    } else {
      //For web
      var provider = new WebFirebase.GoogleAuthProvider();
      try {
        WebFirebase.UserCredential _userCredential = await webAuth.signInWithPopup(provider);
        webFirebaseUser = _userCredential.user;
      } catch (e) {
        webFirebaseUser = null;
        print("Error in sign in with google: $e");
      }

      return webFirebaseUser;
//    }
  }

  //Gets the userData
  getData() async {
//    if (!kIsWeb) {
//      //For mobile
//      dbFirestore.collection("Master").document(firebaseUser.email).snapshots().listen((snapshot) {
//        if (snapshot.data != null) {
//          userProfile = snapshot.data;
//        }
//      });
//    } else {
      //For Web
      webFirestore.collection("Master").doc(webFirebaseUser.email).onSnapshot.listen((snapshot) {
        if (snapshot.data != null) {
          userProfile = snapshot.data();
        }
      });
//    }
  }

  //Update the data into the database
  Future<bool> setData() async {
    bool blReturn = false;
//    if (!kIsWeb) {
//      //For mobile
//      await dbFirestore
//          .collection('Master')
//          .document(firebaseUser.email)
//          .setData(userProfile, merge: false)
//          .then((onValue) async {
//        blReturn = true;
//      });
//    } else {
      //For Web
//      WebFirestore.SetOptions options;
      await webFirestore.collection('Master').doc(webFirebaseUser.email).set(userProfile).then((onValue) async {
        blReturn = true;
      });
//    }
    return blReturn;
  }

  void signOut() {
//    if (!kIsWeb) {
//      //For mobile
//      mobAuth.signOut();
//    } else {
      //For web
      webAuth.signOut();
//    }
  }
}





class DialogLogin extends StatefulWidget {
  @override
  _DialogLoginState createState() => _DialogLoginState();
}

class _DialogLoginState extends State<DialogLogin> {
  @override
  void initState() {
    //Call the Class constructor and initialize the object


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerSuName = TextEditingController();
    TextEditingController controllerPassword = TextEditingController();
    final  _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar:  buildAppBar(context),
      body: Center(
        child: Container(
          child: new Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
//                Text('Введите имя'),
//                TextFormField(
//                  controller: controllerName,
//                ),
//                Text('Введите фимилию'),
//                TextFormField(
//                  controller: controllerSuName,
//                ),
//                Text('Введите секретное слово'),
//                TextFormField(
//                  controller: controllerPassword,
//                ),


                Container(
                  height: 50,
                  child: Center(
                    child: RaisedButton(
                      child: Text('Google Sign in'),
                      onPressed: () {
                        authService.googleSignIn().then((user) {
                          if (user == null) {
                            //Login failed
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: new Text("Failed to log in!"),
                                  content: new Text(
                                      "Please make sure your Google Account is usable. Also make sure that you have a active internet connection, and try again."),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new FlatButton(
                                      child: new Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            userFB = user;

                            store.collection("users").doc(getUserId()).get().then((value){
                              if (value.data() == null || value.data().isEmpty) {
                                store.collection("users").doc(getUserId()).set({
                                  "name": userFB.displayName,
                                  "phone" : userFB.phoneNumber,
                                  "email":  userFB.email,
                                  "role" : "user"
                                }).then((value) => Navigator.pushNamed(context, '/newuserroom'));

                              } else {
                                userDataBase = value.data();
                                if ( userDataBase["role"] == "teacher") {
                                  Navigator.pushNamed(context, '/roomteacher');
                                } else if (userDataBase["role"] == "student") {
                                  Navigator.pushNamed(context, '/roomstudent');

                                } else {
                                  Navigator.pushNamed(context, '/newuserroom');
                                }
                              }
                            });



                          }
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  child: Center(
                    child: RaisedButton(
                      child: Text('Регистрация'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/registration');
                      },
                    ),
                  ),
                ),                Container(
                  height: 50,
                  width: 300,
                  child: Center(
                    child: myGradientButton( context,
                        btnText: "Применить",
                        funk: () {

                        }),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}

//showDialog(context: context, builder: (BuildContext context){
//return AlertDialog(
//actions: <Widget>[
//Text('Введите свой E-mail'),
//TextFormField(controller: controllerEmail,),
//Text('Введите свой пароль'),
//TextFormField(controller: controllerPassword,),
//],
//);
//});
