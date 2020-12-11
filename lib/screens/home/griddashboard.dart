import 'package:BOB_corona_slayer/constants.dart';
import 'package:BOB_corona_slayer/services/commuication.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:BOB_corona_slayer/screens/qr_make/qr_make_page.dart';
import 'package:BOB_corona_slayer/screens/qr_scan/qr_scan_page.dart';

class GridDashboard extends StatefulWidget {
  String type;
  String ID;
  GridDashboard(this.ID, this.type);
  @override
  _GridDashboardState createState() => _GridDashboardState();
}

class _GridDashboardState extends State<GridDashboard> {
  Items item1 = new Items(
      title: "QR Scan",
      subtitle: "방문자들의 QR코드를 읽습니다.",
      img: "assets/images/qrcode.jpg");

  Items item2 = new Items(
    title: "QR Roadmap",
    subtitle: "QR 체크인했던 장소들을 확인합니다.",
    img: "assets/images/map.png",
  );

  Items item3 = new Items(
    title: "Corona19 Info",
    subtitle: "내 지역의 확진자 상황을 확인합니다.",
    img: "assets/images/festival.png",
  );

  Items item4 = new Items(
    title: "Infection check",
    subtitle: "내 밀접접촉 여부를 확인합니다.",
    img: "assets/images/todo.png",
  );

  Items item5 = new Items(
    title: "기타",
    subtitle: "뭐 넣을지 생각 중입니다.",
    img: "assets/images/todo.png",
  );

  Items item6 = new Items(
    title: "설정",
    subtitle: "GPS, 기타 정보등을 설정합니다.",
    img: "assets/images/setting.png",
  );

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item6];
    if(widget.type == "1") myList.remove(item1);

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
                onTap: () async {
                  if (data.title == "QR Scan") {
                    await getUserKey(widget.ID, widget.type);
                    changePageRoute(ScanPage.routeName);
                  } else if (data.title == "QR Roadmap") {
                    changePageRoute(GeneratePage.routeName);
                  } else if (data.title == "Locations GPS") {
                    //Navigator.pushNamed(context, GPSSaveAndBackground.routeName);
                  } else if (data.title == "Corona19 Info") {

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
  changePageRoute(String routeName) async {
    timeHandler.pause();
    if(timeHandler.isPaused) {
      leftSecond = 15;
      qrText = await createSign();
    }
    final variable = await Navigator.pushNamed(context, routeName);
    timeHandler.resume();
  }
}

class Items {
  String title;
  String subtitle;
  String img;
  Items({this.title, this.subtitle, this.img});
}
