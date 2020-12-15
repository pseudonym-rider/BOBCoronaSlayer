import 'package:BOB_infection_slayer/screens/infection_info/infection_info.dart';
import 'package:BOB_infection_slayer/screens/roadmap/qr_roadmap.dart';
import 'package:flutter/widgets.dart';
import 'package:BOB_infection_slayer/screens/signup_for_store/signup_for_store.dart';
import 'package:BOB_infection_slayer/screens/forgot_password/forgot_password_screen.dart';
import 'package:BOB_infection_slayer/screens/login_success/login_success_screen.dart';
import 'package:BOB_infection_slayer/screens/otp/otp_screen.dart';
import 'package:BOB_infection_slayer/screens/sign_in/sign_in_screen.dart';
import 'package:BOB_infection_slayer/screens/splash/splash_screen.dart';
import 'constants.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'package:BOB_infection_slayer/screens/qr_scan/qr_scan_page.dart';
import 'package:BOB_infection_slayer/screens/home/home_page.dart';


// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  SignupForStoreScreen.routeName: (context) => SignupForStoreScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  InfectionInfoPage.routeName: (context) => InfectionInfoPage(),
  QRRoadmapPage.routeName: (context) => QRRoadmapPage(),
  ScanPage.routeName: (context) => ScanPage(),
  Home.routeName: (context) => Home(userDB.get(userID), userDB.get(userName), userDB.get(userType), userDB.get(userAccessToken), userDB.get(userRefreshToken)),
  //GpsTracker.routeName: (context) => GpsTracker(),
  //GPSSaveAndBackground.routeName: (context) => GPSSaveAndBackground(),
};
