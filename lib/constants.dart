import 'dart:async';

import 'package:flutter/material.dart';
import 'package:BOB_corona_slayer/size_config.dart';

const kPrimaryColor = Color(0xff81c784);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

var userDB;
var GPSDB;
var keyDB;

const defaultDuration = Duration(milliseconds: 250);

const String keyInfo = "key";
const String userKey = "usk";
const String groupKey = "gpk";
const String storeUsk = "store_usk";
const String storeGpk = "store_gpk";
const String userInfo = "userDB";
const String userID = "ID";
const String userName = "name";
const String userType = "type";
const String GPSInfo = "GPS";
const String userAccessToken = "accessToken";
const String userRefreshToken = "refreshToken";


// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kIDNullError = "ID를 입력해주세요.";
const String kNameNullError = "이름을 입력해주세요.";
const String kPassNullError = "비밀번호를 입력해주세요.";
const String kShortPassError = "비밀번호는 최소 9자 이상이어야합니다.";
const String kInvalidPassError = "비밀번호는 영문,숫자,특수문자를 조합하여야 합니다.";
const String kMatchPassError = "비밀번호가 서로 일치하지 않습니다.";
const String kPhoneNumberNullError = "휴대폰 번호를 입력해주세요.";
const String kLicenseNullError = "사업자 등록번호를 입력해주세요.";
const String kBirthNullError = "생년월일을 입력해주세요.";
const String kGenderCheckNullError = "성별을 체크해주세요.";
const String kAddressNullError = "주소를 입력해주세요.";
const String kPersonalCheckNullError = "개인정보 방역당국 제공 동의에 체크해주세요.";
const String kGPSCheckNullError = "위치정보 제공 동의에 체크해주세요.";
const String kTypeCheckNullError = "개인,직원,점주 중에 체크해주세요.";
const String kLoginFailError = "없는 아이디거나 비밀번호가 틀렸습니다.";
const String kSignUpFailError = "이미 있는 회원입니다.";


final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}


int leftSecond;
String qrText;

StreamSubscription timeHandler;
