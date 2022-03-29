import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/features/auth/presentation/views/reset_password.dart';
import 'package:reach_me/core/utils/constants.dart';

class OtpScreen extends StatelessWidget {
  static const String id = 'otp_screen';

  final String? token;
  final String? uid;

  //pin input
  late final String? altPin;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      color: const Color(0xFFF2EFEF),
      borderRadius: BorderRadius.circular(4.0),
    );
  }

  OtpScreen({Key? key, this.token, this.uid, this.altPin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  'assets/svgs/illustration 6-new.svg',
                  height: 186,
                  width: 290,
                ),
              ),
              const SizedBox(height: 60.0),
              const Text(
                'Enter OTP',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'An 4 digit code has been sent to your email: stanqicha@gmail.com',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1B1B1A),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: PinPut(
                    fieldsCount: 4,
                    separator: const SizedBox(width: 15.0),
                    mainAxisSize: MainAxisSize.max,
                    fieldsAlignment: MainAxisAlignment.spaceEvenly,
                    onSubmit: (String pin) =>
                        {NavigationService.navigateTo(ResetPasswordScreen.id)},
                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    submittedFieldDecoration: _pinPutDecoration.copyWith(),
                    selectedFieldDecoration: _pinPutDecoration,
                    followingFieldDecoration: _pinPutDecoration.copyWith(
                      border: Border.all(color: const Color(0xFFF2EFEF)),
                    ),
                    cursor: const Text('|'),
                    withCursor: true,
                    initialValue: '',
                    preFilledWidget: const Text('')),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {},
                child: RichText(
                  textScaleFactor: 0.8,
                  text: const TextSpan(
                    text: "Didn't receive a code? ",
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontFamily: 'Poppins',
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text: 'Resend',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    ));
  }
}
