import 'package:flutter/material.dart';

class TokenInfo extends ChangeNotifier {
  String? accessToken = null;
  String? refreshToken = null;

  void saveAccessToken(String? token) {
    this.accessToken = token;
    notifyListeners();
  }

  void saveRefreshToken(String? token) {
    this.refreshToken = token;
    notifyListeners();
  }
}
