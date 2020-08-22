import 'package:Arriv/models/trips.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class BusList extends StatelessWidget {
  const BusList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        scrollDirection: Axis.vertical,
        itemCount: Trip.fetchTrips().length,
        itemBuilder: (context, index) {
          var borderRadius2 = BorderRadius.circular(BUSCELL_BORDER_RADIUS);
          return Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: borderRadius2,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    )),
                height: BUSCELL_HEIGHT,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(BUSCELL_BORDER_RADIUS),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  Trip.fetchTrips()[index].busName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  DateFormat.jm()
                                      .format(Trip.fetchTrips()[index].start),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('   -----------------   '),
                                Text(
                                  DateFormat.jm()
                                      .format(Trip.fetchTrips()[index].end),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 10,
                      thickness: 1,
                      indent: 5,
                      endIndent: 5,
                      color: Colors.grey,
                    ),
                    Container(
                      width: BUSCELL_HEIGHT,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(BUSCELL_BORDER_RADIUS)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ImageIcon(
                            AssetImage('assets/images/tracking.png'),
                            size: 40,
                          ),
                          Text("Track")
                        ],
                      ),
                    )
                  ],
                )),
          );
        });
  }
}
