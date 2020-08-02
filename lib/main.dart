import 'package:Arriv/home_screen.dart';
import 'package:Arriv/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future _userFuture;
  FirebaseUser user;
  var regUser;

  @override
  void initState() {
    super.initState();
    // Move this to a method, maybe?
    _userFuture = FirebaseAuth.instance.currentUser().then((value) async {
      user = value;
      print('Printing user after future1: $user');
      await Firestore.instance.collection("users").document(user.uid).get().then((value) {
        regUser = value.data;
        print("everything complete: $regUser");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (regUser == null) {
            // The user hasn't signed up.
            return buildMaterialApp(AuthScreen());
          }
          else {
            return buildMaterialApp(HomeScreen(user));
          }
        }
        
        if (user != null) {
          return buildMaterialApp(HomeScreen(user));
        } else {
          return buildMaterialApp(Scaffold(
          body: Center(child: CircularProgressIndicator())
        ));
        }
      },
    );
  }

  MaterialApp buildMaterialApp(Widget screen) {
    return MaterialApp(
      title: 'Flutter Demo', // Why is this so?
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: screen,
    );
  }
}
