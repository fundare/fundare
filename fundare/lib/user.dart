import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key, this.uid}) : super(key: key);
  final String uid;
  @override
  _UserPageState createState() => _UserPageState();
}

// StatelessWidget is @immutable => requires final attributes
class _UserPageState extends State<UserPage> {
  var currentLocation;
  bool mapToggle = false;
  Geoflutterfire geo = Geoflutterfire();
  final Firestore _firestore = Firestore.instance;
  FirebaseUser currentUser;
  DateTime now;
  Set<Marker> carMarker = Set<Marker>();
  GoogleMapController mapController;

  void initState() {
    this.getCurrentUser();
    super.initState();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
        //get the time of the
        now = new DateTime.now();
        //store initial location onLoad
        GeoFirePoint userLocation = geo.point(
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude);
        _firestore.collection('user_data').document(currentUser.uid).setData({
          "onLoad_location": [userLocation.data]
        }, merge: true);
        print(userLocation.longitude);
        print(userLocation.latitude);
        print(now);
      });
    });
  }

  void getLocationStoreLocation(now, curr) {
    GeoFirePoint userLocation = geo.point(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude);
    _firestore.collection('user_data').document(currentUser.uid).setData({
      'onMarked_location': [userLocation.data]
    }, merge: true);
    print(userLocation.longitude);
    print(userLocation.latitude);
    print(now);
  }

  /*
  Can maybe use this if geoflutterfire bugs out
  _firestore.collection('user_data').document(currentUser.uid).setData({'locations': {'$now': {GeoPoint: [currloc.latitude, currloc.longitude]}}});
  */

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Car Location'),
        ),
        body: Column(children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height - 280.0,
              width: double.infinity,
              child: mapToggle
                  ? GoogleMap(
                      onMapCreated: onMapCreated,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(currentLocation.latitude,
                              currentLocation.longitude),
                          zoom: 10.0),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      markers: carMarker)
                  : Center(
                      child: Text(
                      'Loading.. Please wait..',
                      style: TextStyle(fontSize: 20.0),
                    ))),
          SizedBox(height: 25.0),
          RaisedButton(
            child: Text('Mark my Car!',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            color: Theme.of(context).primaryColor,
            onPressed: onAddMarkerButtonPressed,
          ),
          RaisedButton(
            child: Text('Logout',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            color: Theme.of(context).primaryColor,
            onPressed: onAddMarkerButtonPressed,
          )
        ]));
  }

  void onAddMarkerButtonPressed() {
    setState(() {
      Geolocator().getCurrentPosition().then((currloc) {
        setState(() {
          currentLocation = currloc;
          now = new DateTime.now();
          getLocationStoreLocation(now, currentLocation);
          mapToggle = true;
          carMarker.clear();
          carMarker.add(Marker(
            // This marker id can be anything that uniquely identifies each marker.
            markerId: MarkerId('usercar'),
            position:
                LatLng(currentLocation.latitude, currentLocation.longitude),
            infoWindow: InfoWindow(
                title: '   Your Car ',
                snippet: '  Latitude: ' +
                    currentLocation.latitude.toString().substring(0, 5) +
                    ',\n' +
                    '  Longitude: ' +
                    currentLocation.longitude.toString().substring(0, 6) +
                    ',\n' +
                    '  Altitude: ' +
                    currentLocation.altitude.toString().substring(0, 6)),
            icon: BitmapDescriptor.defaultMarker,
          ));
        });
      });
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
