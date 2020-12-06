import 'package:flutter/material.dart';
import 'package:BOB_corona_slayer/components/default_button.dart';
import 'package:BOB_corona_slayer/screens/sign_in/sign_in_screen.dart';
import 'package:BOB_corona_slayer/size_config.dart';
import 'package:BOB_corona_slayer/screens/home/home_page.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Future(() => false),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            Image.asset(
              "assets/images/success.png",
              height: SizeConfig.screenHeight * 0.4, //40%
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.08),
            Text(
              "회원가입 완료",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(30),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Spacer(),
            SizedBox(
              width: SizeConfig.screenWidth * 0.6,
              child: DefaultButton(
                text: "로그인하기",
                press: () {
                  Navigator.pushNamed(context, SignInScreen.routeName);
                },
              ),
            ),
            Spacer(),
          ],
        ));
  }
}
