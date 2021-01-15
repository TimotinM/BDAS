import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Data.dart' as data;
import 'User.dart';

class DriverDialog extends StatelessWidget {
  String id;
  String name;
  String surname ;
  String phone;
  String carModel;
  String plateNumber;
  DriverDialog({this.id, this.name, this.surname, this.phone, this.carModel, this.plateNumber});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }


  _buildChild(BuildContext context) => Container(
    height: 270,
    decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
        borderRadius:  BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(0), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(29))
    ),
     child: Column(
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child :Row(
              children: <Widget>[
                    Image.asset('assets/profile.jpg', height: 75, width: 75,),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          Text(
                            'Name:                ' + name + ' ' + surname,
                            style: TextStyle(color: Colors.black,),
                            textAlign: TextAlign.left,
                          ),
                        Text(
                            'Phone:               ' + phone,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Car model:        ' + carModel,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Plate number:  ' + plateNumber,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )
              ]
            )
          ),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(0))
          ),
        ),
        SizedBox(height: 24,),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Text(
            'Do you want to travel with this driver?',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,

          ),
        ),
        SizedBox(height: 24,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(
              color: Colors.redAccent,
              onPressed: (){
                Future<bool> boo = declineDriver(data.id_s);
                data.current_driver = '';
                data.notification = true;
                Navigator.of(context).pop();
              },
              child: Text('No'),
              textColor: Colors.white
            ),
            SizedBox(width: 8,),
            RaisedButton(
              onPressed: () {
                Future<bool> boo = acceptDriver(id, data.id_s);
                data.current_driver = id;
                Navigator.of(context).pop(true);
              },
              child: Text('Yes'),
              color: Colors.white,
              textColor: Colors.redAccent
            )
          ],
        ),
        Row(
         mainAxisAlignment: MainAxisAlignment.end,
       children: <Widget>[
         FloatingActionButton(
          onPressed: () => launch('tel://' + phone),
          child: Icon(Icons.phone_in_talk),
          backgroundColor: Colors.green,
          elevation: 0.75,
         ),
         ]
        )

      ],
    ),
  );
}

