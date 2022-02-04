import 'package:reach_me/components/custom_button.dart';
import 'package:reach_me/components/custom_textfield.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/providers/auth.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:reach_me/utils/validator.dart';
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
      body: Container(
        width: size.width,
        height: size.height,
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 50.0, bottom: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => NavigationService.goBack(),
                child: const Icon(Icons.close),
              ),
              const SizedBox(height: 70),
              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please enter your email address to recover your password.',
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
                controller: _emailController,
                validator: (value) => Validator.validateEmail(value ?? ""),
              ),
              const SizedBox(height: 16),
              const Expanded(child: SizedBox()),
              CustomButton(
                label: 'RECOVER PASSWORD',
                color: AppColors.primaryColor,
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).forgotPassword(
                      context,
                      email: _emailController.text.trim());
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
    );
  }
}
