import 'package:meta/meta.dart';

class User {
  int userId;
  String username;
  String firstName;
  String lastName;
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
    this.role
  });

  User.fromJson(Map<String, dynamic> json)
    : userId = json['userId'],
      username = json['username'],
      firstName = json['firstName'],
      lastName = json['lastName'],
      role = json['role'],
      lastLogin = DateTime.parse(json['lastLogin']),
      jwt = json['jwt'],
      refreshToken = json['refreshToken'],
      failedLoginCount = json['failedLoginCount'],
      mustChangePassword = json['mustChangePassword'],
      enabled = json['enabled'];

  Map<String, dynamic> toJson() =>
    {
      'userId': userId,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'lastLogin': lastLogin,
      'jwt': jwt,
      'refreshToken': refreshToken,
      'failedLoginCount': failedLoginCount,
      'mustChangePassword': mustChangePassword,
      'enabled': enabled,
    };
}
