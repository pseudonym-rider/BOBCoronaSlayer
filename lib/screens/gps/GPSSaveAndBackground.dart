import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'components/body.dart';

class GPSSaveAndBackground extends StatelessWidget {
  static String routeName = "/GPS";
  Position position;
  GPSSaveAndBackground(this.position);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("동선정보 저장"),
      ),
      body: Body(position),
    );
  }
}