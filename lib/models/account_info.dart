import 'package:meta/meta.dart';

class AccountInfo {
  int userId;
  String username;
  String firstName;
  String lastName;
  String emailAddress;
  String avatarImage;
  String role;
  DateTime lastLogin;

  AccountInfo({
    @required this.username,
    this.userId,
    this.firstName,
    this.lastName,
    this.emailAddress,
    this.avatarImage,
    this.role
  });

  AccountInfo.fromJson(Map<String, dynamic> json)
    : userId = json['userId'],
      username = json['username'],
      firstName = json['firstName'],
      lastName = json['lastName'],
      emailAddress = json['emailAddress'],
      avatarImage = json['avatarImage'],
      role = json['role'],
      lastLogin = DateTime.parse(json['lastLogin']);

  Map<String, dynamic> toJson() =>
    {
      'userId': userId,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'emailAddress': emailAddress,
      'avatarImage': avatarImage,
      'role': role,
      'lastLogin': lastLogin.toString(),
    };
}
