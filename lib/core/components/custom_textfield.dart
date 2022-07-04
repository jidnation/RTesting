import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';

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
  final bool readOnly;

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
      this.readOnly = false,
      required this.textCapitalization})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      autocorrect: autocorrect,
      textCapitalization: textCapitalization,
      validator: validator,
      style: TextStyle(
        fontSize: getScreenHeight(15),
      ),
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
  final BorderSide enabledBorderSide;
  final BorderSide focusedBorderSide;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isFilled;
  final double borderRadius;
  final TextStyle hintStyle;
  final TextStyle textStyle;
  final int? maxLines;
  final int? minLines;
  final Color? fillColor;
  final bool? isDense;
  final Function(String)? onChanged;

  const CustomRoundTextField(
      {Key? key,
      this.keyboardType,
      this.hintText,
      this.obscureText = false,
      this.validator,
      this.controller,
      this.prefixIcon,
      this.enabledBorderSide = BorderSide.none,
      this.focusedBorderSide = BorderSide.none,
      this.suffixIcon,
      this.isFilled = true,
      this.borderRadius = 54,
      this.minLines = 1,
      this.maxLines = 5,
      this.isDense = false,
      this.onChanged,
      this.fillColor = const Color(0xFFF5F5F5),
      this.hintStyle = const TextStyle(color: Color(0xFF666666), fontSize: 13),
      this.textStyle =
          const TextStyle(color: AppColors.textColor2, fontSize: 15),
      this.textCapitalization = TextCapitalization.none})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: minLines,
      maxLines: maxLines,
      style: textStyle,
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      autocorrect: false,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        filled: isFilled,
        isDense: isDense,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 19,
        ),
        fillColor: fillColor,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
            borderSide: enabledBorderSide,
            borderRadius: BorderRadius.circular(borderRadius)),
        focusedBorder: OutlineInputBorder(
            borderSide: focusedBorderSide,
            borderRadius: BorderRadius.circular(borderRadius)),
        errorBorder: OutlineInputBorder(
            borderSide: focusedBorderSide,
            borderRadius: BorderRadius.circular(borderRadius)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: focusedBorderSide,
            borderRadius: BorderRadius.circular(borderRadius)),
      ),
    );
  }
}
