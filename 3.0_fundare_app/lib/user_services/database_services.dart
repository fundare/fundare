import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final Firestore _firestore = Firestore.instance;
FirebaseUser currentUser;
String uid = currentUser.uid;

class Loc3D {
  double latitude;
  double longitude;
  double altitude;

  Loc3D(double lati, double longi, double alti) {
    this.latitude = lati;
    this.longitude = longi;
    this.altitude = alti;
  }
}

class DatabaseServices {
  Loc3D carLocation;
  getCarLocation() {
    _firestore
        .collection('user_data')
        .document(currentUser.uid)
        .collection('onMarked_location')
        .document('carLocation')
        .get()
        .then((result) {
      return carLocation = new Loc3D(result.data['latitude'],
          result.data['longitude'], result.data['altitude']);
    });
  }
}
