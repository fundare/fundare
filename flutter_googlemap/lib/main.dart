import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './google_map_services.dart';  // new
import './database_services.dart';  // new
import './poly_services.dart';  // new
import './paint_altitude.dart';  // new
import 'dart:async';
//import 'dart:Number'; // new
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
  bool altitudeToggle = false;
  Set<Marker> carMarker = Set<Marker>();
  Set<Polyline> routePolyline = Set<Polyline>();  // new
  var myGeolocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

  var currentLocation;
//  double carLat, carLong, carAlt;  // get car location from database, has fields latitude, longitude, altitude
  double carLat = 33.7508;
  double carLong = -84.3855;
  double carAlt = 20;
  double arriveDeckAlt;
  double currentAlt;
  GoogleMapController mapController;
  StreamSubscription<double> altitudeStream;

  void initState() {
      super.initState();
      myGeolocator.getCurrentPosition().then((currloc) {
        setState(() {
          currentLocation = currloc;
          mapToggle = true;
        });
      });
  }

  // create stream
  Stream<double> generateAltitudeStream(double originalAltitude) async* {
      double alti = originalAltitude;
      var tempLoc;
      while (true) {  // altitudeToggle
          tempLoc = await myGeolocator.getCurrentPosition();
          if ((tempLoc.altitude - alti).abs() > 0.5 && (tempLoc.altitude - 0.0).abs() > 0.001) {
              // print("${tempLoc.altitude} in stream");
              alti = tempLoc.altitude;
              yield alti;
          }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Fundare'),
        ),
        body: Stack(
            children: <Widget>[
                    Positioned(
                        top: 1,
                        left: 5,
                        width: 400,
                        height: 450,
//                        height: MediaQuery.of(context).size.height - 280.0,
//                        width: double.infinity,
                        child: mapToggle
                            ? GoogleMap(
                              onMapCreated: onMapCreated,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(currentLocation.latitude, currentLocation.longitude),
//                                  target: LatLng(33.752, -84.389),
                                  zoom: 10.0
                              ),
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              markers: carMarker,
                              polylines: routePolyline, // new
//                              cameraTargetBounds: new CameraTargetBounds(new LatLngBounds(
//                                  northeast: LatLng(33.7532, -84.3872), // landale
//                                  southwest: LatLng(33.7506621, -84.391038) //fulton county courthouse
//                              )),
                            )
                            : Center(
                                child: Text(
                                    'Loading.. Please wait..',
                                    style: TextStyle(fontSize: 20.0),
                            ))
                    ),
//                    SizedBox(height:5.0),
                    Positioned(
                        top: 460,
                        left: 110,
                        width: 200,
                        height: 35,
                        child: RaisedButton(
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
                        )
                    ),
//                    SizedBox(height:5.0),  // new below
                    Positioned(
                        top: 507,
                        left: 110,
                        width: 200,
                        height: 35,
                        child: RaisedButton(
                            child: Text(
                                'Go to Deck!',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                            color: Colors.transparent,
//                            onPressed: onGoToDeckButtonPressed,
                        ),
                    ),
//                    SizedBox(height:5.0),  // new new below
                    Positioned(
                        top: 555,
                        left: 110,
                        width: 200,
                        height: 35,
                        child:
                        RaisedButton(
                          child: Text(
                              'Guide in Deck!',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          color: Colors.transparent,
                          onPressed: onGuideInDeckButtonPressed,
                        )
                    ),
                    Positioned(
                        top: 30,
                        left: 30,
                        width: 100,
                        height: 400,
                        child: altitudeToggle
                            ? Center(
                                child: CustomPaint(
                                    size: Size(100, 400),
                                    painter: MyPainter(carAlt, currentAlt, arriveDeckAlt)
                                )
                            )
                            : Center()
                    ),
                    Positioned(
                        top: -30,
                        left: 30,
                        width: 100,
                        height: 100,
                        child: altitudeToggle
                            ? Center(
                                child: Text(
                                    'Altitude',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                    )
                                ))
                            : Center()
                    )
              ])
        );
  }

  void onGuideInDeckButtonPressed() {
//      var locationOptions = LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 1);
      // get car location from database, has fields latitude, longitude, altitude
//      _firestore
//          .collection('user_data')
//          .document(currentUser.uid)
//          .collection('onMarked_location')
//          .document('carLocation')
//          .get()
//          .then((result) {
//              carLat = result.data['latitude'];
//              carLong = result.data['longitude'];
//              carAlt = result.data['altitude'];
              // get user's current location below
              myGeolocator.getCurrentPosition().then((currloc) {
                  currentLocation = currloc;
                  print(currloc.altitude);
                  setState(() {
                      // clear polyline below
                      routePolyline.clear();
                      // update carMarker below
                      carMarker.clear();
                      carMarker.add(Marker(
                          markerId: MarkerId('usercar'),
                          position: LatLng(carLat, carLong),
                          infoWindow: InfoWindow(
                              title: 'My Car',
                              snippet: 'latitude: '+carLat.toString()+','
                                  +'longitude: '+carLong.toString()+','
                                  +'altitude: '+carAlt.toString()
                          ),
                          icon: BitmapDescriptor.defaultMarker,
                      ));
                      // open altitude window below
                      arriveDeckAlt = currentLocation.altitude;
                      currentAlt = currentLocation.altitude;
                      altitudeToggle = true;
                      zoomInMap(currentLocation.latitude, currentLocation.longitude, carLat, carLong);
                  });
                  // listen to stream
                  altitudeStream = generateAltitudeStream(currentLocation.altitude)
                      .listen((double alti) {
                          setState(() {
                              currentAlt = alti;
                          });
//                          print("update alt");
//                          print(alti);
                      });
              });
//          });
  }

  void zoomInMap(double lati1, double longi1, double lati2, double longi2) { // lati1 is user, lati2 is car
    double deltaLati = (lati1-lati2).abs();
    double deltaLongi = (longi1-longi2).abs();
    double zoomFactor = 1;
    mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(lati1+zoomFactor*deltaLati, longi1+zoomFactor*deltaLongi),
            southwest: LatLng(lati1-zoomFactor*deltaLati, longi1-zoomFactor*deltaLongi),
          ),
          50.0, // padding
        )
    );
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
            position: LatLng(currentLocation.latitude, currentLocation.longitude),
            infoWindow: InfoWindow(
              title: 'My Car',
              snippet: 'latitude: '+currentLocation.latitude.toString()+','
              +'longitude: '+currentLocation.longitude.toString()+','
              +'altitude: '+currentLocation.altitude.toString()
            ),
            icon: BitmapDescriptor.defaultMarker,
          ));
        });
      });
    });
  }

  void onGoToDeckButtonPressed() { // new
    setState(() {
//      var carLocation;
      routePolyline.clear();
      myGeolocator.getCurrentPosition().then((currloc) { // get user's current location below
        currentLocation = currloc;
        DatabaseServices().getCarLocation().then((carloc) { // get car location from database, has fields latitude, longitude, altitude
          carLocation = carloc;
          zoomInMap(currentLocation.latitude, currentLocation.longitude, carLocation.latitude, carLocation.longitude);
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
      routePolyline.clear();
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