import 'dart:async';
import 'dart:convert';
import 'package:homephotos_app/models/user.dart';
import 'package:homephotos_app/services/service_helper.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../app_config.dart';

class UserService {

  static Future<User> get(int userId) async {
    final response = await http.get(
      "${AppConfig.apiUrl}/users/$userId",
      headers: ServiceHelper.secureHeaders,
    );

    User user = User.fromJson(json.decode(response.body));
    return user;
  }

  static Future<List<User>> getAll() async {
    final response = await http.get(
      "${AppConfig.apiUrl}/users",
      headers: ServiceHelper.secureHeaders,
    );

    List<Map<String, dynamic>> list = json.decode(response.body);
    var users = List<User>();

    list.forEach((element) {
      users.add(User.fromJson(element));
    });
    return users;
  }

  static Future<void> delete(int userId) async {
    await http.delete(
      "${AppConfig.apiUrl}/users/${userId}",
      headers: ServiceHelper.secureHeaders,
    );
  }

  static Future<void> create(User user) async {
    Response response;

    response = await http.post(
      "${AppConfig.apiUrl}/users",
      headers: ServiceHelper.secureHeaders,
      body: user
    );
    User u = User.fromJson(json.decode(response.body));
    return u;
  }

  static Future<void> update(User user) async {
    Response response;

    response = await http.put(
        "${AppConfig.apiUrl}/users",
        headers: ServiceHelper.secureHeaders,
        body: user
    );
    User u = User.fromJson(json.decode(response.body));
    return u;
  }
}