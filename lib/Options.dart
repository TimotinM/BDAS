
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/ChangePassword.dart';
import 'package:untitled/CreateProfile.dart';
import 'package:untitled/Driver.dart';
import 'package:untitled/EditProfile.dart';
import 'package:untitled/Login.dart';
import 'Data.dart' as data;

class Options extends StatefulWidget {
  @override
  _Options createState() => _Options();
}

class _Options extends State<Options>{
  TextEditingController _startRadiusController = TextEditingController();
  TextEditingController _endRadiusController = TextEditingController();

  int startRadius = 50;
  int endRadius = 50;
  Driver userr = Driver();

  _showDialog(TextEditingController controller, String text) async {

    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextFormField(
                keyboardType: TextInputType.number,
                autofocus: true,
                controller: controller,
                decoration: new InputDecoration(labelText: text , hintText: " In meters"),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('SAVE'),
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _endRadiusController.text = '50';
    _startRadiusController.text = '50';
  }

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
              _startRadiusController.text + ' m',
              style: TextStyle(color: Colors.grey),
          ),
          leading: Icon(IconData(61474, fontFamily: 'MaterialIcons')),
          onTap: () {
            _showDialog(_startRadiusController, "Start Radius");
          }
      ),
      );

      final endRadius = Container(
        height: 70,
        color: Colors.white,
        child: ListTile(
          title: Text("End Radius"),
          subtitle: Text(
            _endRadiusController.text + ' m',
            style: TextStyle(color: Colors.grey),
          ),
          leading: Icon(IconData(61474, fontFamily: 'MaterialIcons')),

          onTap: (){
            _showDialog(_endRadiusController, "End Radius");
          },
        ),
      );

      final editProfile = Container(
        height: 70,
        color: Colors.white,
        child: ListTile(
          title: Text('Edit Profile'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.of(context).pushNamed('/editProfile');
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
            Navigator.of(context).pushNamed('/changePassword');
          },
          leading: Icon(IconData(58625, fontFamily: 'MaterialIcons')),
        ),
      );

      final darkMap = Container (
        height: 50,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            SizedBox(width: 16),
            Icon(Icons.lightbulb_outline),
            SizedBox(width: 20),
            Text(
                'Map dark mode',
                 style: TextStyle(fontSize: 17),
            ),
            SizedBox(width: MediaQuery.of(context).size.width*0.35),
            CupertinoSwitch(
                activeColor: Colors.black,
                value: data.dark,
                onChanged: (value){
                  setState(() {
                    data.dark = !data.dark;
                  });
                }
            )
          ],
        ),
      );

      final driver = Container (
        height: 50,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            SizedBox(width: 16),
            Icon(Icons.drive_eta_outlined),
            SizedBox(width: 20),
            Text(
              " I'm a driver       ",
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(width: MediaQuery.of(context).size.width*0.35),
            CupertinoSwitch(
                activeColor: Colors.black,
                value: data.isDriver,
                onChanged: (value){
                  setState(() {
                    data.isDriver = !data.isDriver;
                  });
                }
            )
          ],
        ),
      );

      return Scaffold(
        //backgroundColor: Colors.grey,
        appBar: AppBar(
          actions: [
            FlatButton(
                onPressed: (){
                  data.isLoggedIn = false;
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => Login()),
                      ModalRoute.withName('/')
                  );
                },
                child: Row(
                  children: <Widget>[
                     Text('Logout'),
                     Icon(Icons.logout),
                  ],
                ),
            )
          ],
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
                  SizedBox(height: 20),
                  darkMap,
                  SizedBox(height: 2),
                  driver
                ],
              ),
            ),
          ),
      );

  }
}

