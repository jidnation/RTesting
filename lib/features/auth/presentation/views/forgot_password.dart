import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/loader.dart';
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
        body: BlocConsumer<AuthBloc, AuthState>(
            bloc: globals.authBloc,
            listener: (context, state) {
              if (state is AuthSendResetPasswordEmail) {
                RouteNavigators.route(
                  context,
                  ResetPasswordOtpScreen(email: _emailController.text.replaceAll(' ', '')),
                );
              } else if (state is AuthError) {
                RMSnackBar.showErrorSnackBar(context, message: state.error);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const RLoader('');
              }
              return SafeArea(
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
                        CustomRoundTextField(
                          borderRadius: 8,
                          isFilled: false,
                          hintText: 'abc@example.com',
                          textCapitalization: TextCapitalization.none,
                          controller: _emailController,
                          focusedBorderSide: const BorderSide(
                            width: 1,
                            color: AppColors.primaryColor,
                          ),
                          enabledBorderSide: const BorderSide(
                            width: 1,
                            color: AppColors.greyShade5,
                          ),
                        ).paddingSymmetric(h: 45),
                        const SizedBox(height: 34),
                        CustomButton(
                          label: 'Send',
                          color: AppColors.primaryColor,
                          onPressed: () {
                            globals.authBloc!.add(RequestPasswordResetEvent(
                                email:
                                    _emailController.text.replaceAll(' ', '')));
                          },
                          size: size,
                          textColor: AppColors.white,
                          borderSide: BorderSide.none,
                        ).paddingSymmetric(h: 45),
                        const SizedBox(height: 20),
                      ],
                    )),
              );
            }));
  }
}
