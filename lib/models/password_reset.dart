import 'package:meta/meta.dart';

class PasswordReset {
  String username;
  String newPassword;
  String newPasswordCompare;

  PasswordReset({
    @required this.username,
    @required this.newPassword,
    @required this.newPasswordCompare
  });

  PasswordReset.fromJson(Map<String, dynamic> json)
    : username = json['username'],
      newPassword = json['newPassword'],
      newPasswordCompare = json['newPasswordCompare'];

  Map<String, dynamic> toJson() =>
    {
      'username': username,
      'newPassword': newPassword,
      'newPasswordCompare': newPasswordCompare,
    };
}