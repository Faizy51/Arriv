import 'package:Arriv/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key key,
    @required this.userName,
  }) : super(key: key);

  final String userName;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      //TODO: Display name doesn't work.
      title: Text(
        "Hi ${userName != null ? userName : ""} 👋🏼",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: darkBlue,
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              //Navigate to auth
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AuthScreen()));
            },
            highlightColor: Colors.grey,
            child: Container(
              margin: EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Text(
                "Log Out",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ))
      ],
    );
  }
}