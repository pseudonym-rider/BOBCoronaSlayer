import 'package:BOB_infection_slayer/constants.dart';
import 'package:BOB_infection_slayer/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:BOB_infection_slayer/routes.dart';
import 'package:BOB_infection_slayer/screens/splash/splash_screen.dart';
import 'package:BOB_infection_slayer/theme.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  userDB = await Hive.openBox(userInfo);
  GPSDB = await Hive.openBox(GPSInfo);
  keyDB = await Hive.openBox(keyInfo);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isAutoLogin = userDB.get(userAccessToken) == null ? false : true;
    //print(isAutoLogin);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BoB virus tracker',
      theme: theme(),
      // home: SplashScreen(),
      // We use routeName so that we dont need to remember the name
      initialRoute: isAutoLogin ? Home.routeName : SplashScreen.routeName,
      routes: routes,
    );
  }
}
