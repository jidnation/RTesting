import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/services/database/secure_storage.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/home/presentation/views/home_screen.dart';
import 'package:reach_me/features/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';

class SplashScreenAnimator extends StatefulWidget {
  static const String id = "splash_screen";
  const SplashScreenAnimator({Key? key}) : super(key: key);

  @override
  _SplashScreenAnimatorState createState() => _SplashScreenAnimatorState();
}

class _SplashScreenAnimatorState extends State<SplashScreenAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    globals.init();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _controller.forward();
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        final token = await SecureStorage.readSecureData('token');
        final email = await SecureStorage.readSecureData('email');
        final fname = await SecureStorage.readSecureData('fname');
        final userId = await SecureStorage.readSecureData('userId');
        globals.email = email;
        if (token != null && email != null) {
          globals.token = token;
          globals.fname = fname;
          globals.userId = userId;
          RouteNavigators.routeNoWayHome(context, const HomeScreen());
          return;
        } else {
          RouteNavigators.routeReplace(context, OnboardingScreen());
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return SplashScreen(
      controller: _controller,
      size: size,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen(
      {Key? key, required AnimationController controller, required Size size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Stack(children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Center(
                child: SvgPicture.asset(
                  'assets/svgs/logo-blue.svg',
                  color: AppColors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'By',
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColors.white,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Televerse',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]));
  }
}
