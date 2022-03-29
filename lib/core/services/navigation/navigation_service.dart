import 'package:flutter/material.dart';
import 'package:reach_me/core/routes/page_route.dart';
// import 'package:injectable/injectable.dart';

// @singleton
class NavigationService {
  factory NavigationService() => _instance;
  static final NavigationService _instance = NavigationService._internal();
  NavigationService._internal();

  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  static get navigationKey => NavigationService()._navigationKey;

  static Future<dynamic> navigateTo(String routeName, {arguments}) async =>
      NavigationService()
          ._navigationKey
          .currentState!
          .pushNamed(routeName, arguments: arguments);

  static Future<dynamic> navigatePopUntil(String routeName,
          {arguments}) async =>
      NavigationService()
          ._navigationKey
          .currentState!
          .popUntil((route) => false);

  static Future<dynamic> navigateToReplace(String routeName,
          {arguments}) async =>
      NavigationService()
          ._navigationKey
          .currentState!
          .pushReplacementNamed(routeName, arguments: arguments);

  static dynamic goBack([dynamic popValue]) =>
      NavigationService()._navigationKey.currentState!.pop(popValue);

  static Future<bool> maybePop<T>([T? data]) =>
      NavigationService()._navigationKey.currentState!.maybePop(data);

  static void popToHome() => NavigationService()
      ._navigationKey
      .currentState!
      .popUntil((route) => route.isFirst);

  static navigateTransparentRoute(
      BuildContext context, Widget route, double dx, double dy) async {
    return await Navigator.push(
      context,
      TransparentRoute(
        builder: (context) => route,
        dx: dx,
        dy: dy,
      ),
    );
  }
}
