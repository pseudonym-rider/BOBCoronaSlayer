import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Body extends StatefulWidget {
  Position position;
  Body(this.position);
  @override
  _BodyState createState() => _BodyState(position);
}

class _BodyState extends State<Body> {
  Position position;
  _BodyState(this.position);
  /*
  void _getUserPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    Position userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() => position = userLocation);
  }
  */
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getUserPosition();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "당신의 현재 위치는"
                  "\nLatitude: ${this.position.latitude.toString()}"
                  "\nLongitude: ${this.position.longitude.toString()}"
                  "\n입니다.",
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    ));
  }
}
