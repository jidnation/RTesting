import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/features/auth/presentation/views/login_screen.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:flutter/material.dart';

class VerifyAccountSuccess extends StatelessWidget {
  static const String id = 'verify_account_success';
  const VerifyAccountSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.white,
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: size.height * 0.1),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                          image: AssetImage('assets/images/check-circle.png')),
                      Text('Congratulations!',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w500,
                          )),
                      SizedBox(height: 25),
                      Expanded(
                        child: Text(
                            'Your account has been verified! Tap on the button below to log into your EgoWave account.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF999999),
                                height: 1.3)),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                    label: 'CONTINUE TO LOG IN',
                    color: AppColors.secondaryColor,
                    onPressed: () {
                      RouteNavigators.route(context, LoginScreen());
                    },
                    size: size,
                    textColor: Colors.white,
                    borderSide: BorderSide.none)
              ],
            ),
          ),
        ));
  }
}
