import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePassword createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final _currentPasswordController = TextEditingController();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {

    final curentPassword = TextFormField(
      obscureText: true,
      style: style,
      controller: _currentPasswordController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Current password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (String value){
        if(value.isEmpty)
          return "Pleas enter current password";
        return null;
      },
    );

    final newPassword = TextFormField(
      obscureText: true,
      style: style,
      controller: _newPasswordController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "New password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (String value){
        if(value.isEmpty)
          return "Pleas enter current new password";
        return null;
      },
    );

    final confirmNewPassword = TextFormField(
      obscureText: true,
      style: style,
      controller: _confirmNewPasswordController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Confirm new password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (String value){
        if(value.isEmpty){
          return "Pleas confirm password";
        }
        if(_newPasswordController.text != _confirmNewPasswordController.text){
          return "Password do not match";
        }
        return null;
      },
    );

    final saveButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.black,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(_formKey.currentState.validate())
          {
            return Navigator
                .pop(context);;
          }else
          {
            print("Unsuccessful");
          }
        },
        child: Text("Save",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('Change Password', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        leading: FlatButton(
          textColor: Colors.white,
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator
                .pop(context);
          },
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
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
                    curentPassword,
                    SizedBox(height: 25.0),
                    newPassword,
                    SizedBox(height: 25.0,),
                    confirmNewPassword,
                    SizedBox(height: 35.0,),
                    saveButon,
                    SizedBox(
                      height: 15.0,
                 ),
                ],
              ),
            ),
           ),
         ),
        ),
       ),
      ),
    );
  }
}