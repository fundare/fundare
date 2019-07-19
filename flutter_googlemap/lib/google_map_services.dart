import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
const apiKey = "";

class GoogleMapsServices{
  Future<String> getRouteCoordinates(LatLng l1, LatLng l2)async{
//    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=33.8,-84.2&destination=33.74,-84.33&key=$apiKey";
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey&mode=walking";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    print('The value of the input is: '+values["status"]);
    print(values);
    return values["routes"][0]["overview_polyline"]["points"];
  }
}