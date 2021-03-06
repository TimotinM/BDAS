//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/HomePage.dart';
import 'package:untitled/User.dart';
import 'Data.dart' as data;

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _modelController = TextEditingController();
  final _plateController = TextEditingController();

 /* File _image;

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }*/

  _showDialog(TextEditingController controller, String text) async {
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
                setState(() {
                });
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    data.user = fetchUser(data.id_s);
    data.user.then((user) {
      if(_nameController.text.isEmpty){
        setState((){
        _nameController.text = user.name;
        _surnameController.text = user.surname;
        _phoneController.text = user.phone;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Avatar = CircleAvatar(
      radius: 50,
      backgroundImage: AssetImage('assets/profile.jpg'),
    );



    final BasicInformation = Text(
      '   Basic Information',
      textAlign: TextAlign.start,
      style: TextStyle(color: Colors.blue, fontSize: 15),
    );

    final CarInformation = Text(
      '   Car Information',
      textAlign: TextAlign.start,
      style: TextStyle(color: Colors.blue, fontSize: 15),
    );

    final ChangeName = Container(
      height: 70,
      color: Colors.white,
      child: ListTile(
        title: Text('Name'),
        subtitle: Text(
          _nameController.text,
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () {

          _showDialog(_nameController, "Name");
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
          _surnameController.text,
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () {
          _showDialog(_surnameController, "Surname");
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
          _phoneController.text,
          style: TextStyle(color: Colors.grey,),
        ),
        onTap: () {
          _showDialog(_phoneController,  "Phone Number");
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
            _modelController.text,
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () {
          _showDialog(_modelController, "Car Model");
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
          _plateController.text,
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () {
          _showDialog(
              _plateController, "Registration Plate");
        },
        leading: Icon(Icons.wysiwyg),
      )
    );

    return  Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          actions: [
            FlatButton(
              onPressed: () {
                if (_surnameController.text.isEmpty || _nameController.text.isEmpty || _phoneController.text.isEmpty) {
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
                  updateUser(data.id_s, _nameController.text, _surnameController.text, _phoneController.text);

                  return Navigator.pop(context);
                }
              },
              child: Text(
                "Done",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            )
          ],
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Edit Profile',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black)),
          leading: FlatButton(
            textColor: Colors.black,
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10,),
                Center(
                  child:Avatar,
                ),
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

