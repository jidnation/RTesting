import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/loader.dart';
import 'package:reach_me/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reach_me/features/auth/presentation/views/login_screen.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/features/auth/presentation/views/reset_password.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({Key? key, this.token, this.email, this.altPin}) : super(key: key);
  static const String id = 'otp_screen';
  //args
  final String? token;
  final String? email;

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          bloc: globals.authBloc,
          listener: (context, state) {
            if (state is AuthEmailVerified) {
              RouteNavigators.routeNoWayHome(context, const LoginScreen());
              SchedulerBinding.instance!
                  .addPostFrameCallback((timeStamp) => Snackbars.success(
                        context,
                        message: state.message!,
                        milliseconds: 3000,
                      ));
            } else if (state is PinInvalid) {
              Snackbars.error(context, message: state.error!);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const RLoader('');
            }
            return SizedBox(
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
                  Text(
                    'A 6 digit code has been sent to your email: $email',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1B1B1A),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: PinPut(
                        fieldsCount: 6,
                        separator: const SizedBox(width: 15.0),
                        mainAxisSize: MainAxisSize.max,
                        fieldsAlignment: MainAxisAlignment.spaceEvenly,
                        onChanged: (val) {
                          if (val.length == 6) {
                            final pin = int.parse(_pinPutController.text);
                            globals.authBloc!.add(
                                EmailVerificationEvent(email: email, pin: pin));
                          }
                        },
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
              ),
            );
          },
        ),
      ),
    );
  }
}

class ResetPasswordOtpScreen extends StatelessWidget {
  ResetPasswordOtpScreen({Key? key, this.email}) : super(key: key);
  static const String id = 'rst_password_otp_screen';
  //args
  final String? email;

  //pin input
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      color: const Color(0xFFF2EFEF),
      borderRadius: BorderRadius.circular(4.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
              bloc: globals.authBloc,
              listener: (context, state) {
                if (state is VerifyResetPinSuccess) {
                  RouteNavigators.route(
                      context, ResetPasswordScreen(token: state.token));
                } else if (state is PinInvalid) {
                  Snackbars.error(context, message: state.error!);
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const RLoader('');
                }
                return SizedBox(
                    height: size.height,
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Center(
                          child: SvgPicture.asset(
                            'assets/svgs/otp.svg',
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
                        Text(
                          'An 6 digit code has been sent to your\nemail: $email',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF1B1B1A),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 45.0),
                          child: PinPut(
                              fieldsCount: 6,
                              separator: const SizedBox(width: 15.0),
                              mainAxisSize: MainAxisSize.max,
                              fieldsAlignment: MainAxisAlignment.spaceEvenly,
                              onChanged: (val) {
                                if (val.length == 6) {
                                  final pin = int.parse(_pinPutController.text);
                                  globals.authBloc!
                                      .add(VerifyPasswordResetPinEvent(
                                    email: email,
                                    pin: pin,
                                  ));
                                }
                              },
                              focusNode: _pinPutFocusNode,
                              controller: _pinPutController,
                              submittedFieldDecoration:
                                  _pinPutDecoration.copyWith(),
                              selectedFieldDecoration: _pinPutDecoration,
                              followingFieldDecoration:
                                  _pinPutDecoration.copyWith(
                                border:
                                    Border.all(color: const Color(0xFFF2EFEF)),
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
                    ));
              }),
        ));
  }
}
