import 'dart:convert';

import 'package:meta/meta.dart';

class User {
  int userId;
  String username;
  String firstName;
  String lastName;
  String emailAddress;
  String avatarImage;
  String role;

  String jwt;
  String refreshToken;
  DateTime lastLogin;
  int failedLoginCount;
  bool mustChangePassword;
  bool enabled;

  User({
    @required this.username,
    this.userId,
    this.firstName,
    this.lastName,
    this.emailAddress,
    this.avatarImage,
    this.role
  }) {
    failedLoginCount = 0;
    mustChangePassword = false;
    enabled = false;
  }

  User.fromJson(Map<String, dynamic> json)
    : userId = json['userId'],
      username = json['username'],
      firstName = json['firstName'],
      lastName = json['lastName'],
      emailAddress = json['emailAddress'],
      avatarImage = json['avatarImage'],
      role = json['role'],
      lastLogin = json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      jwt = json['jwt'],
      refreshToken = json['refreshToken'],
      failedLoginCount = json['failedLoginCount'],
      mustChangePassword = json['mustChangePassword'],
      enabled = json['enabled'];

  static User fromJsonString(String jsonString) => User.fromJson(json.decode(jsonString));

  Map<String, dynamic> toJson() =>
      {
        'userId': userId,
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'emailAddress': emailAddress,
        'avatarImage': avatarImage,
        'role': role,
        'lastLogin': lastLogin != null ? lastLogin.toString() : null,
        'jwt': jwt,
        'refreshToken': refreshToken,
        'failedLoginCount': failedLoginCount,
        'mustChangePassword': mustChangePassword,
        'enabled': enabled,
      };

  String toJsonString() => json.encode(toJson());
}

