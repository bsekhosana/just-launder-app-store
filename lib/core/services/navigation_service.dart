import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void pushAndClearStack(String route) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(route, (route) => false);
  }

  static void push(String route) {
    navigatorKey.currentState?.pushNamed(route);
  }

  static void pop() {
    navigatorKey.currentState?.pop();
  }

  static void popUntil(String route) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(route));
  }

  static void replace(String route) {
    navigatorKey.currentState?.pushReplacementNamed(route);
  }
}
