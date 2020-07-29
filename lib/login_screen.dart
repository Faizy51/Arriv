import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class AuthScreen extends StatelessWidget {
  final phoneNumberController = TextEditingController();
  final otpController = TextEditingController();

  Future registerUser(String mobile, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) {
          Navigator.of(context).pop();

          _auth.signInWithCredential(credential).then((AuthResult result) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(result.user)));
          }).catchError((e) {
            print(e);
          });
        },

        verificationFailed: (AuthException authException) {
          print(authException.message);
        },

        codeSent: (String verificationId, [int forceResendingToken]) {
          //show dialog to take input from the user
          _showOTPDialog(context, () {
            FirebaseAuth auth = FirebaseAuth.instance;
            final smsCode = otpController.text.trim();
            AuthCredential credential = PhoneAuthProvider.getCredential(
                verificationId: verificationId, smsCode: smsCode);
            auth.signInWithCredential(credential).then((AuthResult result) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(result.user)));
            }).catchError((e) {
              print(e);
            });
          });
        },

        codeAutoRetrievalTimeout: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                scale: 0.9,
              ),
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 20),
                child: TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.phone_android,
                      ),
                      hintText: "Enter your Phone number"),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: FlatButton(
                  onPressed: () {
                    // todo: Make firebase request and show alert.
                    FocusScope.of(context).unfocus();
                    String phoneNumber = phoneNumberController.text;
                    if (phoneNumber.isEmpty || phoneNumber.length < 10) {
                      _showAlertDialog(context);
                    } else {
                      registerUser("+91"+phoneNumber, context);
                    }
                  },
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  color: Colors.deepOrange[900],
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 90,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Alerts
  Future<void> _showAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text('Invalid Phone number!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'The phone number you entered is empty, or not valid. Please enter it again.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.blue,
              child: Text('I understand'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showOTPDialog(
      BuildContext context, VoidCallback onPressedClosure) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text('Please enter the OTP here.'),
          backgroundColor: Colors.lightBlue[50],
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('An OTP is sent to your mobile number.'),
                Text('Enter it if not auto-detected.'),
                TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.fiber_pin),
                    hintText: 'Enter code here.',
                  ),
                  validator: (String value) {
                    return value.isEmpty ? 'Please enter the code' : null;
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red[700],
              highlightColor: Colors.white,
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              color: Colors.blue,
              child: Text('Done'),
              onPressed: onPressedClosure
            ),
          ],
        );
      },
    );
  }
}
