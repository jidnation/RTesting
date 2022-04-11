import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/features/onboarding/rm_onboarding_model.dart';
import 'package:reach_me/features/onboarding/rm_onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/features/onboarding/welcome_screen.dart';
import 'package:reach_me/core/utils/constants.dart';

class OnboardingScreen extends StatelessWidget {
  static const String id = "onboarding_screen";
  OnboardingScreen({Key? key}) : super(key: key);

  final List<RMOnboardingModel>? pages = [
    RMOnboardingModel(
        title: 'Welcome to ReachMe',
        description:
            'Connect to your world, reach friends and family, chat in diverse languages, provide meanings to words and bring your culture to light',
        titleColor: const Color(0xFF001533),
        descripColor: const Color(0xFF767474),
        imagePath: 'assets/svgs/onboarding-1.svg'),
    RMOnboardingModel(
        title: 'Enjoy audio features',
        description: 'Post reaches, status and make comments\nin audio form',
        titleColor: const Color(0xFF001533),
        descripColor: const Color(0xFF767474),
        imagePath: 'assets/svgs/onboarding-2.svg'),
    RMOnboardingModel(
        title: 'Shoutout and Shoutdown posts',
        description:
            'Be in control of your reachme ecosystem, decide reaches that are legible to stay',
        titleColor: const Color(0xFF001533),
        descripColor: const Color(0xFF767474),
        imagePath: 'assets/svgs/onboarding-3.svg'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RMOnboardingScreen(
        bgColor: AppColors.white,
        themeColor: AppColors.primaryColor,
        pages: pages,
        skipClicked: (value) {
          RouteNavigators.route(context, const WelcomeScreen());
        },
        getStartedClicked: (value) {
          RouteNavigators.route(context, const WelcomeScreen());
        },
      ),
    );
  }
}
