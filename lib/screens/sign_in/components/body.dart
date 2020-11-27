import 'package:flutter/material.dart';
import 'package:BOB_corona_slayer/components/no_account_text.dart';
import 'package:BOB_corona_slayer/components/socal_card.dart';
import '../../../size_config.dart';
import 'sign_form.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "BoB Corona slayer",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: getProportionateScreenWidth(36),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "로그인할 ID와 PW를 입력하세요\nor continue with social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocalCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () {},
                    ),
                    SocalCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () {},
                    ),
                    SocalCard(
                      icon: "assets/icons/twitter.svg",
                      press: () {},
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}