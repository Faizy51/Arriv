import 'package:Arriv/constants.dart';
import 'package:Arriv/models/userDetails.dart';
import 'package:Arriv/models/wallet.dart';
import 'package:Arriv/screens/login_screen.dart';
import 'package:Arriv/screens/qr_code_popup.dart';
import 'package:Arriv/views/busList.dart';
import 'package:Arriv/views/custom_appBar.dart';
import 'package:Arriv/views/dashes.dart';
import 'package:Arriv/views/dropDown_textField.dart';
import 'package:Arriv/views/stepper_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final FirebaseUser user;

  HomeScreen(this.user);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserDetails regUser;
  Future userFuture;
  Wallet userWallet;

  var _currentSelectedValue = '';

  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  var _numberOfTickets = 01;

  int _currentTab = 0;
  final List<Widget> _children = [
    Text("Ongoing Trips"),
    Text(""),
  ];
  PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    userFuture = _getRegisteredUser();
    super.initState();
  }

  _getRegisteredUser() async {
    await Firestore.instance
        .collection("users")
        .document(widget.user.uid)
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
        .document(widget.user.uid)
        .collection("wallets")
        .getDocuments()
        .then((querySnapshot) {
      if (querySnapshot.documents.length > 1) {
        AssertionError(
            "User cannot have multiple wallets, but it seems so ${widget.user.uid}");
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

  Widget _buildBackground(BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0), // here the desired height
            child: CustomAppBar(userName: regUser.name,),
          ),
          body: PageStorage(
            bucket: bucket,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      DropDownTextField(
                        textInputController: _fromController,
                        labelText: FROM,
                      ),
                      DropDownTextField(
                        textInputController: _toController,
                        labelText: TO,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(width: 30),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(Icons.directions_walk, size: 30),
                            Text('X'),
                            StepperButton(
                                onPressed: () {
                                  setState(() {
                                    _numberOfTickets > 0
                                        ? _numberOfTickets--
                                        : _numberOfTickets;
                                  });
                                },
                                icon: Icons.remove),
                            Text(_numberOfTickets < 10
                                ? ('0' + _numberOfTickets.toString())
                                : _numberOfTickets.toString()),
                            StepperButton(
                                onPressed: () {
                                  setState(() {
                                    _numberOfTickets++;
                                  });
                                },
                                icon: Icons.add)
                          ],
                        ),
                      ),
                      SizedBox(width: 30),
                      Expanded(
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                color: Colors.black,
                              )),
                          color: darkBlue,
                          textColor: Colors.white,
                          child: Text('Search Busses'),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: 30)
                    ]),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Available Busses running as per schedule.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                  ),
                ),
                Expanded(
                  child: BusList(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: buildBottomAppBar(),
          floatingActionButton: buildFAB(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      );

  FloatingActionButton buildFAB(BuildContext context) {
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
                        width: 70,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
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
                    QRCodeScreen(userWallet: userWallet),
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
        Expanded(child: SizedBox()),
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
              builder: (context, widget) {
                return Stack(
                  children: <Widget>[_buildBackground(context), _buildCard()],
                );
              },
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
