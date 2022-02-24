import 'package:reach_me/screens/auth/otp_screen.dart';
import 'package:reach_me/screens/account/account.dart';
import 'package:reach_me/screens/chat/chats_list_screen.dart';
import 'package:reach_me/screens/account/edit_profile_screen.dart';
import 'package:reach_me/screens/chat/msg_chat_interface.dart';
import 'package:reach_me/screens/account/personal_info_settings.dart';
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
import 'package:reach_me/screens/onboarding/welcome_screen.dart';
import 'package:reach_me/screens/splash_screen.dart';
import 'package:reach_me/routes/page_route.dart';
import 'package:flutter/material.dart';

class RMRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreenAnimator.id:
        return RMPageRoute(builder: (_) => const SplashScreenAnimator());

      case OnboardingScreen.id:
        return RMPageRoute(builder: (_) => OnboardingScreen());

      case WelcomeScreen.id:
        return RMPageRoute(builder: (_) => const WelcomeScreen());

      case SignUpScreen.id:
        return RMPageRoute(builder: (_) => SignUpScreen());

      case LoginScreen.id:
        return RMPageRoute(builder: (_) => LoginScreen());

      case ForgotPasswordScreen.id:
        return RMPageRoute(builder: (_) => ForgotPasswordScreen());

      case OtpScreen.id:
        return RMPageRoute(builder: (_) => OtpScreen());

      // case VerifyAccountScreen.id:
      //   dynamic args = settings.arguments;
      //   return RMPageRoute(
      //       builder: (_) => VerifyAccountScreen(
      //             token: args['token'],
      //             uid: args['uid'],
      //           ));

      // case VerifyAccountSuccess.id:
      //   return RMPageRoute(builder: (_) => const VerifyAccountSuccess());

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

      case EditProfileScreen.id:
        return RMPageRoute(builder: (_) => const EditProfileScreen());

      case PersonalInfoSettings.id:
        return RMPageRoute(builder: (_) => const PersonalInfoSettings());

      case MsgChatInterface.id:
        return RMPageRoute(builder: (_) => const MsgChatInterface());

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
