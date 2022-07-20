import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
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
        // final token = await SecureStorage.readSecureData('token');
        // final email = await SecureStorage.readSecureData('email');
        // final fname = await SecureStorage.readSecureData('fname');
        // globals.email = email;
        // if (token != null && email != null) {
        //   globals.token = token;
        //   globals.fname = fname;
        //   Console.log('mytoken', globals.token);
        //   RouteNavigators.routeNoWayHome(context, const HomeScreen());
        //   return;
        // } else {
        RouteNavigators.routeReplace(context, OnboardingScreen());
        // }
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
  SplashScreen(
      {Key? key, required AnimationController controller, required Size size})
      : animation = SplashScreenEnterAnimation(controller, size),
        super(key: key);

  final SplashScreenEnterAnimation animation;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation.controller,
        builder: (context, child) {
          return Scaffold(
            backgroundColor: AppColors.primaryColor,
            body: Stack(
              children: [
                animation.secondContainerOpacity.value == 0
                    ? Opacity(
                        opacity: animation.imageOpacity.value,
                        child: Column(
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
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          );
        });
  }
}

class SplashScreenEnterAnimation {
  SplashScreenEnterAnimation(this.controller, this.size)
      : firstContainerHeight =
            Tween<double>(begin: size.height, end: 150).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.25, curve: Curves.easeInOutQuad),
          ),
        ),
        firstContainerWidth = Tween<double>(begin: size.width, end: 70).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.25, curve: Curves.easeInOutQuad),
          ),
        ),
        firstContainerBorderRadius = BorderRadiusTween(
                begin: BorderRadius.circular(25),
                end: BorderRadius.circular(221))
            .animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.25, curve: Curves.easeInOutQuad),
          ),
        ),
        firstContainerOpacity = Tween<double>(begin: 1, end: 0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.25, 0.30, curve: Curves.easeInOutQuad),
          ),
        ),
        secondContainerHeight =
            Tween<double>(begin: 0.0, end: size.height).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.35, 0.50, curve: SineCurve()),
          ),
        ),
        secondContainerWidth =
            Tween<double>(begin: 0.0, end: size.width).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.35, 0.50, curve: SineCurve()),
          ),
        ),
        secondContainerBorderRadius = BorderRadiusTween(
                begin: BorderRadius.circular(25),
                end: BorderRadius.circular(221))
            .animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.35, 0.50, curve: SineCurve()),
          ),
        ),
        secondContainerOpacity = Tween<double>(begin: 1, end: 0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.50, 0.55, curve: SineCurve()),
          ),
        ),
        imageOpacity = Tween<double>(begin: 0.0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.57, 1, curve: Curves.easeIn),
          ),
        );

  Size size;
  final AnimationController controller;
  final Animation<double> firstContainerHeight;
  final Animation<double> firstContainerWidth;
  final Animation<BorderRadius?> firstContainerBorderRadius;
  final Animation<double> firstContainerOpacity;
  final Animation<double> secondContainerHeight;
  final Animation<double> secondContainerWidth;
  final Animation<BorderRadius?> secondContainerBorderRadius;
  final Animation<double> secondContainerOpacity;
  final Animation<double> imageOpacity;
}

class SineCurve extends Curve {
  final double count;

  const SineCurve({this.count = 1});

  // t = x
  @override
  double transformInternal(double t) {
    var val = sin(count * pi * t) * 0.5 + 0.5;
    return val; //f(x)
  }
}

//SHADER TO MASK COLOUR OF SVG IMAGE
// class GradientSvg extends StatelessWidget {
//   const GradientSvg({
//     Key? key,
//     required this.svg,
//     required this.size,
//     required this.gradient,
//   }) : super(key: key);

//   final String svg;
//   final double size;
//   final Gradient gradient;

//   @override
//   Widget build(BuildContext context) {
//     return ShaderMask(
//       child: SizedBox(
//         width: size * 1.2,
//         height: size * 1.2,
//         child: SvgPicture.asset(svg),
//       ),
//       shaderCallback: (Rect bounds) {
//         final Rect rect = Rect.fromLTRB(0, 0, size, size);
//         return gradient.createShader(rect);
//       },
//     );
//   }
// }
