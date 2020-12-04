import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _modelController = TextEditingController();
  final _plateController = TextEditingController();

  String userName = "Ion";
  String userSurname = "Noi";
  String phoneNumber = "060123456";
  @override
  Widget build(BuildContext context) {
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

    final ChangeName = Container(
      height: 70,
      color: Colors.white,
      child: ListTile(
        title: Text('Edit Name'),
        subtitle: Text(
          userName,
          style: TextStyle(color: Colors.grey),
        ),
        trailing: Icon(Icons.keyboard_arrow_down),
        onTap: () {},
        leading: Icon(IconData(57438, fontFamily: 'MaterialIcons')),
      ),
    );

    final ChangeSurname = Container(
      height: 70,
      color: Colors.white,
      child: ListTile(
        title: Text('Edit Surname'),
        subtitle: Text(
          userSurname,
          style: TextStyle(color: Colors.grey),
        ),
        trailing: Icon(Icons.keyboard_arrow_down),
        onTap: () {},
        leading: Icon(IconData(57438, fontFamily: 'MaterialIcons')),
      ),
    );

    final PhoneNumber = Container(
      height: 70,
      color: Colors.white,
      child: ListTile(
        title: Text('Edit Phone Number'),
        subtitle: Text(
          phoneNumber,
          style: TextStyle(color: Colors.grey),
        ),
        trailing: Icon(Icons.keyboard_arrow_down),
        onTap: () {},
        leading: Icon(IconData(57372, fontFamily: 'MaterialIcons')),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            onPressed: () {
              print("Done");
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
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
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
      backgroundColor: Colors.grey,
      body: Center(
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
          ],
        ),
      ),
    );
  }
}
