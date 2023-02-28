import 'package:flutter/material.dart';
import 'package:reach_me/core/routes/page_route.dart';
import 'package:reach_me/features/account/presentation/views/starred_profile.dart';
import 'package:reach_me/features/auth/presentation/views/forgot_password.dart';
import 'package:reach_me/features/auth/presentation/views/login_screen.dart';
import 'package:reach_me/features/auth/presentation/views/otp_screen.dart';
import 'package:reach_me/features/auth/presentation/views/reset_password.dart';
import 'package:reach_me/features/auth/presentation/views/signup_screen.dart';
import 'package:reach_me/features/auth/presentation/views/splash_screen.dart';
import 'package:reach_me/features/chat/presentation/views/chats_list_screen.dart';
import 'package:reach_me/features/chat/presentation/views/msg_chat_interface.dart';
import 'package:reach_me/features/home/presentation/views/home_screen.dart';
import 'package:reach_me/features/home/presentation/views/notification.dart';
import 'package:reach_me/features/onboarding/onboarding.dart';
import 'package:reach_me/features/onboarding/welcome_screen.dart';

import '../../features/call/presentation/views/initiate_video_call.dart';

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
        return RMPageRoute(builder: (_) => const LoginScreen());

      case ForgotPasswordScreen.id:
        return RMPageRoute(builder: (_) => const ForgotPasswordScreen());

      case OtpScreen.id:
        return RMPageRoute(builder: (_) => OtpScreen());

      case ResetPasswordOtpScreen.id:
        return RMPageRoute(builder: (_) => ResetPasswordOtpScreen());

      case ResetPasswordScreen.id:
        return RMPageRoute(builder: (_) => const ResetPasswordScreen());

      case HomeScreen.id:
        return RMPageRoute(builder: (_) => const HomeScreen());

      case ChatsListScreen.id:
        return RMPageRoute(builder: (_) => const ChatsListScreen());

      case NotificationsScreen.id:
        return RMPageRoute(builder: (_) => const NotificationsScreen());

      case StarredProfileScreen.id:
        return RMPageRoute(builder: (_) => const StarredProfileScreen());

      case MsgChatInterface.id:
        return RMPageRoute(builder: (_) => const MsgChatInterface());

      case InitiateVideoCall.id:
        return RMPageRoute(builder: (_) => const InitiateVideoCall());

      default:
        return RMPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Something went wrong')),
          ),
        );
    }
  }
}
