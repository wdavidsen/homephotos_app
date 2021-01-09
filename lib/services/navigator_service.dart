import 'package:flutter/material.dart';

class NavigatorService {
  static GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, bool replace) {
    if (replace) {
      return navigatorKey.currentState.pushReplacementNamed(routeName);
    }
    else {
      return navigatorKey.currentState.pushNamed(routeName);
    }
  }

  Future<dynamic> navigateToLogin() {
    return navigatorKey.currentState.pushNamedAndRemoveUntil("/login", (route) => false);
  }

  void goBack() {
    return navigatorKey.currentState.pop();
  }
}