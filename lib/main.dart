import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/app_lifecycle_manager.dart';
import 'package:reach_me/core/routes/routes.dart';
import 'package:reach_me/core/services/graphql/gql_provider.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:flutter/services.dart';
import 'package:reach_me/core/utils/bloc_observer.dart';
import 'dart:io';
import 'package:reach_me/features/home/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initSingletons();
  Bloc.observer = AppBlocObserver();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness:
        Platform.isAndroid ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.grey,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

/// Registers all the singletons we need by passing a factory function.
Future<void> initSingletons() async {
  getIt.registerLazySingleton<AppGlobals>(() => AppGlobals());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: clientFor(),
      child: LifeCycleManager(
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
      ),
    );
  }
}
