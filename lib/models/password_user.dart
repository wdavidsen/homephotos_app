import 'package:homephotos_app/models/user.dart';
import 'package:meta/meta.dart';

class PasswordUser extends User {
  String password;
  String passwordCompare;

  PasswordUser({
    @required User user,
    @required String password,
    @required String passwordCompare
  }) {
    this.password = password;
    this.passwordCompare = passwordCompare;
    this.userId = user.userId;
    this.username = user.username;
    this.firstName = user.firstName;
    this.lastName = user.lastName;
    this.role = user.role;
    this.lastLogin = user.lastLogin;
    this.failedLoginCount = user.failedLoginCount;
    this.mustChangePassword = user.mustChangePassword;
    this.enabled = user.enabled;
  }

  @override
  Map<String, dynamic> toJson() {
    var map = super.toJson();
    map.addAll({"password": password, "passwordCompare": passwordCompare});
    return map;
  }
}