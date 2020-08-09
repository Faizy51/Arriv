import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final firestoreInstance = Firestore.instance;

  String _name;
  String _email;
  String _empId;
  String _dob;
  String _type = "passenger"; // default for passenger app.

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New User"),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildName(),
                _buildEmail(),
                _buildEmpID(),
                _builDOB(),
                SizedBox(height: 100),
                RaisedButton(
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    _formKey.currentState.save();
                    print(_name + _email + _empId + _dob);

                    //Send to Firebase
                    registerUserInDB();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Creates a User colleciton with mentioned uid.
  void registerUserInDB() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    firestoreInstance.collection("users").document(firebaseUser.uid).setData({
      "name": _name,
      "dob": _dob,
      "email": _email,
      "empId": _empId,
      "type": _type,
    }).then((value) {
      print("successfully created user.");

      firestoreInstance
          .collection("users")
          .document(firebaseUser.uid)
          .collection("wallets")
          .add({
        "balance": 0,
      }).then((value) {
        print("wallet successfully created for user: ${firebaseUser.uid}");
      });

      // Navigate to homescreen
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeScreen(firebaseUser)));
    });
  }

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 25,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildEmpID() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Employee Id'),
      keyboardType: TextInputType.visiblePassword,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Employee Id is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _empId = value;
      },
    );
  }

  Widget _builDOB() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'DOB (dd/mm/yyyy)'),
      keyboardType: TextInputType.datetime,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Date of Birth is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _dob = value;
      },
    );
  }
}
