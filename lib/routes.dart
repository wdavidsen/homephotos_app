import 'package:flutter/widgets.dart';
import 'package:homephotos_app/screens/account/account_form_screen.dart';
import 'package:homephotos_app/screens/login/login_form_screen.dart';
import 'package:homephotos_app/screens/logs/logs_screen.dart';
import 'package:homephotos_app/screens/photos/photos_screen.dart';
import 'package:homephotos_app/screens/settings/settings_form_screen.dart';
import 'package:homephotos_app/screens/tags/tags_screen.dart';
import 'package:homephotos_app/screens/upload/upload_screen.dart';
import 'package:homephotos_app/screens/users/user_form_screen.dart';
import 'package:homephotos_app/screens/users/users_form_screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/login": (BuildContext context) => LoginFormScreen(),
  "/photos": (BuildContext context) => PhotosScreen(title: 'Photos'),
  "/tags": (BuildContext context) => TagsScreen(title: 'Tags'),
  "/settings": (BuildContext context) => SettingsFormScreen(),
  "/account": (BuildContext context) => AccountFormScreen(),
  "/upload": (BuildContext context) => UploadScreen(title: 'Upload'),
  "/users": (BuildContext context) => UsersFormScreen(),
  "/user-detail": (BuildContext context) => UserFormScreen(),
  "/logs": (BuildContext context) => LogsScreen(title: 'Logs'),
};