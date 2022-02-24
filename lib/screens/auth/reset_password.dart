import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/components/custom_button.dart';
import 'package:reach_me/components/custom_textfield.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:reach_me/utils/extensions.dart';
import 'package:reach_me/utils/validator.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const String id = 'reset_password';
  const ResetPasswordScreen({Key? key}) : super(key: key);

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
                  'assets/svgs/illustration 8-new.svg',
                  height: 186,
                  width: 290,
                ),
              ),
              const SizedBox(height: 60.0),
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                hintText: 'Enter new password',
                obscureText: true,
                keyboardType: TextInputType.text,
                //controller: _passwordController,
                textCapitalization: TextCapitalization.none,
                validator: (value) => Validator.validatePassword(value ?? ""),
                suffixIcon: const Icon(
                  Icons.visibility_off_outlined,
                  color: AppColors.textFieldLabelColor,
                ),
              ).paddingSymmetric(h: 45.0),
              const SizedBox(height: 30),
              CustomTextField(
                hintText: 'Confirm new password',
                obscureText: true,
                keyboardType: TextInputType.text,
                //controller: _passwordController,
                textCapitalization: TextCapitalization.none,
                validator: (value) => Validator.validatePassword(value ?? ""),
              ).paddingSymmetric(h: 45.0),
              const SizedBox(height: 40),
              CustomButton(
                label: 'Reset',
                color: AppColors.primaryColor,
                onPressed: () {},
                size: size,
                textColor: AppColors.white,
                borderSide: BorderSide.none,
              ).paddingSymmetric(h: 45.0),
            ],
          )),
    ));
  }
}
