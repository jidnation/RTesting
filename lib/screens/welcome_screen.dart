import 'package:reach_me/components/custom_button.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/screens/auth/login_screen.dart';
import 'package:reach_me/screens/auth/signup_screen.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
          width: size.width,
          height: size.height,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to Ego Wave',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'The bank for everyone',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 150),
                CustomButton(
                  size: size,
                  label: 'CREATE YOUR FREE ACCOUNT',
                  color: AppColors.primaryColor,
                  textColor: AppColors.white,
                  borderSide: BorderSide.none,
                  onPressed: () {
                    NavigationService.navigateTo(SignUpScreen.id);
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  size: size,
                  label: 'LOG INTO YOUR ACCOUNT',
                  color: AppColors.white,
                  textColor: AppColors.black,
                  borderSide: const BorderSide(
                    color: Color(0xFF999999),
                    width: 1,
                  ),
                  onPressed: () {
                    NavigationService.navigateTo(LoginScreen.id);
                  },
                ),
              ],
            ),
          )),
    );
  }
}
