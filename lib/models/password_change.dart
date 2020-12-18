import 'package:meta/meta.dart';

class PasswordChange {
  String username;
  String currentPassword;
  String newPassword;
  String newPasswordCompare;

  PasswordChange({
    @required this.username,
    @required this.currentPassword,
    @required this.newPassword,
    @required this.newPasswordCompare
  });

  PasswordChange.fromJson(Map<String, dynamic> json)
    : username = json['username'],
      currentPassword = json['currentPassword'],
      newPassword = json['newPassword'],
      newPasswordCompare = json['newPasswordCompare'];

  Map<String, dynamic> toJson() =>
    {
      'username': username,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'newPasswordCompare': newPasswordCompare,
    };
}