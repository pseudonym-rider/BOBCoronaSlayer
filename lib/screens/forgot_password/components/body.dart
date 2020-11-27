import 'package:flutter/material.dart';
import 'package:BOB_corona_slayer/components/custom_surfix_icon.dart';
import 'package:BOB_corona_slayer/components/default_button.dart';
import 'package:BOB_corona_slayer/components/form_error.dart';
import 'package:BOB_corona_slayer/components/no_account_text.dart';
import 'package:BOB_corona_slayer/size_config.dart';

import '../../../constants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "비밀번호 찾기",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "휴대폰 번호와 계정을 입력하시면\n 휴대폰 번호로 비밀번호 변경 링크를 보내드립니다.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String ID;
  String PhoneNumber;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => ID = newValue,
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains(kIDNullError)) {
                setState(() {
                  errors.remove(kIDNullError);
                });
              } /*else if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.remove(kInvalidEmailError);
                });
              }*/
              return null;
            },
            validator: (value) {
              if (value.isEmpty && !errors.contains(kIDNullError)) {
                setState(() {
                  errors.add(kIDNullError);
                });
              } /*else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
              }*/
              return null;
            },
            decoration: InputDecoration(
              labelText: "ID",
              hintText: "ID를 입력해주세요.",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => PhoneNumber = newValue,
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains(kIDNullError)) {
                setState(() {
                  errors.remove(kIDNullError);
                });
              } /*else if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.remove(kInvalidEmailError);
                });
              }*/
              return null;
            },
            validator: (value) {
              if (value.isEmpty && !errors.contains(kIDNullError)) {
                setState(() {
                  errors.add(kIDNullError);
                });
              } /*else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
              }*/
              return null;
            },
            decoration: InputDecoration(
              labelText: "휴대폰 번호",
              hintText: "휴대폰 번호를 입력해주세요.",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState.validate()) {
                // Do what you want to do
              }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          NoAccountText(),
        ],
      ),
    );
  }
}
