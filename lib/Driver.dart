import 'dart:convert';

import "User.dart";
import 'package:http/http.dart' as http;

class Driver {
  String name;
  String surname;
  String phone = '0601234567';
  String carModel = 'Lada';
  String plateNumber = 'AFG 265';
  double Lat;
  double Lon = 28.0;
  int seats = 4;
  String id = '1';

  Driver({this.name, this.surname, this.Lat});

}


Future<List<dynamic>> getDrivers(double s_lat, double s_lng, double e_lat, double e_lng, double radius) async {
  final response = await http.post('https://hitchhikeapi.herokuapp.com/api/passengers',
  headers: <String , String>{
      'Content-Type': 'application/json; charset=UTF-8',
  },
  body: jsonEncode(<String, double>{
      'start_lat': s_lat,
      'start_lng': s_lng,
      'end_lat': e_lat,
      'end_lng': e_lng,
      'start_r': radius,
      'end_r': radius
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }

}

Future<bool> cancelRoute(String id) async {
  final http.Response response = await http.delete(
    'https://hitchhikeapi.herokuapp.com/api/drivers?id=' + id ,
  );
  if (response.statusCode == 400) {
    return false;
  }
  return true;
}

Future<List<String>> checkPassangers(String id) async {
  final http.Response response = await http.get(
    'https://hitchhikeapi.herokuapp.com/api/drivers?id=' + id ,
  );
  if (response.statusCode != 204) {
    return jsonDecode(response.body);
  }
  return null;
}