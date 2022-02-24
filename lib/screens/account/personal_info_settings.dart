import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/components/custom_textfield.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:reach_me/utils/extensions.dart';
import 'package:reach_me/utils/validator.dart';

class PersonalInfoSettings extends StatelessWidget {
  static const String id = 'personal_info_settings';
  const PersonalInfoSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                        icon: SvgPicture.asset(
                          'assets/svgs/arrow-back.svg',
                          width: 19,
                          height: 12,
                          color: AppColors.black,
                        ),
                        onPressed: () => NavigationService.goBack()),
                    const SizedBox(width: 15),
                    const Text('Personal Information',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor2)),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "The information here won't be part of your public profile.",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyShade2,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textFieldLabelColor,
                      ),
                    ),
                    CustomTextField(
                      isDense: true,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) => Validator.validateEmail(value ?? ""),
                      // controller: _emailController,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textFieldLabelColor,
                      ),
                    ),
                    CustomTextField(
                      isDense: true,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) => Validator.validateName(value ?? ""),
                      // controller: _emailController,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textFieldLabelColor,
                      ),
                    ),
                    CustomTextField(
                      isDense: true,
                      keyboardType: TextInputType.name,
                      maxLength: 250,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) => Validator.validateName(value ?? ""),
                      // controller: _emailController,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Birthday',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textFieldLabelColor,
                      ),
                    ),
                    CustomTextField(
                      isDense: true,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) => Validator.validateName(value ?? ""),
                      // controller: _emailController,
                    ),
                  ],
                ).paddingSymmetric(h: 13),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
