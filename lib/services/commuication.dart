import 'dart:convert';
import 'package:BOB_infection_slayer/constants.dart';
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
final Map<String, String> tokenHeaders = {
  "Content-type": "application/json",
  'Authorization': 'Bearer ${userDB.get(userAccessToken)}',
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
      if (remember) {
        await userDB.put(userID, ID);
        await userDB.put(userName, successMap['user_name']);
        await userDB.put(userType, successMap['type']);
        await userDB.put(userAccessToken, successMap['access_token']);
        await userDB.put(userRefreshToken, successMap['refresh_token']);
        await getUserKey(ID, "1");
      }
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
  String id = userDB.get(userID);
  //print("key: $key");
  //String addr = keyServer + '/get-sign';
  if (key == null) {
    print("키가없어용");
    getUserKey(userDB.get(userName), "1");
    key = keyDB.get(userKey);
  }
  String date = slice(DateTime.now().millisecondsSinceEpoch.toString(), 0, -3);
  //print(date);
  //print("$key//$id//$date");
  return "$key//$id//$date";
}

Future<void> getUserKey(String ID, String type) async {
  String addr = keyServer + '/request/issue-key';
  //String addr = testURL + '/request/issue-key';
  Map<String, dynamic> data = {
    //"user_id" : ID,
    "id": ID,
    "type": type
  };
  String json = jsonEncode(data);
  print("getuserkey: " + json);

  var response = await http.post(addr, headers: headers, body: json);

  if (response.statusCode == 200) {
    Map userMap = jsonDecode(response.body);
    //print(userMap["usk"]);
    if (keyDB.get(userKey) == null) {
      print("개인 그룹 개인키 받는중");
      await keyDB.put(userKey, userMap["usk"]);
      await keyDB.put(groupKey, userMap["gpk"]);
    }
    if (type == "2" && keyDB.get(storeUsk) == null) {
      print("점포 그룹 개인키 받는중");
      await keyDB.put(storeUsk, userMap["usk"]);
      await keyDB.put(storeGpk, userMap["gpk"]);
    }
    return true;
  } else {
    print(response.statusCode);
    Map userMap = jsonDecode(response.body);
    print(userMap);
    return false;
  }
}

Future<void> getAccessToken() async {
  String addr = url + 'refresh';
  var response = await http.get(addr, headers: tokenHeaders);

  if (response.statusCode == 200) {
    Map userMap = jsonDecode(response.body);
    print(userMap['access_token']);
    if (userMap['id'] != userDB.get(userID)) return false;
    await userDB.put(userAccessToken, userMap['access_token']);
    return true;
  } else {
    print(response.statusCode);
    Map userMap = jsonDecode(response.body);
    print(userMap['code']);
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
  Map<String, dynamic> data = {"user_id" : ID};
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
    print(userMap['code']);
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
    print(userMap['code']);
    return null;
  }
}

Future<bool> readQRCode(String qrCode) async {
  //String addr = testURL + "/receive-qr";
  String addr = keyServer + "/receive-qr";
  try {
    String userQRUsk = qrCode.split("//")[0];
    String userQRID = qrCode.split("//")[1];
    String createQRTime = qrCode.split("//")[2];
    print(keyDB.get(storeUsk));
    Map<String, dynamic> data = {
      "user-id": userQRID,
      "store-id": userDB.get(userID),
      "time": createQRTime,
      "user-secret": userQRUsk,
      "store-secret": keyDB.get(storeUsk)
    };
    String json = jsonEncode(data);
    print(json);
    var response = await http.post(addr, headers: headers, body: json);
    print("after");
    if (response.statusCode == 200) {
      Map userMap = jsonDecode(response.body);
      if (userMap['response'] == false) return false;
      return true;
    } else {
      Map userMap = jsonDecode(response.body);
      print("failed: $userMap");
      return false;
    }
  } catch (error) {
    print("error: $error");
    print("wow");
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
