import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:BOB_infection_slayer/components/custom_surfix_icon.dart';
import 'package:BOB_infection_slayer/components/default_button.dart';
import 'package:BOB_infection_slayer/components/form_error.dart';
import 'package:BOB_infection_slayer/screens/signup_for_store/signup_for_store.dart';
import 'package:BOB_infection_slayer/screens/login_success/login_success_screen.dart';
import 'package:BOB_infection_slayer/services/commuication.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String ID;
  String name;
  String phoneNumber;
  String birth;
  String gender = "M";
  //bool genderChecker = false;
  String password;
  String conform_password;
  bool GPSChecker = false;
  bool personalChecker = false;
  String type = "";
  bool typePersonChecker = false;
  //bool typeStaffChecker = false;
  bool typeManagerChecker = false;
  final List<String> errors = [];

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
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildBirthFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildIDFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('가입 유형: '),
              Checkbox(
                value: typePersonChecker,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    typePersonChecker = value;
                    //typeStaffChecker = false;
                    typeManagerChecker = false;
                    if (typePersonChecker)
                      type = "1";
                    else
                      type = null;
                    if (value) {
                      removeError(error: kTypeCheckNullError);
                    } else {
                      addError(error: kTypeCheckNullError);
                    }
                  });
                },
              ),
              Text('개인'),
              Checkbox(
                value: typeManagerChecker,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    typePersonChecker = false;
                    //typeStaffChecker = false;
                    typeManagerChecker = value;
                    if (typeManagerChecker)
                      type = "2";
                    else
                      type = null;
                    if (value) {
                      removeError(error: kTypeCheckNullError);
                    } else {
                      addError(error: kTypeCheckNullError);
                    }
                  });
                },
              ),
              Text('점주'),
            ],
          ),
          //typeManagerChecker ? buildLicenseFormField() : Container(),
          Row(
            children: [
              Checkbox(
                value: personalChecker,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    personalChecker = value;
                    if (value) {
                      removeError(error: kPersonalCheckNullError);
                    } else {
                      addError(error: kPersonalCheckNullError);
                    }
                  });
                },
              ),
              Text('개인정보 방역당국 제공 동의'),
              Spacer(),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: GPSChecker,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    GPSChecker = value;
                    if (value) {
                      removeError(error: kGPSCheckNullError);
                    } else {
                      addError(error: kGPSCheckNullError);
                    }
                  });
                },
              ),
              Text('위치정보 제공 동의'),
              Spacer(),
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "가입하기",
            press: () async {
              if (_formKey.currentState.validate()) {
                if (!GPSChecker) {
                  addError(error: kGPSCheckNullError);
                  return;
                }
                if (!personalChecker) {
                  addError(error: kPersonalCheckNullError);
                  return;
                }
                if (type == null) {
                  addError(error: kTypeCheckNullError);
                  return;
                }
                _formKey.currentState.save();
                //if (!genderChecker)   {addError(error: kGenderCheckNullError); return;}
                // if all are valid then go to success screen
                bool isJoin = await Join(ID, password, name, phoneNumber, birth,
                    gender, type);
                if (!isJoin) {
                  addError(error: kSignUpFailError);
                  return;
                }
                type == "1"
                    ? Navigator.pushNamed(context, LoginSuccessScreen.routeName)
                    : Navigator.pushNamed(context, SignupForStoreScreen.routeName);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
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
        labelText: "이름",
        hintText: "가입자 성함을 입력해주세요.",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kIDNullError);
        }
        /*
        else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        */
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kIDNullError);
          return "";
        }
        /*
        else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        */
        return null;
      },
      decoration: InputDecoration(
        labelText: "휴대폰 번호",
        hintText: "가입자 휴대폰 번호를 입력해주세요.",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildBirthFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onSaved: (newValue) => birth = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kBirthNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kIDNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "생년월일",
        hintText: "가입자 생년월일 입력해주세요.",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/age.svg"),
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conform_password) {
          removeError(error: kMatchPassError);
        }
        conform_password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "비밀번호 재입력",
        hintText: "비밀번호를 재입력 해주세요.",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
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
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        } else if (!isPasswordCompliant(value)) {
          addError(error: kInvalidPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "비밀번호",
        hintText: "영문,숫자,특수문자 조합 9자 이상 입력해주세요",
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
        /*
        else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        */
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kIDNullError);
          return "";
        }
        /*
        else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        */
        return null;
      },
      decoration: InputDecoration(
        labelText: "ID",
        hintText: "가입할 아이디를 입력하세요",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }


  bool isPasswordCompliant(String password) {
    if (password == null || password.isEmpty) {
      return false;
    }

    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasDigits & hasLowercase & hasSpecialCharacters;
  }
}
