import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:reach_me/core/routes/routes.dart';
import 'package:reach_me/core/services/graphql/gql_provider.dart';
import 'package:reach_me/core/services/notification_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/app_lifecycle_manager.dart';
import 'package:reach_me/core/utils/bloc_observer.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/features/auth/presentation/views/splash_screen.dart';

import 'core/services/moment/controller.dart';
import 'features/timeline/timeline_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initSingletons();
  OneSignal.shared.setLogLevel(OSLogLevel.none, OSLogLevel.none);
  await OneSignal.shared.setAppId("4f584eee-135c-46bc-8986-8dfd980f4d3c");
  OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);
  await NotifcationService.handleNotifications();
  Bloc.observer = AppBlocObserver();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
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
    Get.lazyPut(() => MomentController(), fenix: true);
    Get.lazyPut(() => TimeLineController(), fenix: true);
    return GraphQLProvider(
      client: clientFor(),
      child: GraphQLProvider(
        client: chatClientFor(),
        child: LifeCycleManager(
          child: OverlaySupport.global(
            child: Portal(
              child: GetMaterialApp(
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
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 8.0),
                  ),
                ),
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