import 'package:flutter/material.dart';
import 'package:untitled/ChangePassword.dart';
import 'package:untitled/CreateProfile.dart';
import 'package:untitled/EditProfile.dart';
import 'package:untitled/HomePage.dart';
import 'package:untitled/Login.dart';
import 'package:untitled/Options.dart';
import 'package:untitled/Signup.dart';
import 'package:untitled/route_generator.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){

    switch(settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Login());
      case '/signup':
        return MaterialPageRoute(builder: (_) => Signup());
      case '/createProfile':
        return MaterialPageRoute(builder: (_) => CreateProfile());
      case '/homePage':
        return MaterialPageRoute(builder: (_) => MapView());
      case '/settings':
        return MaterialPageRoute(builder: (_) => Options());
      case '/editProfile':
        return MaterialPageRoute(builder: (_) => EditProfile());
      case '/changePassword':
        return MaterialPageRoute(builder: (_) => ChangePassword());
      default:
        return MaterialPageRoute(builder: (_) => Login());;
    }
  }
}