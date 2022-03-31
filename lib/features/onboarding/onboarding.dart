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
        description: 'Start connecting to your world.',
        titleColor: const Color(0xFF001533),
        descripColor: const Color(0xFF767474),
        imagePath: 'assets/svgs/illustration 1-new.svg'),
    RMOnboardingModel(
        title: 'Smooth and easy',
        description: 'Enjoy a better Visual and Audio\nCommunication',
        titleColor: const Color(0xFF001533),
        descripColor: const Color(0xFF767474),
        imagePath: 'assets/svgs/illustration 2-new.svg'),
    RMOnboardingModel(
        title: 'Secure at all times',
        description: 'Better High-Level Security',
        titleColor: const Color(0xFF001533),
        descripColor: const Color(0xFF767474),
        imagePath: 'assets/svgs/illustration 3-new.svg'),
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: RMOnboardingScreen(
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
      ),
    );
  }
}
