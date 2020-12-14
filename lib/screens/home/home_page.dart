import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:BOB_infection_slayer/constants.dart';
import 'package:BOB_infection_slayer/services/commuication.dart';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'griddashboard.dart';
import 'package:flutter/services.dart';

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
  static const String _isolateName = "LocatorIsolate";
  ReceivePort port = ReceivePort();
  @override
  void initState() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
    port.listen((dynamic location) {
      String userLocation =
          "Latitude: ${location.latitude}, Longitude: ${location.longitude}";
      String date = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
      print("userLocation: $userLocation");
      GPSDB.put(date, userLocation);
    });
    initPlatformState();
    startCollectGPS();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserKey(widget.ID, widget.type);
    });
    makeQRCode();

  }

  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
  }

  static void callback(LocationDto locationDto) async {
    final SendPort send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
  }

  static void notificationCallback() {
    print('User clicked on the notification');
  }

  void startCollectGPS() {
    BackgroundLocator.registerLocationUpdate(callback,
        autoStop: false,
        iosSettings: IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 60,
            distanceFilter: 0,
            androidNotificationSettings: AndroidNotificationSettings(
              notificationChannelName: 'Location tracking',
              notificationTitle: 'BOB Infection slayer',
              notificationMsg: 'GPS 정보를 로컬로 수집하는중입니다.',
              notificationBigMsg: 'GPS 정보를 로컬로 수집하는중입니다.',
              notificationIcon: '',//'mipmap/teamLogo.PNG',
              notificationIconColor: Colors.grey,
                notificationTapCallback:
                notificationCallback
            )));
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
              qrText.split('-')[0] == "null"
                  ? CircularProgressIndicator()
                  : QrImage(
                      data: qrText,
                      size: 200.0,
                    ),
              SizedBox(
                height: 10,
              ),
              leftSecond == null
                  ? Container()
                  : Text('${leftSecond}초 남았습니다.',
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

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("정말 종료하시겠습니까?"),
            actions: <Widget>[
              FlatButton(
                child: Text("네"),
                onPressed: () async {
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
}
