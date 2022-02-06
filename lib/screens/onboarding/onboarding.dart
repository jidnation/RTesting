import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/screens/auth/login_screen.dart';
import 'package:reach_me/screens/onboarding/rm_onboarding_model.dart';
import 'package:reach_me/screens/onboarding/rm_onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/utils/constants.dart';

class OnboardingScreen extends StatelessWidget {
  static const String id = "onboarding_screen";
  OnboardingScreen({Key? key}) : super(key: key);

  final List<RMOnboardingModel>? pages = [
    RMOnboardingModel(
        title: 'Welcome to ReachMe',
        description: 'Start connecting to your world.',
        titleColor: const Color(0xFF001533),
        descripColor: const Color(0xFF767474),
        imagePath: 'assets/svgs/illustration1.svg'),
    RMOnboardingModel(
        title: '',
        description: 'Enjoy a better Visual and Audio\nCommunication',
        titleColor: const Color(0xFF001533),
        descripColor: const Color(0xFF767474),
        imagePath: 'assets/svgs/illustration2.svg'),
    RMOnboardingModel(
        title: '',
        description: 'Better High-Level Security',
        titleColor: const Color(0xFF001533),
        descripColor: const Color(0xFF767474),
        imagePath: 'assets/svgs/illustration3.svg'),
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
            NavigationService.navigateTo(LoginScreen.id);
          },
          getStartedClicked: (value) {
            NavigationService.navigateTo(LoginScreen.id);
          },
        ),
      ),
    );
  }
}
