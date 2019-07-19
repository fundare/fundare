import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './google_map_services.dart';  // new
import './database_services.dart';  // new
import './poly_services.dart';  // new
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
  Set<Polyline> routePolyline = Set<Polyline>();  // new

//  bool clientsToggle = false;
//  bool resetToggle = false;

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
          title: Text('Map Demo'),
        ),
        body: Column(
            children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height - 280.0,
                        width: double.infinity,
                        child: mapToggle
                            ? GoogleMap(
                            onMapCreated: onMapCreated,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(currentLocation.latitude, currentLocation.longitude),
                                zoom: 10.0),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            markers: carMarker,
                            polylines: routePolyline, // new
                            )
                            : Center(
                            child: Text(
                              'Loading.. Please wait..',
                              style: TextStyle(fontSize: 20.0),
                            ))
                    ),
                    SizedBox(height:5.0),
                    FlatButton(
                        child: Text(
                            'Mark my Car!',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        color: Colors.transparent,
                        onPressed: onAddMarkerButtonPressed,
                    ),
                    SizedBox(height:5.0),  // new below
                    FlatButton(
                        child: Text(
                            'Go to Deck!',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        color: Colors.transparent,
                        onPressed: onGoToDeckButtonPressed,
                    )
              ])
        );
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

  void onGoToDeckButtonPressed() { // new
    setState(() {
      var carLocation;
      Geolocator().getCurrentPosition().then((currloc) { // get user's current location below
        currentLocation = currloc;
        DatabaseServices().getCarLocation().then((carloc) { // get car location from database, has fields latitude, longitude, altitude
          carLocation = carloc;
          GoogleMapsServices().getRouteCoordinates(LatLng(currentLocation.latitude, currentLocation.longitude),
            LatLng(carLocation.latitude, carLocation.longitude)).then((routeString) { // get polyline points from Google
            createRoute(routeString);
            // update carMarker below
            carMarker.clear();
            carMarker.add(Marker(
              markerId: MarkerId('usercar'),
              position: LatLng(carLocation.latitude, carLocation.longitude),
              infoWindow: InfoWindow(
                  title: 'My Car',
                  snippet: 'latitude: '+carLocation.latitude.toString()+','
                      +'longitude: '+carLocation.longitude.toString()+','
                      +'altitude: '+carLocation.altitude.toString()
              ),
              icon: BitmapDescriptor.defaultMarker,
            ));
          });
        });
      });
    });
  }

  void createRoute(String encodedPoly){ // new
    setState(() {
      routePolyline.add(Polyline(polylineId: PolylineId('myRoute'),
          width: 5,
          points: convertToLatLng(decodePoly(encodedPoly)),
          color: Colors.black));
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}