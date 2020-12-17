import 'dart:convert';
import 'package:BOB_infection_slayer/constants.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

final String url = 'https://api.prider.xyz/';
final String keyServer = 'https://key.prider.xyz';
final String testURL = 'http://34.123.80.89:80';

final Map<String, String> headers = {"Content-type": "application/json"};
Map<String, String> testHeaders = {
  'Content-Type': 'application/json;charset=UTF-8',
  'Charset': 'utf-8'
};

Map<String, String> accessTokenHeaders = {
  "Content-type": "application/json",
  'Authorization': 'Bearer ${userDB.get(userAccessToken)}',
};

final Map<String, String> refreshTokenHeaders = {
  "Content-type": "application/json",
  'Authorization': 'Bearer ${userDB.get(userRefreshToken)}',
};

Future<Map> Login(String ID, String password, bool remember) async {
  String addr = url + 'auth';
  Map<String, dynamic> data = {
    "user_id": ID,
    "user_pw": password,
  };
  String json = jsonEncode(data);

  print(json);

  var response = await http.post(addr, headers: headers, body: json);

  if (response.statusCode == 200) {
    Map successMap = jsonDecode(response.body);
    print(successMap);
    //print(remember);
    if (successMap['code'] == 0) {
      await userDB.put(userID, ID);
      await userDB.put(userName, successMap['user_name']);
      await userDB.put(userType, successMap['type']);
      await userDB.put(userAccessToken, successMap['access_token']);
      await userDB.put(userRefreshToken, successMap['refresh_token']);
      await getUserKey(ID, "1");

      return successMap;
    } else {
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

Future<bool> Join(String ID, String password, String name, String phoneNumber,
    String birth, String gender, String type, String license) async {
  String addr = url + 'join';
  Map<String, dynamic> data = {
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

  var response = await http.post(addr, headers: headers, body: json);

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

String createSign() {
  String key = keyDB.get(userKey);
  String token = userDB.get(userAccessToken);

  if(token == null) {
    print("토큰이 없어용");
    getAccessToken();
    token = userDB.get(userAccessToken);
  }
  //print("key: $key");
  if (key == null) {
    print("키가없어용");
    getUserKey(userDB.get(userName), "1");
    key = keyDB.get(userKey);
  }
  String date = slice(DateTime.now().millisecondsSinceEpoch.toString(), 0, -3);
  print("key: $key");
  print("token: $token");
  return "$key//$token//$date";
}

Future<void> getUserKey(String ID, String type) async {
  String addr = keyServer + '/issue-key?type=$type';
  print(addr);
  print(accessTokenHeaders);
  var response = await http.get(addr, headers: accessTokenHeaders);

  if (response.statusCode == 200) {
    Map userMap = jsonDecode(response.body);
    //print(userMap["usk"]);
    if (keyDB.get(userKey) == null) {
      print("개인 그룹 개인키 받는중");
      await keyDB.put(userKey, userMap["usk"]);
      await keyDB.put(groupKey, userMap["gpk"]);
      print('userKey: ${userMap["usk"]}');
    }
    if (type == "2" && keyDB.get(storeUsk) == null) {
      print("점포 그룹 개인키 받는중");
      await keyDB.put(storeUsk, userMap["usk"]);
      await keyDB.put(storeGpk, userMap["gpk"]);
      print('storeUsk: ${userMap["usk"]}');
    }
    return true;
  } else {
    print(response.statusCode);
    Map userMap = jsonDecode(response.body);
    print("failResponse: $userMap");
    return false;
  }
}

Future<void> getAccessToken() async {
  String addr = url + 'refresh';
  var response = await http.get(addr, headers: refreshTokenHeaders);

  if (response.statusCode == 200) {
    Map userMap = jsonDecode(response.body);
    //print("access_token: ${userMap['access_token']}");
    if (userMap['id'] != userDB.get(userID)) return false;
    await userDB.put(userAccessToken, userMap['access_token']);
    return true;
  } else {
    print(response.statusCode);
    Map userMap = jsonDecode(response.body);
    print("failResponse: $userMap");
    return false;
  }
}

Future<void> fetchGPS(String time, String gps) async {
  String addr = url + 'fetch_gps';
  //String addr = 'http://35.188.48.200:5000/post-gps';
  Map<String, dynamic> data = {"time": time, "gps": gps};
  String json = jsonEncode(data);
  print(json);

  var response = await http.post(addr, headers: headers, body: json);
}

Future<List<String>> fetchLocation(String ID) async {
  String addr = url + 'fetch_location';
  Map<String, dynamic> data = {"user_id": ID};
  String json = jsonEncode(data);
  print(json);

  var response = await http.post(addr, headers: headers, body: json);

  if (response.statusCode == 200) {
    Map userMap = jsonDecode(response.body);
    return null;
    //값 오면 뭐로 받을지 상의해야댐
  } else {
    print(response.statusCode);
    Map userMap = jsonDecode(response.body);
    print("failResponse: $userMap");
    return null;
  }
}

Future<List<String>> fetchInfomation() async {
  String addr = url + 'fetch_infomation';

  var response = await http.get(addr, headers: headers);

  if (response.statusCode == 200) {
    Map userMap = jsonDecode(response.body);
    return null;
    //값 오면 뭐로 받을지 상의해야댐
  } else {
    print(response.statusCode);
    Map userMap = jsonDecode(response.body);
    print("failResponse: $userMap");
    return null;
  }
}

Future<bool> readQRCode(String qrCode) async {
  String addr = keyServer + "/receive-qr";
  try {
    String userQRUsk = qrCode.split("//")[0];
    String userQRAccessToken = qrCode.split("//")[1];
    String createQRTime = qrCode.split("//")[2];
    Map<String, dynamic> data = {
      "user_token": userQRAccessToken,
      "store_token": userDB.get(userAccessToken),
      "time": createQRTime,
      "user_secret": userQRUsk,
      "store_secret": keyDB.get(storeUsk)
    };
    print("user_token: $userQRAccessToken");
    print("store_token: ${userDB.get(userAccessToken)}");
    print("time: $createQRTime");
    print("user_secret: $userQRUsk");
    print("store_secret: ${keyDB.get(storeUsk)}");
    String json = jsonEncode(data);
    //print(json);
    var response = await http.post(addr, headers: headers, body: json);
    print("after");
    if (response.statusCode == 200) {
      Map userMap = jsonDecode(response.body);
      if (userMap['response'] == false) {
        await getAccessToken();
        return false;
      }
      return true;
    } else {
      print(response.statusCode);
      Map userMap = jsonDecode(response.body);
      print("failResponse: $userMap");
      return false;
    }
  } catch (error) {
    print("error: $error");
    print("wow");
    return false;
  }
}

Future<bool> requestInfection() async {
  String addr = url + '/request_infection';
  getAccessToken();
  accessTokenHeaders = {
    "Content-type": "application/json",
    'Authorization': 'Bearer ${userDB.get(userAccessToken)}',
  };
  var response = await http.get(addr, headers: accessTokenHeaders);

  if (response.statusCode == 200) {
    Map userMap = jsonDecode(response.body);
    if (userMap['code'] == 1)
      return true;
    else
      return false;
  } else {
    print(response.statusCode);
    Map userMap = jsonDecode(response.body);
    print("failResponse: $userMap");
    return false;
  }
}

String slice(String subject, [int start = 0, int end]) {
  if (subject is! String) {
    return '';
  }
  int _realEnd;
  int _realStart = start < 0 ? subject.length + start : start;
  if (end is! int) {
    _realEnd = subject.length;
  } else {
    _realEnd = end < 0 ? subject.length + end : end;
  }
  return subject.substring(_realStart, _realEnd);
}
