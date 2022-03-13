import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reach_me/core/app_lifecycle_manager.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/routes/routes.dart';
import 'package:reach_me/screens/splash_screen.dart';
import 'package:flutter/services.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    return LifeCycleManager(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ReachMe',
        navigatorKey: NavigationService.navigationKey,
        theme: ThemeData(
          fontFamily: 'Poppins',
          primarySwatch: Colors.blue,
        ),
        initialRoute: SplashScreenAnimator.id,
        onGenerateRoute: RMRouter.generateRoute,
      ),
    );
  }
}
