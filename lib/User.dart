import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
    final String id;
    final String name;
    final String surname;
    final String phone;
    final String car_id;
    final String carModel = 'Nissan';
    final String plateNumber = 'BOS 496';
    final double lat;
    final double lng;

  User({this.id,  this.name, this.surname, this.phone, this.lat, this.lng, this.car_id});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      phone: json['phone'],
      lat: json['lat'],
      lng: json['lng'],
      car_id: json['car_id'],
    );
  }
}


class Car{
  int id;
  String mark;
  String model;
  String year;
  int seats;

  Car({this.id, this.mark, this.model, this.year, this.seats});
}

Future<User> fetchUser(String id) async {
  final response = await http.get('https://hitchhikeapi.herokuapp.com/api/users/' + id);

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<String> createLogin(String login, String password) async {

  final http.Response response = await http.post(
    'https://hitchhikeapi.herokuapp.com/api/login?login=' + login + '&password=' + password);

  if (response.statusCode == 400)
    return '-1';
  return response.body;

}

Future<bool> createUser(String id, String name, String surname, String phone) async {
  final http.Response response = await http.post(
    'https://hitchhikeapi.herokuapp.com/api/users',
    headers: <String , String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'id': id,
      'name': name,
      'surname': surname,
      'phone': phone,
      'car': null,
    }),
  );
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

Future<bool> updateUser(String id, String name, String surname, String phone) async {
  final http.Response response = await http.put(
    'https://hitchhikeapi.herokuapp.com/api/users/' + id,
    headers: <String , String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'surname': surname,
      'phone': phone,
      'car': null,
    }),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<String> verifyLogin(String login, String password) async {
  final http.Response response = await http.get(
    'https://hitchhikeapi.herokuapp.com/api/login?login=' + login + '&password=' + password,
  );
  if (response.statusCode == 200) {
    return response.body;
  }
  if (response.statusCode == 401) {
    return "-1";
  }
}

Future<bool> changePassword(String id, String password, String newPass) async {
  final http.Response response = await http.patch(
    'https://hitchhikeapi.herokuapp.com/api/login?id=' + id + '&password=' + password + '&new=' + newPass,
  );
  if (response.statusCode == 400) {
    return false;
  }
  return true;
}

Future<bool> sendDriverRoute(String id, String json) async {
  final http.Response req = await http.post(
    'https://hitchhikeapi.herokuapp.com/api/drivers?id=' + id,
  headers: <String , String>{
      'Content-Type': 'application/json; charset=UTF-8',
  },
  body: json
  );
}
