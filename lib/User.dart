import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final int id;
  final String login;
  final String password;
  final String name;
  final String surname;
  final String phone;
  final Car car;

  User({this.id, this.login, this.password, this.name, this.surname, this.phone, this.car});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      login: json['login'],
      password: json['password'],
      name: json['name'],
      surname: json['surname'],
      phone: json['phone'],
      car: json['car'],
    );
  }

}


class Car{
  final int id;
  final String mark;
  final String model;
  final String year;
  final int seats;

  Car({this.id, this.mark, this.model, this.year, this.seats});
}

Future<User> fetchAlbum() async {
  final response = await http.get('94.237.97.211:8880/api/users/4');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return User.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

