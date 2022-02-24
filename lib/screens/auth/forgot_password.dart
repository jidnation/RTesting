import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/components/custom_button.dart';
import 'package:reach_me/components/custom_textfield.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/screens/auth/otp_screen.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:reach_me/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ForgotPasswordScreen extends HookConsumerWidget {
  static const String id = 'forgot_password';
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
                  'assets/svgs/illustration 5-new.svg',
                  height: 186,
                  width: 290,
                ),
              ),
              const SizedBox(height: 25.0),
              const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Don’t worry! it happens. Please enter\nthe address associated with your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1B1B1A),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyShade2,
                    fontSize: 13,
                  ),
                ),
              ).paddingSymmetric(h: 45),
              const SizedBox(height: 5),
              const CustomRoundTextField(
                borderRadius: 8,
                isFilled: false,
                hintText: 'abc@example.com',
                textCapitalization: TextCapitalization.none,
                focusedBorderSide:
                    BorderSide(width: 1, color: AppColors.primaryColor),
                enabledBorderSide:
                    BorderSide(width: 1, color: AppColors.greyShade5),
              ).paddingSymmetric(h: 45),
              const SizedBox(height: 34),
              CustomButton(
                      label: 'Send',
                      color: AppColors.primaryColor,
                      onPressed: () {
                        NavigationService.navigateTo(OtpScreen.id);
                      },
                      size: size,
                      textColor: AppColors.white,
                      borderSide: BorderSide.none)
                  .paddingSymmetric(h: 45),
              const SizedBox(height: 20),
            ],
          )),
    ));
  }
}
