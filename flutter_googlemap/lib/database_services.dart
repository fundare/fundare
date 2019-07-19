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

class DatabaseServices{
  Future<Loc3D> getCarLocation() async{
//    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
//    http.Response response = await http.get(url);
//    Map values = jsonDecode(response.body);
    double lati = 33.74;
    double longi = -84.33;
    double alti = 5;
    return Loc3D(lati,longi,alti);
  }
}