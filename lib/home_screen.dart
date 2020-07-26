import 'dart:ui';

import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                scale: 1.3,
                ),
              Padding(
              padding: EdgeInsets.fromLTRB(50, 50, 50, 20),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.phone_android,
                  ),
                  hintText: "Phone"
                ),
              ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  scrollPadding: EdgeInsets.symmetric(horizontal: 50),
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock
                    ),
                    hintText: "Password"
                  ),
                ),
              ),
              SizedBox(
                
              ),
              FlatButton(
                onPressed: () {}, 
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(letterSpacing: 2, fontSize: 17),
                  )
                ),
                SizedBox(
                  height: 15,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: FlatButton(
                    onPressed: () {}, 
                    padding: EdgeInsets.symmetric(horizontal: 100),
                    color: Colors.deepOrange[900],
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                Text(
                  "or"
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: FlatButton(
                    onPressed: () {}, 
                    padding: EdgeInsets.symmetric(horizontal: 93),
                    color: Colors.deepOrange[900],
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}