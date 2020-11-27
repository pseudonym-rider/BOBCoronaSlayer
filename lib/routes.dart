import 'package:flutter/widgets.dart';
import 'package:BOB_corona_slayer/screens/complete_profile/complete_profile_screen.dart';
import 'package:BOB_corona_slayer/screens/details/details_screen.dart';
import 'package:BOB_corona_slayer/screens/forgot_password/forgot_password_screen.dart';
import 'package:BOB_corona_slayer/screens/login_success/login_success_screen.dart';
import 'package:BOB_corona_slayer/screens/otp/otp_screen.dart';
import 'package:BOB_corona_slayer/screens/sign_in/sign_in_screen.dart';
import 'package:BOB_corona_slayer/screens/splash/splash_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'package:BOB_corona_slayer/screens/qr_make/qr_make_page.dart';
import 'package:BOB_corona_slayer/screens/qr_scan/qr_scan_page.dart';
import 'package:BOB_corona_slayer/screens/gps/gps_tracker.dart';
import 'package:BOB_corona_slayer/screens/home/home_page.dart';
import 'package:BOB_corona_slayer/screens/gps/GPSSaveAndBackground.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  GeneratePage.routeName: (context) => GeneratePage(),
  ScanPage.routeName: (context) => ScanPage(),
  //Home.routeName: (context) => Home(ID),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  //GpsTracker.routeName: (context) => GpsTracker(),
  //GPSSaveAndBackground.routeName: (context) => GPSSaveAndBackground(),
};
