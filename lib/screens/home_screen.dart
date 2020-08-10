import 'dart:io';

import 'package:Arriv/constants.dart';
import 'package:Arriv/models/userDetails.dart';
import 'package:Arriv/models/wallet.dart';
import 'package:Arriv/screens/login_screen.dart';
import 'package:Arriv/views/CustomBoxShadow.dart';
import 'package:Arriv/views/dashes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatefulWidget {
  final FirebaseUser user;

  HomeScreen(this.user);

  @override
  _HomeScreenState createState() => _HomeScreenState(user);
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseUser user;
  _HomeScreenState(this.user);
  UserDetails regUser;
  Future userFuture;

  Wallet userWallet;
  double walletBalance = 540;
  int _currentTab = 0;
  final List<Widget> _children = [
    Text("Ongoing Trips"),
    Text(""),
  ];
  PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    // _getWalletDetails();
    userFuture = _getRegisteredUser();
    super.initState();
  }

  _getRegisteredUser() async {
    await Firestore.instance
        .collection("users")
        .document(user.uid)
        .get()
        .then((value) async {
      _parseUser(value);
      await _getWalletDetails();
    });
  }

  _parseUser(DocumentSnapshot userSnapshot) {
    var userdata = userSnapshot.data;
    regUser = UserDetails(userdata["name"], userdata["empId"],
        userdata["email"], userdata["dob"], userdata["type"]);
  }

  _getWalletDetails() async {
    print("Inside");
    await Firestore.instance
        .collection("users")
        .document(user.uid)
        .collection("wallets")
        .getDocuments()
        .then((querySnapshot) {
      if (querySnapshot.documents.length > 1) {
        AssertionError(
            "User cannot have multiple wallets, but it seems so ${user.uid}");
      } else {
        var wallet = querySnapshot.documents.first;
        userWallet = Wallet(wallet.documentID, wallet.data["balance"]);
        print("Balance fetched - ${userWallet.balance}");
      }
    });
  }

  Widget _buildCard() => new Container(
        child: Builder(
          builder: (BuildContext context) {
            return Positioned(
              top: MediaQuery.of(context).padding.top + kToolbarHeight,
              left: 60,
              right: 60,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                child: new Center(
                  child: new Text(
                    // TODO : wallet balance
                    "Your Wallet Balance: \u{20B9}${userWallet != null ? userWallet.balance : ""}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        decoration: TextDecoration.none),
                  ),
                ),
              ),
            );
          },
        ),
      );

  Widget _buildBackground(BuildContext context) => new Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0), // here the desired height
          child: AppBar(
            //TODO: Display name doesn't work.
            centerTitle: false,
            title: Text(
              "Hi ${regUser != null ? regUser.name : "Jason"} 👋🏼",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: darkBlue,
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    //Navigate to auth
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AuthScreen()));
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
          ),
        ),
        body: PageStorage(bucket: bucket, child: Container()),
        bottomNavigationBar: buildBottomAppBar(),
        floatingActionButton: buildFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );

  Container buildQRImage() {
    return Container(
      height: QRCODE_DIMENSION,
      width: QRCODE_DIMENSION,
      // margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            width: 6,
            color: purple,
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            // HACK: solve ios black patch issue
            Platform.isAndroid
                ? CustomBoxShadow(
                    color: Colors.black.withOpacity(1),
                    blurRadius: 5.0,
                    blurStyle: BlurStyle.outer)
                : BoxShadow(
                    color: Colors.white,
                  ),
          ]),
      child: Center(
        child: RepaintBoundary(
          // key: globalKey,
          child: QrImage(
            data: "${userWallet.walletId}",
            size: QRCODE_DIMENSION,
            version: QrVersions.auto,
          ),
        ),
      ),
    );
  }

  FloatingActionButton buildFAB() {
    return FloatingActionButton(
      child: ImageIcon(
        AssetImage('assets/images/qr.png'),
        color: Colors.white,
      ),
      onPressed: () {
        showModalBottomSheet(
            barrierColor: Colors.black.withOpacity(0.8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0))),
            isScrollControlled: true,
            context: context,
            builder: (builder) {
              return Container(
                height: QR_MODAL_HEIGHT,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 150,
                        height: 7,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text("")),
                    SizedBox(height: 15),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Show QR to Conductor ",
                          ),
                          WidgetSpan(
                            child: Image(
                              height: 30,
                              width: 30,
                              image: AssetImage('assets/images/bus-driver.png'),
                              color: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Dashes(),
                    SizedBox(height: 15),
                    buildQRImage(),
                    SizedBox(height: 15),
                    Dashes(),
                  ],
                ),
              );
            });
      },
      backgroundColor: darkBlue,
    );
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
      color: Colors.white,
      notchMargin: 2,
      shape: CircularNotchedRectangle(),
      elevation: 10,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: FlatButton(
              onPressed: () {},
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.home),
                    SizedBox(width: 5),
                    Text(
                      "Home",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )),
        ),
        Expanded(child: SizedBox(width: 50)),
        Expanded(
          child: FlatButton(
              onPressed: () {},
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.card_travel),
                    SizedBox(width: 5),
                    Text(
                      BOTTOM_BAR_TICKETS,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              home: Scaffold(
                body: Stack(
                  children: <Widget>[_buildBackground(context), _buildCard()],
                ),
              ),
            );
          } else {
            print("Awaiting connection-${snapshot.connectionState}");
            return MaterialApp(
                home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ));
          }
        });
  }
}
