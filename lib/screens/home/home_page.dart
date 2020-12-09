import 'dart:async';
import 'dart:io';
import 'package:BOB_corona_slayer/constants.dart';
import 'package:BOB_corona_slayer/services/commuication.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'griddashboard.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:background_location/background_location.dart';
import 'package:flutter/services.dart';
import 'components/notification.dart' as notif;

class Home extends StatefulWidget {
  static String routeName = "/home";
  final String ID;
  final String name;
  final String type;
  final String accessToken;
  final String reFreshToken;
  Home(this.ID, this.name, this.type, this.accessToken, this.reFreshToken);
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
                onPressed: () async {
                  await BackgroundLocation.stopLocationService();
                  SystemNavigator.pop();
                  },
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

    WidgetsBinding.instance.addPostFrameCallback((_){
      getUserKey(widget.ID, widget.type);
    });
    makeQRCode();
    //collectGPS();
    super.initState();
    Workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    Workmanager.registerPeriodicTask(
      "1",
      "BOB corona slayer가 실행중입니다.",
      frequency: Duration(minutes: 1),
      tag: "collectGPS",
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
                          "${widget.name} 님 환영합니다.",
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
                          widget.type == "1" ? "개인" : "점주",
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
                height: 20,
              ),
              qrText.split('-')[0] == "null" ? CircularProgressIndicator() : QrImage(
                data: qrText,
                size: 200.0,
              ),
              SizedBox(
                height: 10,
              ),
              leftSecond == null? Container() : Text('${leftSecond}초 남았습니다.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              SizedBox(
                height: 20,
              ),
              GridDashboard(widget.ID, widget.type),
            ],
          ),
        ));
  }

  makeQRCode() {
    String token = createSign();
    leftSecond = 15;
    print("15초 시작");
    setState(() {
      qrText = token;
      timeHandler = Stream.periodic(Duration(seconds: 1), (_) => _)
          .take(1500)
          .listen((_) async {
        leftSecond -= 1;
        if (leftSecond == 0) {
          leftSecond = 15;
          print("15초 만료 재발급");
          qrText = createSign();
        }
        setState(() {});
      });
    });
  }

  /*
  collectGPS() {
    BackgroundLocation.getPermissions(
      onGranted: () async {
        /*await BackgroundLocation.setNotificationTitle(
            "BOB corona slayer가 동선정보를 수집중입니다.");*/
        await BackgroundLocation.startLocationService();
        BackgroundLocation.getLocationUpdates((location) {
          setState(() {
            String userLocation =
                'Latitude: ${location.latitude}, Longitude: ${location.longitude}';
            //print(userLocation);
            String date =
                DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
            GPSDB.put(date, userLocation.toString());
            fetchGPS(date, userLocation.toString());
          });
        });
      },
      onDenied: () {
        exit(0);
      },
    );
  }
   */
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    Position userLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    String date = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
    print(userLocation.toString());

    notif.Notification notification = new notif.Notification();
    notification.showNotificationWithoutSound(userLocation);

    GPSDB.put(date, userLocation.toString());
    //fetchGPS(date, userLocation.toString());
    return Future.value(true);
  });
}
