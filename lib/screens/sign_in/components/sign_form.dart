import 'package:flutter/material.dart';
import 'package:BOB_corona_slayer/components/custom_surfix_icon.dart';
import 'package:BOB_corona_slayer/components/form_error.dart';
import 'package:BOB_corona_slayer/screens/forgot_password/forgot_password_screen.dart';
import 'package:BOB_corona_slayer/screens/home/home_page.dart';
import 'package:BOB_corona_slayer/screens/login_success/login_success_screen.dart';
import 'package:BOB_corona_slayer/services/commuication.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String ID;
  String password;
  bool remember = false;
  final List<String> errors = [];
  ProgressDialog pr;

  void showProgressDialog() async {
    pr.show();
    Future.delayed(Duration(seconds: 0)).then((value) => pr.hide());
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildIDFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("자동 로그인"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "비밀번호 찾기",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "로그인",
            press: () async {
              showProgressDialog();
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                bool isLogin = await Login(ID, password);
                if (!isLogin) {addError(error: kLoginFailError); return;}
                //Navigator.pushNamed(context, Home.routeName);
                //나중에 bloc, provider 이용해서 코드좀 수정해야함.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(ID),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "비밀번호",
        hintText: "비밀번호를 입력해주세요.",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildIDFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => ID = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kIDNullError);
        }
        /*else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }*/
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kIDNullError);
          return "";
        }
        /*else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        */
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
    );
  }
}
