import 'dart:convert';

import 'package:meta/meta.dart';

class Registration {
  String username;
  String password;
  String passwordCompare;
  String firstName;
  String lastName;

  Registration({
    @required this.username,
    @required this.password,
    @required this.passwordCompare,
    this.firstName,
    this.lastName
  });

  Registration.fromJson(Map<String, dynamic> json)
    : username = json['username'],
      password = json['password'],
      passwordCompare = json['passwordCompare'],
      firstName = json['firstName'],
      lastName = json['lastName'];

  static Registration fromJsonString(String jsonString) => Registration.fromJson(json.decode(jsonString));

  Map<String, dynamic> toJson() =>
      {
        'username': username,
        'password': password,
        'passwordCompare': passwordCompare,
        'firstName': firstName,
        'lastName': lastName,
      };

  String toJsonString() => json.encode(toJson());
}

