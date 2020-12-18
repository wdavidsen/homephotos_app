import 'package:flutter/widgets.dart';
import 'package:homephotos_app/screens/home/home_screen.dart';
import 'package:homephotos_app/screens/login/login_screen.dart';
import 'package:homephotos_app/screens/photos/photos_screen.dart';
import 'package:homephotos_app/screens/settings/settings_screen.dart';
import 'package:homephotos_app/screens/tags/tags_screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => HomeScreen(title: 'Home'),
  "/login": (BuildContext context) => LoginScreen(title: 'Sing-In'),
  "/photos": (BuildContext context) => PhotosScreen(title: 'Photos'),
  "/tags": (BuildContext context) => TagsScreen(title: 'Tags'),
  "/settings": (BuildContext context) => SettingsScreen(title: 'Settings')
};