
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/User.dart';
import 'Data.dart' as data;

class Signup extends StatefulWidget {
  @override
  _Signup createState() => _Signup();
}

class _Signup extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _loginController = TextEditingController();
  String loginError = '';

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {

    final emailField = TextFormField(
      obscureText: false,
      style: style,
      controller: _loginController,
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
              if(value.isEmpty){
                return "Pleas enter password";
              }
             return null;
          },
    );
    final repeatPasswordField = TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Confirm Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (String value){
        if(value.isEmpty){
          return "Pleas confirm password";
        }
        if(_passwordController.text != _confirmPasswordController.text){
          return "Passwords do not match";
        }
        return null;
      },
    );
    final singupButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.black,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: (){
          if(_formKey.currentState.validate())
          {
            Future<String> id = createLogin( _loginController.text ,_passwordController.text);
            id.then((i) {
                if (i == '-1') {
                  setState(() {
                    loginError = 'Login already exists';
                  });
              } else {
                setState(() {
                  loginError = '';
                  data.id_s = i;
                });
                print('log');
                Navigator.of(context).pushNamed('/createProfile');
              }
            });
          }
        },
        child: Text("Signup",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final login =  FlatButton(
      onPressed: () {
        Navigator
            .pop(context);
      },
      child: Text(
        "Login",
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
                        Text(loginError,
                          style: TextStyle(color: Colors.red),),
                        SizedBox(height: 12.0),
                        passwordField,
                        SizedBox(height: 25.0,),
                        repeatPasswordField,
                        SizedBox(height: 35.0,),
                        singupButon,
                        SizedBox(height: 15.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?"),
                            login,
                          ],
                        ),
                      ],
                    ),
                 ),
              ),
            ),
          ),
      )
    );
  }
}