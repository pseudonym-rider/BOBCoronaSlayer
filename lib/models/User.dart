import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class User with ChangeNotifier {
  final String user_id;
  final String name;
  final String type;
  final String accessToken;
  final String refreshToken;

  User(
      {this.user_id,
      this.name,
      this.type,
      this.accessToken,
      this.refreshToken});

  String get user_name {
    return name;
  }

  String get user_type {
    return type;
  }

  String get user_accessToken {
    return accessToken;
  }

  String get user_refreshToken {
    return refreshToken;
  }

  Future<bool> Login(String ID, String password) async {
    notifyListeners();
    return true;
  }
}
