import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';

class KebabBottomTextButton extends StatelessWidget {
  const KebabBottomTextButton({Key? key, required this.label, this.onPressed})
      : super(key: key);

  final String label;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 15),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(label,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.black,
                fontWeight: FontWeight.w400,
              )),
        ));
  }
}