
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/ChangePassword.dart';
import 'package:untitled/EditProfile.dart';

class Options extends StatefulWidget {
  @override
  _Options createState() => _Options();
}

class _Options extends State<Options>{
  int sRadius = 10;
  int eRadius = 12;
  @override
  Widget build(BuildContext context){
      final ariaSet = Text(
          "     Set Aria",
           style: TextStyle(
               color: Colors.blue,
               fontSize: 15
           ),
      );

      final account = Text(
        "     Account",
        style: TextStyle(
            color: Colors.blue,
            fontSize: 15
        ),
      );

      final startRadius = Container(
        height: 70,
        color: Colors.white,
        child: ListTile(
          title: Text("Start Radius"),
          subtitle: Text(
              sRadius.toString() + ' m' ,
              style: TextStyle(color: Colors.grey),
          ),
          leading: Icon(IconData(61474, fontFamily: 'MaterialIcons')),
          onTap: () => print(sRadius),
      ),
      );

      final endRadius = Container(
        height: 70,
        color: Colors.white,
        child: ListTile(
          title: Text("End Radius"),
          subtitle: Text(
            eRadius.toString() + ' m',
            style: TextStyle(color: Colors.grey),
          ),
          leading: Icon(IconData(61474, fontFamily: 'MaterialIcons')),

          onTap: () => print(eRadius),
        ),
      );

      final editProfile = Container(
        height: 70,
        color: Colors.white,
        child: ListTile(
          title: Text('Edit Profile'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator
                .push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfile()
                )
            );
          },
          leading: Icon(IconData(57360, fontFamily: 'MaterialIcons')),
        ),
      );
      final changePassword = Container(
        height: 70,
        color: Colors.white,
        child: ListTile(
          title: Text('Change Password'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator
                .push(
                context,
                MaterialPageRoute(
                builder: (context) => ChangePassword()
              )
            );
          },
          leading: Icon(IconData(58625, fontFamily: 'MaterialIcons')),
        ),
      );

      return Scaffold(
        //backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Settings', style: TextStyle(color: Colors.black),),
          leading: FlatButton(
            textColor: Colors.black,
            child: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator
                  .pop(context);
            },
          ),
        ),
        body: Center(
          child: Container(
            color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  account,
                  SizedBox(height: 10),
                  editProfile,
                  SizedBox(height: 2.0),
                  changePassword,
                  SizedBox(height: 10),
                  ariaSet,
                  SizedBox(height: 10),
                  SizedBox(height: 2.0),
                  startRadius,
                  SizedBox(height: 2.0),
                  endRadius,
                ],
              ),
            ),
          ),
      );

  }
}

