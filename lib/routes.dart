import 'package:flutter/widgets.dart';
import 'package:homephotos_app/screens/account/account_screen.dart';
import 'package:homephotos_app/screens/login/login_screen.dart';
import 'package:homephotos_app/screens/logs/logs_screen.dart';
import 'package:homephotos_app/screens/photos/photos_screen.dart';
import 'package:homephotos_app/screens/settings/settings_screen.dart';
import 'package:homephotos_app/screens/tags/tags_screen.dart';
import 'package:homephotos_app/screens/upload/upload_screen.dart';
import 'package:homephotos_app/screens/users/users_screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/login": (BuildContext context) => LoginScreen(title: 'Sing-In'),
  "/photos": (BuildContext context) => PhotosScreen(title: 'Photos'),
  "/tags": (BuildContext context) => TagsScreen(title: 'Tags'),
  "/settings": (BuildContext context) => SettingsScreen(title: 'Settings'),
  "/account": (BuildContext context) => AccountScreen(title: 'Account'),
  "/upload": (BuildContext context) => UploadScreen(title: 'Upload'),
  "/users": (BuildContext context) => UsersScreen(title: 'Users'),
  "/logs": (BuildContext context) => LogsScreen(title: 'Logs'),
};