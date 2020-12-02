import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  int id;
  String login;
  String password;
  String name;
  String surname;
  String phone;
  Car car;

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

  Map<String, dynamic> loginToJson() =>
      {
        'login': login,
        'password': password,
      };
}


class Car{
  int id;
  String mark;
  String model;
  String year;
  int seats;

  Car({this.id, this.mark, this.model, this.year, this.seats});
}

Future<User> fetchUser() async {
  final response = await http.get('hitchhikeapi.heroku.com/api/users/2');

  if (response.statusCode == 200) {

    return User.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

