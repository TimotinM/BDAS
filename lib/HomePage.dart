import 'dart:async';
import 'dart:convert';
import 'Driver.dart';
import 'dart:math';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:vector_math/vector_math.dart' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/DriverDialog.dart';
import 'Secret.dart';
import 'Data.dart' as data;
import 'User.dart';
import 'package:collection/collection.dart';

import 'dart:math' show cos, sqrt, asin;

import 'package:untitled/Secret.dart';


class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  var driverList = List<User>();
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  PageController _pageController;

  bool isMapCreated = false;
  var driver = new Driver();
  var oldDrivers = List<dynamic>();
  final Geolocator _geolocator = Geolocator();

  Position _currentPosition;
  Position _precedentPosition;
  String _currentAddress;
  Position destinationCoordinates;
  bool tap = false;
  bool showUser = false;
  bool y = false;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;
  String _previousStartAddress = '';
  String _previousDestinationAddress = '';
  Color color = Colors.black;
  Color notColor = Colors.white;

  Timer timer;
  Icon fab;
  Icon live;
  Icon endAdress;

  Icon fabMap = Icon(
    Icons.lightbulb,
    color: Colors.black,
    size: 56,
  );


  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to close the app?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () => SystemNavigator.pop(),
            /*Navigator.of(context).pop(true)*/
            child: Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }


  Set<Marker> markers = {};
  IOWebSocketChannel channel;


  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  List<LatLng> polylineCoordinatesTracker = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _textField({
    TextEditingController controller,
    String label,
    String hint,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 10.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  double bearing(Position sPosition, Position ePosition){
    double startLat = math.radians(sPosition.latitude);
    double startLong = math.radians(sPosition.longitude);
    double endLat = math.radians(ePosition.latitude);
    double endLong = math.radians(ePosition.longitude);
    double pi = 3.1415926535897932;

    double dLong = endLong - startLong;
    double dPhi = log(tan(endLat/2.0+pi/4.0)/tan(startLat/2.0+pi/4.0));
    if (dLong.abs() > pi)
      if (dLong > 0.0)
        dLong = -(2.0 * pi - dLong);
      else
        dLong = (2.0 * pi + dLong);
    double bearing = (math.degrees(atan2(dLong, dPhi)) + 360.0) % 360.0;
    return bearing;
  }

  _getCurrentLocationLive() async {
    await
    _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position)
    async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 17.0,
                tilt: 45,
                bearing: bearing( _precedentPosition ,position)
            ),
          ),
        );
      });
      setState(() {
        _precedentPosition = position;
      });

      await _getAddressLive();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressLive() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];
      _currentAddress =
      "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
      startAddressController.text = _currentAddress;
      _startAddress = _currentAddress;
    } catch (e) {
      print(e);
    }
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  _getEndAddress(LatLng tapped) async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          tapped.latitude, tapped.longitude);

      Placemark place = p[0];

      setState(() {
        String currentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        destinationAddressController.text = currentAddress;
        _destinationAddress = currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _liveTracker() async {
    try {
      if(!data.isLive)
        _getCurrentLocation();
        await _createPolylinesTrackers(_currentPosition, destinationCoordinates);
        _precedentPosition = _currentPosition;
        if(data.isDriver) {
          data.id.then((i) {
            //sendDriverRoute(i, jsonEncode(polylineCoordinatesTracker));
            channel.sink.add(jsonEncode(<String, dynamic>{
                  'id': i,
                  "points": polylineCoordinatesTracker,
                }));
          });
        }
        return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    data.notification = true;
    data.current_driver = '';
    try {
      // Retrieving placemarks from addresses
      List<Placemark> startPlacemark =
      await _geolocator.placemarkFromAddress(_startAddress);
      List<Placemark> destinationPlacemark =
      await _geolocator.placemarkFromAddress(_destinationAddress);

      if (startPlacemark != null && destinationPlacemark != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        Position startCoordinates = _startAddress == _currentAddress
            ? Position(
            latitude: _currentPosition.latitude,
            longitude: _currentPosition.longitude)
            : startPlacemark[0].position;
        if(!tap)
          destinationCoordinates = destinationPlacemark[0].position;
        tap = false;
        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('A'),
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );


        Marker destinationMarker = Marker(
          markerId: MarkerId('B'),
          position: LatLng(
            destinationCoordinates.latitude,
            destinationCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: _destinationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );



        // Adding the markers to the list
        markers.add(startMarker);
        markers.add(destinationMarker);

        print('START COORDINATES: $startCoordinates');
        print('DESTINATION COORDINATES: $destinationCoordinates');

        //  Position _northeastCoordinates;
        //Position _southwestCoordinates;

        // Calculating to check that
        // southwest coordinate <= northeast coordinate
        double miny = (startCoordinates.latitude <= destinationCoordinates.latitude) ? startCoordinates.latitude : destinationCoordinates.latitude;
        double minx = (startCoordinates.longitude <= destinationCoordinates.longitude) ? startCoordinates.longitude : destinationCoordinates.longitude;
        double maxy = (startCoordinates.latitude <= destinationCoordinates.latitude) ? destinationCoordinates.latitude : startCoordinates.latitude;
        double maxx = (startCoordinates.longitude <= destinationCoordinates.longitude) ? destinationCoordinates.longitude : startCoordinates.longitude;

        Position _southwestCoordinates = Position(
            latitude: miny,
            longitude: minx
        );
        Position _northeastCoordinates =  Position(
            latitude: maxy,
            longitude: maxx
        );

        // Accommodate the two locations within the
        // camera view of the map
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                _northeastCoordinates.latitude,
                _northeastCoordinates.longitude,
              ),
              southwest: LatLng(
                _southwestCoordinates.latitude,
                _southwestCoordinates.longitude,
              ),
            ),
            100.0,
          ),
        );

        // Calculating the distance between the start and the end positions
        // with a straight path, without considering any route
        // double distanceInMeters = await Geolocator().bearingBetween(
        //   startCoordinates.latitude,
        //   startCoordinates.longitude,
        //   destinationCoordinates.latitude,
        //   destinationCoordinates.longitude,
        // );

        await _createPolylines(startCoordinates, destinationCoordinates);

        double totalDistance = 0.0;

        // Calculating the total distance by adding the distance
        // between small segments
        for (int i = 0; i < polylineCoordinates.length - 1; i++) {
          totalDistance += _coordinateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude,
          );
        }

        setState(() {
          _placeDistance = totalDistance.toStringAsFixed(2);
          print('DISTANCE: $_placeDistance km');
        });
        driverList.clear();
        if(data.isDriver) {
          data.id.then((i) {
            //sendDriverRoute(i, jsonEncode(polylineCoordinates));
            channel = IOWebSocketChannel.connect('ws://hikesocket.herokuapp.com/');
            channel.sink.add(jsonEncode(<String, dynamic>{
                  'id': i,
                  "points": polylineCoordinatesTracker,
                }));
          });
        } else {
          Future<List<dynamic>> drivers = getDrivers(startCoordinates.latitude, startCoordinates.longitude, destinationCoordinates.latitude, destinationCoordinates.longitude, data.radius);
          double lat, lng;
          LatLng loc;
          drivers.then((d) {
            print("Drivers LIST:");
            print(d);
            print("--------");
            for(var i = 0; i < d.length; i++){
              Future<User> user = fetchUser(d[i].toString());
              user.then((u) {
                driverList.add(u);
                lat = driverList[i].lat;
                lng = driverList[i].lng;
                loc = LatLng(lat, lng);
                print(loc);
                Marker driverMarker = new Marker(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            DriverDialog(
                                name: driverList[i].name,
                                surname: driverList[i].surname,
                                phone: driverList[i].phone,
                                carModel: driverList[i].carModel,
                                plateNumber: driver.plateNumber)
                    );
                  },
                  markerId: MarkerId('$i'),
                  position: loc,
                    icon: carIcon
              );
                setState(() {
                  showUser = true;
                  markers.add(driverMarker);
                });
              });
            }
          });
        }
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  _createPolylinesTrackers(Position start, Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secret.API_KEY, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinatesTracker.add(LatLng(point.latitude, point.longitude));
      });
    }
  }

  // Create the polylines for showing the route between two places
  _createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secret.API_KEY, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.redAccent,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
  }

  changeMapMode(){
    if(data.dark)
      getJsonFile('assets/Dark.json').then(setMapStyle);
    else
      getJsonFile('assets/Standart.json').then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async{
    return await rootBundle.loadString(path);
  }


  void setMapStyle(String mapStyle){
    mapController.setMapStyle(mapStyle);
  }

  BitmapDescriptor carIcon;
  MapType mapType;


  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    data.loading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) => new AlertDialog(
            title: new Text("Choose the type of user"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new IconButton(
                  icon: Icon(
                    Icons.directions_car,
                    color: Colors.black,
                    size: 46,
                  ),
                  onPressed: () {
                    setState(() {
                      data.isDriver = true;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 25),
                new IconButton(
                  icon: Icon(
                    Icons.directions_walk,
                    color: Colors.black,
                    size: 46,
                  ),
                  onPressed: () {
                    setState(() {
                      data.isDriver = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 12)

              ],
            ),
          )
      );
    });
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(100, 100)),
        'assets/carMarker.png').then((onValue) {
      carIcon = onValue;
    });
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }
  int prevPage;

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    if(showUser){
      Future.delayed(const Duration(seconds: 1), () {
        if(y)
          showUser = false;
        setState(() {

        });
        y = true;
      });
    }

  if(_destinationAddress != '') {
    Future.delayed(const Duration(seconds: 5), () {
      if (data.isDriver) {
        polylineCoordinatesTracker.clear();
        _liveTracker();
    } else {
        markers.removeWhere((Marker m) => (m.markerId != MarkerId('A')) && m.markerId != MarkerId('B'));
        Future<List<dynamic>> drivers = getDrivers(
            _currentPosition.latitude, _currentPosition.longitude,
            destinationCoordinates.latitude, destinationCoordinates.longitude,
            data.radius);
        Function eq = const ListEquality().equals;
        double lat, lng;
        LatLng loc;
        bool foo = true;
        drivers.then((d) {
          if (eq(oldDrivers, d)) {
            print("Old == New");
            foo = false;
          }
          else {
            driverList.clear();
          }
          print("Drivers LIST:");
          print(d);
          print("--------");
          for (var i = 0; i < d.length; i++) {
            Future<User> user = fetchUser(d[i].toString());
            user.then((u) {
              if (foo) {
                driverList.add(u);
              }
              lat = u.lat;
              lng = u.lng;
              if (data.current_driver == d[i].toString()) {
                double distance  = _coordinateDistance(_currentPosition.latitude, _currentPosition.longitude, lat, lng);
                print(distance);
                if(distance < 0.2 && data.notification){
                  _notification(context);
                  data.notification = false;
                }
              }
              loc = LatLng(lat, lng);
              print(loc);
              Marker driverMarker = new Marker(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            DriverDialog(
                                id: driverList[i].id,
                                name: driverList[i].name,
                                surname: driverList[i].surname,
                                phone: driverList[i].phone,
                                carModel: driverList[i].carModel,
                                plateNumber: driver.plateNumber)
                    );
                  },
                  markerId: MarkerId('$i'),
                  position: loc,
                  icon: carIcon
              );
              setState(() {
                oldDrivers = d;
                markers.add(driverMarker);
              });
            });
          }
        });

      }
    });
  }

    if(data.dark){
      color = Colors.white;
      notColor = Colors.black;
    }else{
      color = Colors.black;
      notColor = Colors.white;
    }


    if(data.isLive)
      Future.delayed(const Duration(seconds: 3), () {
        _getCurrentLocationLive();
      });

    if(data.isLive) {
      setState(() {
        live = Icon(
          Icons.near_me_outlined,
          color: notColor,
        );
      });
    }else{
      setState(() {
        live = Icon(
          Icons.near_me_disabled_outlined,
          color: notColor,
        );
      });
    }

    if(data.setMarker) {
      setState(() {
        endAdress = Icon(
          Icons.add_location_rounded,
          color: notColor,
        );
      });
    }else{
      setState(() {
        endAdress = Icon(
          Icons.add_location_outlined,
          color: notColor,
        );
      });
    }

    if(isMapCreated)
      changeMapMode();


    if(data.isSatelit){
      mapType = MapType.hybrid;
    }else{
      mapType = MapType.normal;
    }

    if(data.isDriver) {
      fab = Icon(
        Icons.directions_car,
        color: color,
        size: 56,
      );
    }else{
      fab = Icon(
          Icons.directions_walk,
          color: color,
          size: 56
      );
    }
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: _onWillPop,
        child:Container(
          height: height,
          width: width,
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            key: _scaffoldKey,
            body: Stack(
              children: <Widget>[
                // Map View
                GoogleMap(
                  onTap: data.setMarker? (tapped) {
                    tap = true;
                    Position a = Position(latitude: tapped.latitude, longitude: tapped.longitude);
                    destinationCoordinates = a;
                    if (markers.isNotEmpty) markers.clear();
                    if (polylines.isNotEmpty)
                      polylines.clear();
                    if (polylineCoordinates.isNotEmpty)
                      polylineCoordinates.clear();
                    _placeDistance = null;
                    _getEndAddress(tapped);
                    _calculateDistance();
                    data.setMarker = false;
                    setState(() {

                    });
                  } : null,
                  polylines: Set<Polyline>.of(polylines.values),
                  markers: markers != null ? Set<Marker>.from(markers) : null,
                  initialCameraPosition: _initialLocation,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: mapType,
                  compassEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    setState(() {
                      mapController = controller;
                      isMapCreated = true;
                      changeMapMode();
                    });
                  },
                ),

              Positioned(
                top: 20.0,
                child: Container(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: driverList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _driverInfo(index);
                    },
                  ),
                ),
              ),

                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                      child: ClipOval(
                        child: Material(
                          color: color, // button color
                          child: InkWell(
                            splashColor: Colors.grey[900], // inkwell color
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Icon(Icons.my_location_outlined, color: notColor),
                            ),
                            onTap: () {
                              mapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                      _currentPosition.latitude,
                                      _currentPosition.longitude,
                                    ),
                                    zoom: 15.0,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 80.0),
                      child: ClipOval(
                        child: Material(
                          color: color, // button color
                          child: InkWell(
                            splashColor: Colors.grey[900], // inkwell color
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: live,
                            ),
                            onTap: () {
                              setState(() {
                                data.isLive = !data.isLive;
                              });
                              if(data.isLive)
                                _getCurrentLocationLive();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 150.0),
                      child: ClipOval(
                        child: Material(
                          color: color, // button color
                          child: InkWell(
                            splashColor: Colors.grey[900], // inkwell color
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: endAdress,
                            ),
                            onTap: () {
                              setState(() {
                                data.setMarker = !data.setMarker;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                      child: ClipOval(
                        child: Material(
                          color: Colors.transparent, // button color
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: fab,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                popUpMenu(context);
              },
              elevation: 3,
              backgroundColor: color,
              child: Icon(Icons.arrow_upward_rounded, color: notColor),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          ),
        )
    );

  }

  popUpMenu(context)
  {
    showModalBottomSheet(isScrollControlled: true, context: context, builder: (BuildContext bd ,){
      return new AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Container(

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget> [
                  SizedBox(height: 35),
                  _textField(
                      label: 'Start',
                      hint: 'Choose starting point',
                      prefixIcon: Icon(Icons.looks_one),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.my_location),
                        onPressed: () {
                          startAddressController.text = _currentAddress;
                          _startAddress = _currentAddress;
                        },
                      ),
                      controller: startAddressController,
                      width: MediaQuery.of(context).size.width,
                      locationCallback: (String value) {
                        setState(() {
                          _startAddress = value;

                        });
                      }),
                  SizedBox(height: 10),
                  _textField(
                      label: 'Destination',
                      hint: 'Choose destination',
                      prefixIcon: Icon(Icons.looks_two),
                      controller: destinationAddressController,
                      width: MediaQuery.of(context).size.width,
                      locationCallback: (String value) {
                        setState(() {
                          _destinationAddress = value;
                        });
                      }),
                  SizedBox(height: 50,),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SafeArea(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2.0, bottom: 0.0),
                            child: ClipOval(
                              child: Material(
                                color: Colors.transparent, // button color
                                child: InkWell(
                                  splashColor: Colors.transparent, // inkwell color
                                  child: SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: Icon(Icons.cancel_outlined, color: Colors.black, size: 35),
                                  ),
                                  onTap: () {

                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.24),
                      FloatingActionButton(
                        onPressed: ()
                        {
                            if (_startAddress != '' &&
                                _destinationAddress != '' &&
                                (_previousStartAddress != _startAddress ||
                                    _previousDestinationAddress !=
                                        _destinationAddress)) {
                              setState(() {
                                if (markers.isNotEmpty) markers.clear();
                                if (polylines.isNotEmpty)
                                  polylines.clear();
                                if (polylineCoordinates.isNotEmpty)
                                  polylineCoordinates.clear();
                                _placeDistance = null;
                              });
                              _calculateDistance();
                            }
                            _previousStartAddress = _startAddress;
                            _previousDestinationAddress = _destinationAddress;
                          Navigator.of(context).pop();
                        },
                        elevation: 3,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.arrow_downward_rounded),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.29),
                      IconButton(
                        icon: Icon(Icons.settings, color: Colors.black, size: 35),
                        onPressed: (){
                          Navigator.of(context).pushNamed('/settings')
                              .then((value){
                            setState(() {
                            });
                          });
                        },
                      ),

                    ],
                  ),
                ],
              ),
            ),
          )
      );

    }

    );

  }

  _driverInfo(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
            setState(() {
              mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(driverList[index].lat, driverList[index].lng),
                    zoom: 15.0,
                  ),
                ),
              );
            });
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    height: 125.0,
                    width: 275.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Row(children: [
                          Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)),
                                  image: DecorationImage(
                                      image: AssetImage('assets/profile.jpg'),
                                      fit: BoxFit.cover))),
                          SizedBox(width: 5.0),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driverList[index].name + ' ' + driverList[index].surname,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  driverList[index].phone,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  width: 170.0,
                                  child: Text(
                                    'Red Nissan, 4 seats',
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                )
                              ])
                        ]))))
          ])),
    );
  }

  _notification(context) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
          title: new Text("The driver is less than 200 meters away"),
          actions: [
            TextButton(
                onPressed: (){
                    Navigator.pop(context);
                },
                child: Text('OK')
            )
          ],
        )
    );
}
  void mapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}