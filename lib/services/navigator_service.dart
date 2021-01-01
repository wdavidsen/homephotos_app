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

  void goBack() {
    return navigatorKey.currentState.pop();
  }
}