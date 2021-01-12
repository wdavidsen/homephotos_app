import 'package:flutter/widgets.dart';
import 'package:homephotos_app/screens/account/account_form_screen.dart';
import 'package:homephotos_app/screens/login/login_form_screen.dart';
import 'package:homephotos_app/screens/photos/photos_screen.dart';
import 'package:homephotos_app/screens/register/register_form_screen.dart';
import 'package:homephotos_app/screens/register/register_success_screen.dart';
import 'package:homephotos_app/screens/services/services_form_screen.dart';
import 'package:homephotos_app/screens/settings/settings_form_screen.dart';
import 'package:homephotos_app/screens/tags/tags_screen.dart';
import 'package:homephotos_app/screens/users/user_form_screen.dart';
import 'package:homephotos_app/screens/users/users_form_screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/login": (BuildContext context) => LoginFormScreen(),
  "/photos": (BuildContext context) => PhotosScreen(title: 'Photos'),
  "/tags": (BuildContext context) => TagsScreen(title: 'Tags'),
  "/settings": (BuildContext context) => SettingsFormScreen(),
  "/account": (BuildContext context) => AccountFormScreen(),
  "/users": (BuildContext context) => UsersFormScreen(),
  "/user-detail": (BuildContext context) => UserFormScreen(),
  "/register": (BuildContext context) => RegisterFormScreen(),
  "/register-success": (BuildContext context) => RegisterSuccessScreen(),
  "/services": (BuildContext context) => ServicesFormScreen(),
};