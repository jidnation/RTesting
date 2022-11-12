import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/app_lifecycle_manager.dart';
import 'package:reach_me/core/routes/routes.dart';
import 'package:reach_me/core/services/graphql/gql_provider.dart';
import 'package:flutter/services.dart';
import 'package:reach_me/core/utils/bloc_observer.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'dart:io';

import 'package:reach_me/features/auth/presentation/views/splash_screen.dart';
import 'package:reach_me/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initSingletons();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      child: GraphQLProvider(
        client: chatClientFor(),
        child: LifeCycleManager(
          child: OverlaySupport.global(
            child: Portal(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'ReachMe',
                theme: ThemeData(
                    fontFamily: 'Poppins',
                    primarySwatch: Colors.blue,
                    sliderTheme: const SliderThemeData(
                      trackHeight: 4.0,
                      activeTickMarkColor: AppColors.textColor2,
                      inactiveTickMarkColor: AppColors.white,
                      thumbColor: AppColors.white,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 6.0),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 8.0),
                    )),
                initialRoute: SplashScreenAnimator.id,
                onGenerateRoute: RMRouter.generateRoute,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
