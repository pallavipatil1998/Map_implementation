import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var initPosition= CameraPosition(target: LatLng(21.0289402,75.539315),zoom:15 );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkBeforeGettingLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
      ),
      body: GoogleMap(
        onTap: (location){
          print("Location: ${location.latitude}, ${location.longitude}");
        },
          initialCameraPosition: initPosition,
        markers: {
             Marker(
               infoWindow: InfoWindow(title: "Delhi"),
                 markerId: MarkerId("1"),
               position: LatLng(28.6563, 77.2321),
               onTap: (){
                 print("Tapped on Marker.. Delhi location");
               }
             ),
          Marker(
              infoWindow: InfoWindow(title: "Haryana"),
              markerId: MarkerId("1"),
              position: LatLng(28.408913, 77.317787),
              onTap: (){
                print("Tapped on Marker.. Haryana location");
              }
          ),
          Marker(
              infoWindow: InfoWindow(title: "Jaipur"),
              markerId: MarkerId("1"),
              position: LatLng(26.860830, 75.814807),
              onTap: (){
                print("Tapped on Marker.. Jaipur location");
              }
          ),
          Marker(
              infoWindow: InfoWindow(title: "market"),
              markerId: MarkerId("1"),
              position: LatLng(19.199821, 72.842590),
              onTap: (){
                print("Tapped on Marker.. Delhi location");
              }
          )
        },
      ),
    );
  }


  void checkBeforeGettingLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please Enable Location Services!!')));
    }
    else {
      // GPS is ON
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please allow app to request your current location')));
        } else if (permission == LocationPermission.deniedForever){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You\'ve denied this permission forever, therfore you wont be able to access this particular feature!!')));
        } else {
          //permission granted!!
          // getCurrentLocation();
          getContinuousLocation();
        }



      } else {
        // permission already given
        // getCurrentLocation();
        getContinuousLocation();
      }
    }
  }

  void getCurrentLocation() async{

    var pos = await Geolocator.getCurrentPosition();

    print("Location: ${pos.latitude}, ${pos.longitude}");

  }


  void getContinuousLocation(){

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 10),
    );
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position? position) {
          print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
        });
  }



}
