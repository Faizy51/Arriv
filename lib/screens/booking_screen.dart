import 'package:Arriv/models/userDetails.dart';
import 'package:Arriv/views/custom_appBar.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {

final UserDetails user;

BookingScreen(this.user);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(userName: "",),
          ),
        body: Container(
        color: Colors.teal,
        child: Center(
          child: Text("this is me")
        )
      ),
    );
  }
}