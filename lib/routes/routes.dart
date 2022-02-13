import 'package:reach_me/screens/auth/verify_account_success.dart';
import 'package:reach_me/screens/home/account.dart';
import 'package:reach_me/screens/home/chats_list_screen.dart';
import 'package:reach_me/screens/home/timeline.dart';
import 'package:reach_me/screens/auth/forgot_password.dart';
import 'package:reach_me/screens/home/home_screen.dart';
import 'package:reach_me/screens/auth/login_screen.dart';
import 'package:reach_me/screens/home/video_moment.dart';
import 'package:reach_me/screens/home/notification.dart';
import 'package:reach_me/screens/home/search.dart';
import 'package:reach_me/screens/onboarding/onboarding.dart';
import 'package:reach_me/screens/auth/reset_password.dart';
import 'package:reach_me/screens/auth/signup_screen.dart';
import 'package:reach_me/screens/splash_screen.dart';
import 'package:reach_me/routes/page_route.dart';
import 'package:reach_me/screens/auth/verify_account.dart';
import 'package:flutter/material.dart';

class RMRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreenAnimator.id:
        return RMPageRoute(builder: (_) => const SplashScreenAnimator());

      case OnboardingScreen.id:
        return RMPageRoute(builder: (_) => OnboardingScreen());

      case SignUpScreen.id:
        return RMPageRoute(builder: (_) => SignUpScreen());

      case LoginScreen.id:
        return RMPageRoute(builder: (_) => LoginScreen());

      case ForgotPasswordScreen.id:
        return RMPageRoute(builder: (_) => ForgotPasswordScreen());

      case VerifyAccountScreen.id:
        dynamic args = settings.arguments;
        return RMPageRoute(
            builder: (_) => VerifyAccountScreen(
                  token: args['token'],
                  uid: args['uid'],
                ));

      case VerifyAccountSuccess.id:
        return RMPageRoute(builder: (_) => const VerifyAccountSuccess());

      case ResetPasswordScreen.id:
        return RMPageRoute(builder: (_) => const ResetPasswordScreen());

      case HomeScreen.id:
        return RMPageRoute(builder: (_) => const HomeScreen());

      case TimelineScreen.id:
        return RMPageRoute(builder: (_) => const TimelineScreen());
        
      case ChatsListScreen.id:
        return RMPageRoute(builder: (_) => const ChatsListScreen());

      case SearchScreen.id:
        return RMPageRoute(builder: (_) => const SearchScreen());

      case VideoMomentScreen.id:
        return RMPageRoute(builder: (_) => const VideoMomentScreen());

      case NotificationsScreen.id:
        return RMPageRoute(builder: (_) => const NotificationsScreen());

      case AccountScreen.id:
        return RMPageRoute(builder: (_) => const AccountScreen());

      // case '/main-page':
      //   dynamic args = settings.arguments ?? {"index": 0};
      //   return EgoWavePageRoute(
      //       builder: (_) => MainPage(
      //             index: args['index'] ?? 0,
      //           ));
      //   break;
      // case '/login':
      //   return EgoWavePageRoute(builder: (_) => Signin());
      // case '/personal-details-verification':
      //   return EgoWavePageRoute(builder: (_) => PersonalDetailVerification());
      // case '/kyc-completed':
      //   dynamic args = settings.arguments ?? {"applied": false};
      //   return EgoWavePageRoute(
      //       builder: (_) =>
      //           KYCCompletedScreen(applied: args['applied'] ?? false));
      // case '/kyc-scan':
      //   dynamic args = settings.arguments;
      //   return EgoWavePageRoute(
      //       builder: (_) => KYCScan(
      //             cameras: args['cameras'],
      //           ));
      // case '/kyc-selfie-scan':
      //   dynamic args = settings.arguments;
      //   return EgoWavePageRoute(
      //       builder: (_) => KYCSelfieScan(
      //             cameras: args['cameras'],
      //           ));
      // case '/reset-pin':
      //   return EgoWavePageRoute(builder: (_) => ResetPin());
      // case '/confirm-pin':
      //   dynamic args = settings.arguments;

      //   return EgoWavePageRoute(
      //       builder: (_) => ConfirmPin(
      //             args['pin'],
      //           ));

      // case '/set-access-pin':
      //   return EgoWavePageRoute(builder: (_) => SetAccessPin());

      default:
        return RMPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('Something went wrong')),
                ));
    }
  }
}
