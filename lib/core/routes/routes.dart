import 'package:reach_me/core/routes/page_route.dart';
import 'package:reach_me/features/account/presentation/views/abbreviation.dart';
import 'package:reach_me/features/account/presentation/views/dictionary.dart';
import 'package:reach_me/features/account/presentation/views/qr_code.dart';
import 'package:reach_me/features/account/presentation/views/saved_post.dart';
import 'package:reach_me/features/account/presentation/views/scan_qr_code.dart';
import 'package:reach_me/features/account/presentation/views/starred_profile.dart';
import 'package:reach_me/features/auth/presentation/views/otp_screen.dart';
import 'package:reach_me/features/account/presentation/views/account.dart';
import 'package:reach_me/features/chat/presentation/views/chats_list_screen.dart';
import 'package:reach_me/features/account/presentation/views/edit_profile_screen.dart';
import 'package:reach_me/features/chat/presentation/views/msg_chat_interface.dart';
import 'package:reach_me/features/account/presentation/views/personal_info_settings.dart';
import 'package:reach_me/features/home/splash_screen.dart';
import 'package:reach_me/features/timeline/presentation/views/timeline.dart';
import 'package:reach_me/features/auth/presentation/views/forgot_password.dart';
import 'package:reach_me/features/home/home_screen.dart';
import 'package:reach_me/features/auth/presentation/views/login_screen.dart';
import 'package:reach_me/features/home/video_moment.dart';
import 'package:reach_me/features/activity/presentation/notification.dart';
import 'package:reach_me/features/home/search.dart';
import 'package:reach_me/features/onboarding/onboarding.dart';
import 'package:reach_me/features/auth/presentation/views/reset_password.dart';
import 'package:reach_me/features/auth/presentation/views/signup_screen.dart';
import 'package:reach_me/features/onboarding/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/features/video-call/video_call_screen.dart';
import 'package:reach_me/features/video-call/video_calling_screen.dart';
import 'package:reach_me/features/voice-call/voice_call_screen.dart';
import 'package:reach_me/features/voice-call/voice_calling_screen.dart';

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
        return RMPageRoute(builder: (_) => const ForgotPasswordScreen());

      case OtpScreen.id:
        dynamic args = settings.arguments;
        return RMPageRoute(builder: (_) => OtpScreen(email: args['email']));

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
        return RMPageRoute(builder: (_) => TimelineScreen());

      case ChatsListScreen.id:
        return RMPageRoute(builder: (_) => const ChatsListScreen());

      case SearchScreen.id:
        return RMPageRoute(builder: (_) => SearchScreen());

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

      case StarredProfileScreen.id:
        return RMPageRoute(builder: (_) => const StarredProfileScreen());

      case MsgChatInterface.id:
        return RMPageRoute(builder: (_) => const MsgChatInterface());

      case VoiceCallScreen.id:
        return RMPageRoute(builder: (_) => const VoiceCallScreen());

      case VoiceCallingScreen.id:
        return RMPageRoute(builder: (_) => const VoiceCallingScreen());

      case VideoCallScreen.id:
        return RMPageRoute(builder: (_) => const VideoCallScreen());

      case VideoCallingScreen.id:
        return RMPageRoute(builder: (_) => const VideoCallingScreen());

      case SavedPostScreen.id:
        return RMPageRoute(builder: (_) => const SavedPostScreen());

      case QRCodeScreen.id:
        return RMPageRoute(builder: (_) => const QRCodeScreen());

      case ScanQRCodeScreen.id:
        return RMPageRoute(builder: (_) => const ScanQRCodeScreen());

      case Dictionary.id:
        return RMPageRoute(builder: (_) => const Dictionary());

      case Abbreviation.id:
        return RMPageRoute(builder: (_) => const Abbreviation());

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
