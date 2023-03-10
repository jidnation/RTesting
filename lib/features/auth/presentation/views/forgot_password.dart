import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/loader.dart';
import 'package:reach_me/core/utils/validator.dart';
import 'package:reach_me/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:reach_me/features/auth/presentation/views/otp_screen.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends HookWidget {
  static const String id = 'forgot_password';
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final _emailController = useTextEditingController();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: globals.authBloc,
        listener: (context, state) {
          if (state is AuthSendResetPasswordEmail) {
            RouteNavigators.route(
              context,
              ResetPasswordOtpScreen(
                  email: _emailController.text.replaceAll(' ', '')),
            );
          } else if (state is AuthError) {
            Snackbars.error(context, message: state.error);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const RLoader('');
          }
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              height: size.height,
              child: SafeArea(
                child: SizedBox(
                  height: size.height,
                  // width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 50.0, bottom: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Center(
                          child: SvgPicture.asset(
                            'assets/svgs/forgot.svg',
                            height: 240,
                            width: 290,
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor2,
                            fontSize: 19,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Don???t worry! It happens. Please enter\nthe address associated with your account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF767474),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: TextStyle(
                              fontSize: getScreenHeight(15),
                              color: AppColors.textColor2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                       const SizedBox(height: 5),
                        CustomRoundTextField(
                          focusedBorderSide: const BorderSide(color: Colors.black12, width: 1, style: BorderStyle.solid),
                          enabledBorderSide: const BorderSide(color: Colors.black12, width: 1, style: BorderStyle.solid),
                          isFilled: false,
                          hintText: 'linda@framcreative.com',
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) => Validator.validateEmail(value ?? ""),
                          controller: _emailController,
                          hintStyle: TextStyle(
                            color: Colors.black26,
                            fontSize: getScreenHeight(15),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 34),
                        CustomButton(
                          label: 'Send',
                          color: AppColors.buttonColor,
                          onPressed: () {
                            globals.authBloc!.add(RequestPasswordResetEvent(
                                email: _emailController.text.replaceAll(' ', '')));
                          },
                          size: size,
                          textColor: AppColors.white,
                          borderSide: BorderSide.none,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
