import 'dart:async';
import 'dart:convert';
import 'package:homephotos_app/app_config.dart';
import 'package:homephotos_app/main.dart';
import 'package:homephotos_app/models/password_change.dart';
import 'package:homephotos_app/models/tokens.dart';
import 'package:homephotos_app/models/user.dart';
import 'package:homephotos_app/services/service_helper.dart';
import 'package:http/http.dart' as http;

class AuthService {

  static Future<User> login(String username, String password) async {
    final response = await http.post(
      "${AppConfig.apiUrl}/auth/login",
      headers: ServiceHelper.commonHeaders,
      body: json.encode({
        "username": username,
        "password": password
      })
    );
    var user = User.fromJson(json.decode(response.body));
    return user;
  }

  static Future<User> loginWithPasswordChange(PasswordChange changeInfo) async {
    final response = await http.post(
      "${AppConfig.apiUrl}/auth/loginWithPasswordChange",
      headers: ServiceHelper.commonHeaders,
      body: changeInfo
    );
    var user = User.fromJson(json.decode(response.body));
    return user;
  }

  static Future<Tokens> refreshToken(User user) async {
    final response = await http.post(
    "${AppConfig.apiUrl}/auth/refresh",
      headers: ServiceHelper.commonHeaders,
      body: { "jwt": user.jwt, "refreshToken": user.refreshToken }
    );
    var tokens = Tokens.fromJson(json.decode(response.body));
    return tokens;
  }

  static Future<void> logout(User user) async {
    final response = await http.post(
      "${AppConfig.apiUrl}/auth/logout",
      headers: ServiceHelper.commonHeaders,
      body: { "refreshToken": user.refreshToken }
    );
  }
}

