import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool mapToggle = false;
  Set<Marker> carMarker = Set<Marker>();
  var currentLocation;
  GoogleMapController mapController;

  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cu'),
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
          SizedBox(height: 5.0),
          FlatButton(
            child: Text('Mark my Car!',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold)),
            color: Colors.transparent,
            onPressed: onAddMarkerButtonPressed,
          )
        ]));
  }

  void onAddMarkerButtonPressed() {
    setState(() {
      Geolocator().getCurrentPosition().then((currloc) {
        setState(() {
          currentLocation = currloc;
          mapToggle = true;
          carMarker.clear();
          carMarker.add(Marker(
            // This marker id can be anything that uniquely identifies each marker.
            markerId: MarkerId('usercar'),
            position:
                LatLng(currentLocation.latitude, currentLocation.longitude),
            infoWindow: InfoWindow(
                title: 'Your Car',
                snippet: 'latitude: ' +
                    currentLocation.latitude.toString() +
                    ',' +
                    'longitude: ' +
                    currentLocation.longitude.toString() +
                    ',' +
                    'altitude: ' +
                    currentLocation.altitude.toString()),
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
