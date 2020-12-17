import 'package:BOB_infection_slayer/services/commuication.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';

class InfectionInfoPage extends StatefulWidget {
  static String routeName = "/infection_info";
  @override
  State<StatefulWidget> createState() => InfectionInfoPageState();
}

class InfectionInfoPageState extends State<InfectionInfoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchInfomation();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> infoList = [];
    print('infoList: $infoList');
    print(infoList.length == 0);
    return Scaffold(
        appBar: AppBar(
          title: Text('Infection Infomation'),
          actions: <Widget>[],
        ),
        body: infoList.length != 0
            ? ListView.builder(
                itemCount: infoList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('$index'),
                    ),
                    title: Text('내용: ${infoList[index]}'),
                    subtitle: Text('위치: ${infoList[index]}'),
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
