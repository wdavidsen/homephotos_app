import 'package:meta/meta.dart';

class AccountInfo {
  int userId;
  String username;
  String firstName;
  String lastName;
  String role;
  DateTime lastLogin;

  AccountInfo({
    @required this.username,
    this.userId,
    this.firstName,
    this.lastName, this.role
  });

  AccountInfo.fromJson(Map<String, dynamic> json)
    : userId = json['userId'],
      username = json['username'],
      firstName = json['firstName'],
      lastName = json['lastName'],
      role = json['role'],
      lastLogin = json['lastLogin'];

  Map<String, dynamic> toJson() =>
    {
      'userId': userId,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'lastLogin': lastLogin,
    };
}
