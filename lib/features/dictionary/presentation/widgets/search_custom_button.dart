import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.buttonText,
      required this.onPressed,
      this.isLoading = false})
      : super(key: key);
  final String buttonText;
  final VoidCallback onPressed;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 230),
        child: Container(
          margin: const EdgeInsets.only(bottom: 44),
          alignment: Alignment.center,
          height: 50,
          width: 210,
          decoration: BoxDecoration(
              color: const Color(0xff001824),
              borderRadius: BorderRadius.circular(30)),
          child: isLoading
              ? Platform.isAndroid
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const CupertinoActivityIndicator(
                      color: AppColors.white, radius: 5)
              : Text(
                  buttonText,
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}
