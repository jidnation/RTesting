import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final Color textColor;
  final BorderSide borderSide;
  final Size? size;
  final String prefix;
  final EdgeInsetsGeometry? padding;
  final double labelFontSize;
  final bool? isLoading;
  final Color? loaderColor;
  const CustomButton({
    Key? key,
    required this.label,
    required this.color,
    required this.onPressed,
    this.size,
    this.isLoading = false,
    this.loaderColor = AppColors.black,
    required this.textColor,
    required this.borderSide,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    this.prefix = '',
    this.labelFontSize = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: getScreenHeight(46),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: color,
            side: borderSide,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadowColor: const Color(0xFF323247)),
        child: isLoading!
            ? Platform.isAndroid
                ? SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      color: loaderColor,
                      strokeWidth: 2,
                    ),
                  )
                : CupertinoActivityIndicator(color: loaderColor, radius: 5)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prefix == ''
                      ? const SizedBox.shrink()
                      : SizedBox(height: 18, child: SvgPicture.asset(prefix)),
                  prefix == ''
                      ? const SizedBox.shrink()
                      : const SizedBox(width: 15),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: labelFontSize,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
