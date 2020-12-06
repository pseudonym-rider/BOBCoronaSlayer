import 'dart:convert';
import 'package:BOB_corona_slayer/constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

final String url = 'https://api.prider.xyz/';

final Map<String, String> headers = {"Content-type": "application/json"};
final Map<String, String> tokenHeaders = {"Content-type": "application/json", 'Authorization': 'Bearer ${userDB.get(userAccessToken)}',};

Future<Map> Login(String ID, String password, bool remember) async {
  String addr = url + 'auth';
  Map<String,dynamic> data = {
    "user_id": ID,
    "user_pw" : password,
  };
  String json = jsonEncode(data);

  print(json);

  var response = await http.post(addr, headers: headers, body:json);

  if (response.statusCode == 200) {
    Map successMap = jsonDecode(response.body);
    print(successMap);
    print(remember);
    if (successMap['code'] == 0) {
      if (remember) {
        userDB.put(userID, ID);
        userDB.put(userName, successMap['user_name']);
        userDB.put(userType, successMap['type']);
        userDB.put(userAccessToken, successMap['access_token']);
        userDB.put(userRefreshToken, successMap['refresh_token']);
      }
      return successMap;
    }
    else {
      Map failMap = successMap;
      return null;
    }
  } else {
    print(response.statusCode);
    Map errorMap = jsonDecode(response.body);
    print(errorMap['code']);
    print(errorMap['msg']);
    return null;
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
  if (type == "2") data['license'] = license;
  String json = jsonEncode(data);
  print(json);

  var response = await http.post(addr, headers: headers, body:json);

  if (response.statusCode == 200) {
    Map userMap = jsonDecode(response.body);
    print(userMap['code']);
    if (userMap['code'] != 0) return false;
    return true;
  } else {
    print(response.statusCode);
    Map userMap = jsonDecode(response.body);
    print(userMap['code']);
    return false;
  }
}

String createJWTToken() {
  final key = 's3cr3t';
  final claimSet = new JwtClaim(
    subject:
    '${userDB.get(userID)}//${DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now())}',
    issuer: 'prider',
    issuedAt: DateTime.now(),
    expiry: DateTime.now().add(Duration(seconds: 15)),
  );
  String token = issueJwtHS256(claimSet, key);
  //print(token);
  return token;
}

Future<void> getUserKey(String ID, String type) async{
  String addr = url + 'get_usk';
  Map<String,dynamic> data = {
  };
  String json = jsonEncode(data);
  print(json);

  var response = await http.post(addr, headers: headers, body:json);
}

Future<void> getAccessToken() async {
  String addr = url + 'refresh';
  var response = await http.get(addr, headers: tokenHeaders);

  if (response.statusCode == 200) {
    Map userMap = jsonDecode(response.body);
    print(userMap['access_token']);
    if (userMap['id'] != userDB.get(userID)) return false;
    userDB.put(userAccessToken, userMap['access_token']);
    return true;
  } else {
    print(response.statusCode);
    Map userMap = jsonDecode(response.body);
    print(userMap['code']);
    return false;
  }
}

Future<void> fetchGPS(String time, String gps) async {
  //String addr = url + 'fetch_gps';
  String addr = 'http://35.188.48.200:5000/post-gps';
  Map<String,dynamic> data = {
    "time" : time,
    "gps" : gps
  };
  /*
  GPSDB.keys.toList().forEach((element){
    data[element] = GPSDB.get(element);
  });
   */
  String json = jsonEncode(data);
  print(json);

  var response = await http.post(addr, headers: headers, body:json);
}