import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';

class QRRoadmapPage extends StatefulWidget {
  static String routeName = "/qr_Roadmap";
  @override
  State<StatefulWidget> createState() => QRRoadmapPageState();
}

class QRRoadmapPageState extends State<QRRoadmapPage> {
  List<String> roadmapList = [];
  List<String> timeList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Roadmap'),
        actions: <Widget>[],
      ),
      body: roadmapList.length != 0
      ? ListView.builder(
        itemCount: roadmapList.length,
          itemBuilder: (context, index){
          return ListTile(
            leading: CircleAvatar(child: Text('$index'),),
            title: Text('위치: ${roadmapList[index]}'),
            subtitle: Text('일시: ${timeList[index]}'),
            trailing: Icon(Icons.more_vert),
          );
          })
          : Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      )
    );
  }
}
