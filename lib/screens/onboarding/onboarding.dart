import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/screens/onboarding/rm_onboarding_model.dart';
import 'package:reach_me/screens/onboarding/rm_onboarding_screen.dart';
import 'package:reach_me/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/utils/constants.dart';

class OnboardingScreen extends StatelessWidget {
  static const String id = "onboarding_screen";
  OnboardingScreen({Key? key}) : super(key: key);

  final List<RMOnboardingModel>? pages = [
    RMOnboardingModel(
        title: 'Save money',
        description:
            'We help you meet your savings target monthly and our emergency plans enable you save for multiple purposes',
        titleColor: const Color(0xFF001533),
        descripColor: const Color(0xFF001533),
        imagePath: 'assets/gifs/save.gif'),
    RMOnboardingModel(
        title: 'Withdraw your money',
        description:
            'With just your phone number, you can withdraw your funds at any point in time from any BankMe agent close to you.',
        titleColor: const Color(0xFF001533),
        descripColor: const Color(0xFF001533),
        imagePath: 'assets/gifs/withdraw.gif'),
    RMOnboardingModel(
        title: 'Invest your money',
        description:
            'Get access to risk free investments that will multiply your income and pay high returns in few months',
        titleColor: const Color(0xFF001533),
        descripColor: const Color(0xFF001533),
        imagePath: 'assets/gifs/investment.gif'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: EgoWaveOnboardingScreen(
          bgColor: Colors.white,
          themeColor: AppColors.primaryColor,
          pages: pages,
          skipClicked: (value) {
            NavigationService.navigateTo(WelcomeScreen.id);
          },
          getStartedClicked: (value) {
            NavigationService.navigateTo(WelcomeScreen.id);
          },
        ),
      ),
    );
  }
}
