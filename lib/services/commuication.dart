import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

final String url = 'https://tmp.prider.xyz/';


Future<bool> Login(String ID, String password) async {
  String addr = url + 'login';
  Map<String,dynamic> data = {
    "user_id": ID,
    "user_pw" : password,
  };
  String json = jsonEncode(data);
  Map<String, String> headers = {"Content-type": "application/json"};
  print(json);

  var response = await http.post(addr, headers: headers, body:json);

  if (response.statusCode == 200) {
    Map userMap = jsonDecode(response.body);
    print(userMap['code']);
    print(userMap['msg']);
    if (int.parse(userMap['code']) == 0) return true;
    else return false;
  } else {
    print(response.statusCode);
    Map userMap = jsonDecode(response.body);
    print(userMap['code']);
    print(userMap['msg']);
    return false;
  }
}

Future<bool> Join(String ID, String password, String name, String phoneNumber, String birth, String gender, String type, String license) async {
  String addr = url + 'join';
  Map<String,dynamic> data = {
    "user_id": ID,
    "user_name": name,
    "user_pw": password,
    "phone": phoneNumber,
    "birth": birth,
    "gender": gender,
    "type": type,
  };
  if (type != "1") data['license'] = license;
  String json = jsonEncode(data);
  print(json);
  Map<String, String> headers = {"Content-type": "application/json"};

  var response = await http.post(addr, headers: headers, body:json);

  if (response.statusCode == 200) {
    Map userMap = jsonDecode(response.body);
    print(userMap['code']);
    if (userMap['code'] != 0) return false;
    return true;
  } else {
    print(response.statusCode);
    return false;
  }
}