
import 'package:flutter/material.dart';
import 'package:untitled/HomePage.dart';
import 'package:untitled/Signup.dart';
import 'package:untitled/User.dart';
import 'Data.dart' as data;

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _loginController = TextEditingController();

  String loginError = '';


  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
   Future<User> futureUser;
   
 /* @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }*/
  Widget build(BuildContext context) {

    final emailField = TextFormField(
      controller: _loginController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Login",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
       validator: (String value){
        if(value.isEmpty)
          return "Pleas enter login";
        return null;
      },
    );
    final passwordField = TextFormField(
      controller: _passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (String value){
        if(value.isEmpty)
          return "Pleas enter password";
        return null;
      },
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.black,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(_formKey.currentState.validate())
          {

            var login = _loginController.text;
            var password = _passwordController.text;
            data.id = verifyLogin(login, password);
            

            data.id.then((id) {
              if (id != "-1") {
                data.user = fetchUser(id);
                data.id_s = id;
                return Navigator
                .push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapView()
                )
                );
              } else {
                setState((){
                  loginError = 'Login Failed';
                });
              }

            }, onError: (e) {
                print(e);

            });
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final singUp = FlatButton(
        onPressed: () {
          Navigator
              .push(
              context,
              MaterialPageRoute(
                  builder: (context) => Signup()
              )
          );
        },
        child: Text(
        "Signup",
        style: TextStyle(
        color: Colors.blue,
        fontSize: 16,
       ),
      ),
    );

    return Scaffold(
      body: Center(
         child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(35.0),
           child: SingleChildScrollView(
           child: Form(
             key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    singUp,
                  ],
                ),
                    Text(loginError,
                style: TextStyle(color: Colors.red),),
              ],
            ),
          ),
        ),
       ),
      ),
      ),
    );
  }
}