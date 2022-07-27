import 'package:reach_me/core/routes/page_route.dart';
import 'package:reach_me/features/account/presentation/views/qr_code.dart';
import 'package:reach_me/features/account/presentation/views/saved_post.dart';
import 'package:reach_me/features/account/presentation/views/scan_qr_code.dart';
import 'package:reach_me/features/account/presentation/views/starred_profile.dart';
import 'package:reach_me/features/auth/presentation/views/otp_screen.dart';
import 'package:reach_me/features/account/presentation/views/account.dart';
import 'package:reach_me/features/auth/presentation/views/splash_screen.dart';
import 'package:reach_me/features/chat/presentation/views/chats_list_screen.dart';
import 'package:reach_me/features/account/presentation/views/edit_profile_screen.dart';
import 'package:reach_me/features/chat/presentation/views/msg_chat_interface.dart';
import 'package:reach_me/features/account/presentation/views/personal_info_settings.dart';
import 'package:reach_me/features/home/presentation/views/home_screen.dart';
import 'package:reach_me/features/home/presentation/views/search.dart';
import 'package:reach_me/features/home/presentation/views/timeline.dart';
import 'package:reach_me/features/auth/presentation/views/forgot_password.dart';
import 'package:reach_me/features/auth/presentation/views/login_screen.dart';
import 'package:reach_me/features/home/presentation/views/notification.dart';
import 'package:reach_me/features/home/presentation/views/video_moment.dart';
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

      case RecipientAccountProfile.id:
        return RMPageRoute(builder: (_) => const RecipientAccountProfile());

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

      // case Dictionary.id:
      //   return RMPageRoute(builder: (_) => const Dictionary());

      // case Abbreviation.id:
      //   return RMPageRoute(builder: (_) => const Abbreviation());

      default:
        return RMPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('Something went wrong')),
                ));
    }
  }
}
