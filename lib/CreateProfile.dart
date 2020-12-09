import 'package:flutter/material.dart';
import 'package:untitled/User.dart';
import 'package:untitled/loading.dart';
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
                setState(() {});
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final Avatar = CircleAvatar(
      radius: 50,
      backgroundImage: AssetImage('assets/profile.jpg'),
    );


    final BasicInformation = Text(
      '   Basic Information',
      style: TextStyle(color: Colors.blue, fontSize: 15),
    );

    final CarInformation = Text(
      '   Car Information',
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
          _showDialog(_surnameController,  "Surname");
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
              _plateController,  "Registration Plate");
        },
        leading: Icon(Icons.wysiwyg),
      ),
    );

    return data.loading? Loading() :Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          actions: [
            FlatButton(
              onPressed: () {
                setState(() {
                  data.loading = true;
                });
                if (_nameController.text.isEmpty || _surnameController.text.isEmpty || _phoneController.text.isEmpty) {
                     setState(() {
                       data.loading = false;
                     });
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
                  createUser(data.id_s, _nameController.text, _surnameController.text, _phoneController.text);
                  return Navigator.of(context).pushNamed('/homePage');
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
          title: Text('Create Profile',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black)),
        ),
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15),
                Center(
                 child: Avatar,
                ),
                SizedBox(height: 25),
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
