import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reach_me/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool autocorrect;
  final bool isDense;

  const CustomTextField(
      {Key? key,
      this.keyboardType,
      this.hintText,
      this.obscureText = false,
      this.validator,
      this.maxLength = 30,
      this.controller,
      this.prefixIcon,
      this.autocorrect = false,
      this.suffixIcon,
      this.isDense = false,
      required this.textCapitalization})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      autocorrect: autocorrect,
      textCapitalization: textCapitalization,
      validator: validator,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
      ],
      decoration: InputDecoration(
        isDense: isDense,
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF666666), fontSize: 13),
        filled: false,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.black, width: 0.5)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.black, width: 0.5)),
      ),
    );
  }
}

class CustomRoundTextField extends StatelessWidget {
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomRoundTextField(
      {Key? key,
      this.keyboardType,
      this.hintText,
      this.obscureText = false,
      this.validator,
      this.controller,
      this.prefixIcon,
      this.suffixIcon,
      required this.textCapitalization})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: 1,
      maxLines: 5,
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      autocorrect: false,
      textCapitalization: textCapitalization,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF666666), fontSize: 15),
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        fillColor: AppColors.greyShade8,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(54)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(54)),
      ),
    );
  }
}
