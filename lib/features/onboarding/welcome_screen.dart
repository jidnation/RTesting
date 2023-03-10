import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/features/auth/presentation/views/login_screen.dart';
import 'package:reach_me/features/auth/presentation/views/signup_screen.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Center(
                child: SvgPicture.asset(
                  'assets/svgs/Sign Up.svg',
                  height: 250,
                  width: 290,
                ),
              ),
              const SizedBox(height: 25.0),
              const Text(
                'Welcome Reacher',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor2,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Enjoy the best of communication,\nreach family and friends and high\nsecurity',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF767474),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(
                label: 'Login',
                color: AppColors.buttonColor,
                onPressed: () =>
                    RouteNavigators.route(context, const LoginScreen()),
                size: size,
                textColor: AppColors.white,
                borderSide: BorderSide.none,
              ).paddingSymmetric(h: 45),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Sign up',
                color: AppColors.white,
                onPressed: () => RouteNavigators.route(context, SignUpScreen()),
                size: size,
                textColor: AppColors.textColor2,
                borderSide: const BorderSide(
                  color: AppColors.textColor2,
                  width: 1,
                ),
              ).paddingSymmetric(h: 45),
            ],
          ),
        ),
      ),
    );
  }
}
