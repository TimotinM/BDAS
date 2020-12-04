import 'package:flutter/material.dart';
import 'package:untitled/MapTest.dart';
import 'package:untitled/User.dart';
import 'Data.dart' as data;

class CreateProfile extends StatefulWidget {
  @override
  _CreateProfile createState() => _CreateProfile();
}

class _CreateProfile extends State<CreateProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _modelController = TextEditingController();
  final _plateController = TextEditingController();

  String userName = "";
  String userSurname = '';
  String phoneNumber = '';
  String carModel = '';
  String registrationPlate = '';


  _showDialog(TextEditingController controller, String variable, String text) async {
    TextInputType keyboard = TextInputType.text;
    if(text == "Phone Number"){
      keyboard = TextInputType.number;
    }
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextFormField(
                keyboardType: keyboard,
                autofocus: true,
                controller: controller,
                decoration: new InputDecoration(labelText: text),
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
  Widget build(BuildContext context) {
    userName = _nameController.text;
    userSurname = _surnameController.text;
    phoneNumber = _phoneController.text;
    carModel = _modelController.text;
    registrationPlate = _plateController.text;

    final Avatar = CircleAvatar(
      radius: 50,
      backgroundImage: AssetImage('assets/profile.jpg'),
    );

    final Name = Text(
      userName + " " + userSurname,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );

    final BasicInformation = Text(
      'Basic Information',
      style: TextStyle(color: Colors.white, fontSize: 15),
    );

    final CarInformation = Text(
      'Car Information',
      style: TextStyle(color: Colors.white, fontSize: 15),
    );

    final ChangeName = Container(
      height: 70,
      color: Colors.white,
      child: ListTile(
        title: Text('Name'),
        subtitle: Text(
          userName,
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () {
          _showDialog(_nameController, userName, "Name");
        },
        leading: Icon(IconData(57438, fontFamily: 'MaterialIcons')),
      ),
    );

    final ChangeSurname = Container(
      height: 70,
      color: Colors.white,
      child: ListTile(
        title: Text('Surname'),
        subtitle: Text(
          userSurname,
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () {
          _showDialog(_surnameController, userSurname, "Surname");
        },
        leading: Icon(IconData(57438, fontFamily: 'MaterialIcons')),
      ),
    );

    final PhoneNumber = Container(
      height: 70,
      color: Colors.white,
      child: ListTile(
        title: Text('Phone Number'),
        subtitle: Text(
          phoneNumber,
          style: TextStyle(color: Colors.grey,),
        ),
        onTap: () {
          _showDialog(_phoneController, phoneNumber, "Phone Number");
        },
        leading: Icon(IconData(57372, fontFamily: 'MaterialIcons')),
      ),
    );

    final CarModel = Container(
      height: 70,
      color: Colors.white,
      child: ListTile(
        title: Text('Car Model'),
        subtitle: Text(
          carModel,
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () {
          _showDialog(_modelController, carModel, "Car Model");
        },
        leading: Icon(IconData(57664, fontFamily: 'MaterialIcons')),
      ),
    );

    final RegistrationPlate = Container(
      height: 70,
      color: Colors.white,
      child: ListTile(
        title: Text('Registration Plate'),
        subtitle: Text(
          registrationPlate,
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () {
          _showDialog(
              _plateController, registrationPlate, "Registration Plate");
        },
        leading: Icon(IconData(58072, fontFamily: 'MaterialIcons')),
      ),
    );

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          actions: [
            FlatButton(
              onPressed: () {
                if (userName.isEmpty || userSurname.isEmpty || phoneNumber.isEmpty) {
                     print("error");
                     showDialog<void>(
                       context: context,
                       barrierDismissible: false, // user must tap button!
                       builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('You have not filled in all the fields in the "Basic Information"'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        }
                     );
                } else {
                  return Navigator
                      .push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>MapView()
                      )
                  );
                }
              },
              child: Text(
                "Done",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            )
          ],
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text('Edit Profile',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
          leading: FlatButton(
            textColor: Colors.white,
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Avatar,
                SizedBox(height: 25),
                // Name,
                //SizedBox(height: 35),
                BasicInformation,
                SizedBox(height: 5),
                ChangeName,
                SizedBox(height: 2),
                ChangeSurname,
                SizedBox(height: 2),
                PhoneNumber,
                SizedBox(height: 5),
                CarInformation,
                SizedBox(height: 5),
                CarModel,
                SizedBox(height: 2),
                RegistrationPlate
              ],
            ),
          ),
        ));
  }
}
