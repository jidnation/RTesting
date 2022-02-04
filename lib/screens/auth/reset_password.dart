import 'package:reach_me/components/custom_button.dart';
import 'package:reach_me/components/custom_textfield.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:reach_me/utils/validator.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const String id = 'reset_password';
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                "Reset Password",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Please enter your new password to continue',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'New password',
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
                keyboardType: TextInputType.visiblePassword,
                textCapitalization: TextCapitalization.none,
                validator: (value) => Validator.validatePassword(value ?? ""),
              ),
              const SizedBox(height: 16),
              const Text(
                'Repeat password',
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
                keyboardType: TextInputType.visiblePassword,
                textCapitalization: TextCapitalization.none,
                validator: (value) => Validator.validatePassword(value ?? ""),
              ),
              const SizedBox(height: 16),
              const Expanded(child: SizedBox()),
              CustomButton(
                label: 'CHANGE PASSWORD',
                color: AppColors.primaryColor,
                onPressed: () {
                  // NavigationService.navigateTo(VerifyAccountScreen.id);
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
