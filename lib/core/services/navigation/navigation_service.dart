import 'dart:io';

import 'package:flutter/cupertino.dart';

class RouteNavigators {
  static void routeReplace(BuildContext context, [Widget? route]) {
    Navigator.of(context).pushReplacement(
      Platform.isIOS
          ? CupertinoPageRoute(
              builder: (_) {
                return route!;
              },
            )
          : PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return route!;
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0, 1);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                final tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
    );
  }

  static void routeNoWayHome(BuildContext context, [Widget? route]) {
    Navigator.pushAndRemoveUntil(
      context,
      Platform.isIOS
          ? CupertinoPageRoute(
              builder: (_) {
                return route!;
              },
            )
          : PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return route!;
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0, 1);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                final tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
      (route) => false,
    );
  }

  static Future route(BuildContext context, [Widget? route, Animatable<Offset>? tw]) {
    return Navigator.of(context).push(
      Platform.isIOS
          ? CupertinoPageRoute(
              builder: (_) {
                return route!;
              },
            )
          : PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return route!;
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0, 1);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                final tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tw??tween),
                  child: child,
                );
              },
            ),
    );
  }

  static void pop(BuildContext context, [Object? result]) {
    Navigator.pop(context, result);
  }
}
