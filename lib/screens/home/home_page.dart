import 'dart:io';
import 'package:flutter/material.dart';
import 'components/body.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'griddashboard.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'components/notification.dart' as notif;

class Home extends StatefulWidget {
  static String routeName = "/home";
  final String ID;
  Home(this.ID);
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("정말 종료하시겠습니까?"),
            actions: <Widget>[
              FlatButton(
                child: Text("네"),
                onPressed: () => exit(0),
              ),
              FlatButton(
                child: Text("아니오"),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
        ) ??
        false;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    Workmanager.registerPeriodicTask(
      "1",
      "BOB corona slayer가 실행중입니다.",
      frequency: Duration(minutes: 5),
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
            child: Scaffold(
              backgroundColor: Color(0xffc8e6c9),
              body: Column(
                children: <Widget>[
                  SizedBox(
                    height: 110,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${widget.ID} 님 환영합니다.",
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "개인",
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      color: Color(0xffa29aac),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        IconButton(
                          alignment: Alignment.topCenter,
                          icon: Image.asset(
                            "assets/images/notification.png",
                            width: 24,
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GridDashboard()
                ],
              ),
            ));
  }
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    print(task);
    print(inputData.toString());
    Position userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    notif.Notification notification = new notif.Notification();
    notification.showNotificationWithoutSound(userLocation);

    return Future.value(true);
  });
}