import 'package:Arriv/home_screen.dart';
import 'package:Arriv/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          FirebaseUser user = snapshot.data; // this is your user instance
          /// The user is already logged In.
          return buildMaterialApp(HomeScreen(user));
        }
        /// The user is not logged In.
        return buildMaterialApp(AuthScreen());
      },
    );
  }

  MaterialApp buildMaterialApp(Widget screen) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: screen,
    );
  }
}
