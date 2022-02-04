import 'package:reach_me/components/custom_button.dart';
import 'package:reach_me/components/custom_textfield.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/providers/auth.dart';
import 'package:reach_me/screens/auth/forgot_password.dart';
import 'package:reach_me/screens/auth/signup_screen.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:reach_me/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  static const String id = 'login_screen';
  LoginScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      width: size.width,
      height: size.height,
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 50.0, bottom: 25.0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => NavigationService.goBack(),
                child: const Icon(Icons.close),
              ),
              const Expanded(child: SizedBox(height: 70)),
              const Text(
                'Sign into your Account',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Log into your Egowave account.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Email address',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'abc@example.com',
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                validator: (value) => Validator.validateEmail(value ?? ""),
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: '********',
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                controller: _passwordController,
                textCapitalization: TextCapitalization.none,
                validator: (value) => Validator.validatePassword(value ?? ""),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
                child: Text(
                  'Have you forgotten your password?',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () =>
                    NavigationService.navigateTo(ForgotPasswordScreen.id),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 0.0),
                ),
                child: const Text(
                  'Click here to recover it.',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              CustomButton(
                label: 'LOG IN',
                color: AppColors.primaryColor,
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    ref.read(authNotifierProvider.notifier).login(
                        context: context,
                        email: _emailController.text.trim(),
                        password: _passwordController.text);
                  }else {
                    return;
                  }
                },
                size: size,
                textColor: AppColors.white,
                borderSide: BorderSide.none,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => NavigationService.navigateTo(SignUpScreen.id),
                child: RichText(
                  textScaleFactor: 0.8,
                  text: const TextSpan(
                    text: "Don't have an Egowave acccount? ",
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign up here',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
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
    ));
  }
}
