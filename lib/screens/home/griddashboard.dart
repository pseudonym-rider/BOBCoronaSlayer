import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:BOB_corona_slayer/screens/gps/GPSSaveAndBackground.dart';
import 'package:BOB_corona_slayer/screens/qr_make/qr_make_page.dart';
import 'package:BOB_corona_slayer/screens/qr_scan/qr_scan_page.dart';

class GridDashboard extends StatefulWidget {
  @override
  _GridDashboardState createState() => _GridDashboardState();
}

class _GridDashboardState extends State<GridDashboard> {
  Position position;
  Items item1 = new Items(
      title: "QR Scan",
      subtitle: "방문자들의 QR코드를 읽습니다.",
      img: "assets/images/qrcode.jpg");

  Items item2 = new Items(
    title: "QR Maker",
    subtitle: "QR 코드를 생성합니다.",
    img: "assets/images/qrcode.jpg",
  );

  Items item3 = new Items(
    title: "Locations GPS",
    subtitle: "실시간으로 동선정보를 저장합니다.",
    img: "assets/images/map.png",
  );

  Items item4 = new Items(
    title: "코로나19 정보",
    subtitle: "코로나에 관련된 정보를 모아볼 수 있습니다.",
    img: "assets/images/festival.png",
  );

  Items item5 = new Items(
    title: "기타",
    subtitle: "뭐 넣을지 생각 중입니다.",
    img: "assets/images/todo.png",
  );

  Items item6 = new Items(
    title: "설정",
    subtitle: "",
    img: "assets/images/setting.png",
  );

  void _getUserPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    Position userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() => position = userLocation);
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserPosition();
  }
  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6];

    var color = 0xff81c784;
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return Container(
              decoration: BoxDecoration(
                  color: Color(color), borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                onTap: () {
                  if (data.title == "QR Scan") {
                    Navigator.pushNamed(context, ScanPage.routeName);
                  } else if (data.title == "QR Maker") {
                    Navigator.pushNamed(context, GeneratePage.routeName);
                  } else if (data.title == "Locations GPS") {
                    //Navigator.pushNamed(context, GPSSaveAndBackground.routeName);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GPSSaveAndBackground(position),
                      ),
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      data.img,
                      width: 42,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.title,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      data.subtitle,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
    );
  }
}

class Items {
  String title;
  String subtitle;
  String img;
  Items({this.title, this.subtitle, this.img});
}
