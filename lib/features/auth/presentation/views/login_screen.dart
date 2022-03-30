import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/features/auth/presentation/views/forgot_password.dart';
import 'package:reach_me/features/auth/presentation/views/signup_screen.dart';
import 'package:reach_me/features/home/home_screen.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/validator.dart';
import 'package:flutter/material.dart';

class LoginScreen extends HookWidget {
  static const String id = 'login_screen';
  LoginScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final _emailController = useTextEditingController();
    final _passwordController = useTextEditingController();
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.white,
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: CustomScrollView(slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 50.0, bottom: 30.0),
                child: Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(child: SizedBox()),
                      SvgPicture.asset(
                        'assets/svgs/logo-new.svg',
                        width: size.width * 0.15,
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'Login to your account',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textFieldLabelColor,
                          ),
                        ),
                      ),
                      CustomTextField(
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) =>
                            Validator.validateEmail(value ?? ""),
                        controller: _emailController,
                        suffixIcon: const Icon(
                          Icons.check,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password (6 or more characters)',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textFieldLabelColor,
                          ),
                        ),
                      ),
                      CustomTextField(
                        hintText: '********',
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        controller: _passwordController,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) =>
                            Validator.validatePassword(value ?? ""),
                        suffixIcon: const Icon(
                          Icons.visibility_off_outlined,
                          color: AppColors.textFieldLabelColor,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => NavigationService.navigateTo(
                              ForgotPasswordScreen.id),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 0.0),
                          ),
                          child: const Text(
                            'Forgot password',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        label: 'Done',
                        color: AppColors.primaryColor,
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            // ref.read(authNotifierProvider.notifier).login(
                            //     context: context,
                            //     email: _emailController.text.trim(),
                            //     password: _passwordController.text);
                          } else {
                            return;
                          }
                        },
                        size: size,
                        textColor: AppColors.white,
                        borderSide: BorderSide.none,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                              child: Divider(
                                  color: AppColors.black,
                                  thickness: 0.5,
                                  height: 0.5,
                                  endIndent: 18.0)),
                          Text('OR',
                              style: TextStyle(
                                  color: AppColors.textColor, fontSize: 9.5)),
                          Expanded(
                              child: Divider(
                                  color: AppColors.black,
                                  thickness: 0.5,
                                  height: 0.5,
                                  indent: 18.0)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                          label: 'Continue with Google',
                          prefix: 'assets/svgs/google.svg',
                          color: AppColors.white,
                          onPressed: () {
                            NavigationService.navigateTo(HomeScreen.id);
                          },
                          size: size,
                          textColor: AppColors.primaryColor,
                          borderSide: const BorderSide(
                              width: 1, color: AppColors.primaryColor)),
                      const Expanded(child: SizedBox()),
                      GestureDetector(
                        onTap: () =>
                            NavigationService.navigateTo(SignUpScreen.id),
                        child: RichText(
                          textScaleFactor: 0.8,
                          text: const TextSpan(
                            text: "Don't have an acccount? ",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign up',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}
