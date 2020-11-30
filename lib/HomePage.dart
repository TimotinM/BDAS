import 'Options.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}


class _HomePage extends State<HomePage> {
  final CameraPosition _initialLocation =
       CameraPosition(target: LatLng(46.983854, 28.840165), zoom: 15);
  Marker m = Marker(markerId: null, position: LatLng(46.983854, 28.840165));
  GoogleMapController mapController;
  Set<Marker> _markers = HashSet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
        children: <Widget>[
        GoogleMap(
          initialCameraPosition: _initialLocation,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
        ),
       ]
      ),
        floatingActionButton: FloatingActionButton(
           onPressed: (){
             popUpMenu(context);
             },
          elevation: 3,
          backgroundColor: Colors.black,
           child: Icon(Icons.arrow_upward_rounded),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  void popUpMenu(context)
  {
    showModalBottomSheet(context: context, builder: (BuildContext bd){

        return Container(
            height: 270,
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.only(
                 topLeft: Radius.circular(20),
                 topRight: Radius.circular(20),
               )
             ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
             child:Column(
              children: <Widget> [
                SizedBox(height: 30),
                TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.looks_one),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.my_location),
                          onPressed: () {
                          },
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Start address",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    )
                ),
                SizedBox(height: 20),
                TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Final address",
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    )
                ),
                SizedBox(height: 50,),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   FloatingActionButton(
                     onPressed: (){
                       Navigator.of(context).pop();
                     },
                     elevation: 3,
                     backgroundColor: Colors.black,
                     child: Icon(Icons.arrow_downward_rounded),
                   ),
                   SizedBox(width: MediaQuery.of(context).size.width * 0.27),
                   IconButton(
                     icon: Icon(Icons.settings, color: Colors.black, size: 35),
                     onPressed: (){
                       Navigator
                        .push(
                          context,
                         MaterialPageRoute(
                           builder: (context) => Options()
                         )
                       );
                     },
                   ),
                 ],
                ),
              ],
            ),
            )
        );

    }

    );

  }
}

