
class Trip {
  String busName;
  DateTime start;
  DateTime end;

  Trip(this.busName,this.start,this.end);

  static List<dynamic> fetchTrips() {
    var trips = [];
    // var newDate = DateFormat.jm().format(dt);

    trips.addAll([
    Trip("Vishal Travels", DateTime.now(), DateTime.now().add(Duration(hours: 1))),
    Trip("Omega Travels", DateTime(0, 0, 0, 8, 30), DateTime(0, 0, 0, 11, 00)),
    Trip("LuLu Travels", DateTime(0, 0, 0, 9, 30), DateTime(0, 0, 0, 12, 00)),
    Trip("Canara Bus", DateTime(0, 0, 0, 10, 30), DateTime(0, 0, 0, 13, 00)),
    Trip("Momo Travels", DateTime(0, 0, 0, 11, 00), DateTime(0, 0, 0, 12, 00)),
    Trip("Amchi Bus", DateTime(0, 0, 0, 13, 30), DateTime(0, 0, 0, 14, 00)),
    Trip("Dolo Bus", DateTime(0, 0, 0, 15, 30), DateTime(0, 0, 0, 17, 30)),
    ]);

    return trips;
  }

}