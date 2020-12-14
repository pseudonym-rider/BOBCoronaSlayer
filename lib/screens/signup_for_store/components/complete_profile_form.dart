import 'package:flutter/material.dart';
import 'package:BOB_infection_slayer/components/custom_surfix_icon.dart';
import 'package:BOB_infection_slayer/components/default_button.dart';
import 'package:BOB_infection_slayer/components/form_error.dart';
import 'package:BOB_infection_slayer/screens/login_success/login_success_screen.dart';
import 'package:BOB_infection_slayer/screens/otp/otp_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String storeName;
  String ownerName;
  String storeNumber;
  String storeAddress;
  String license = "";
  bool agreeChecker = false;
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildStoreNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLicenseFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildOwnerNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildStoreNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildStoreAddressFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(10)),
          Row(
            children: [
              Checkbox(
                value: agreeChecker,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    agreeChecker = value;
                  });
                },
              ),
              Text("서비스 이용 약관 동의"),
              Spacer(),
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(10)),
          DefaultButton(
            text: "가입완료",
            press: () {
              if (_formKey.currentState.validate()) {
                //Navigator.pushNamed(context, OtpScreen.routeName);
                Navigator.pushNamed(context, LoginSuccessScreen.routeName);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildStoreAddressFormField() {
    return TextFormField(
      onSaved: (newValue) => storeAddress = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "사업장 주소",
        hintText: "사업장 주소를 입력하세요",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildStoreNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => storeNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "사업장 전화번호",
        hintText: "사업장 전화번호를 입력해주세요.",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildOwnerNameFormField() {
    return TextFormField(
      onSaved: (newValue) => ownerName = newValue,
      decoration: InputDecoration(
        labelText: "대표자 명",
        hintText: "대표자 명을 입력해주세요.",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildStoreNameFormField() {
    return TextFormField(
      onSaved: (newValue) => storeName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNameNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "상호 명",
        hintText: "상호 명을 입력해주세요.",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildLicenseFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => license = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kLicenseNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kLicenseNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "사업자 등록번호",
        hintText: "사업자 등록번호를 입력하세요",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
