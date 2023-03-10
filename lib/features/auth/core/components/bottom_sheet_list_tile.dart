import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';

class KebabBottomTextButton extends StatelessWidget {
  const KebabBottomTextButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.color = AppColors.black,
    this.isLoading = false,
  }) : super(key: key);

  final String label;
  final bool isLoading;
  final Color color;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 15,
              color: color,
              fontWeight: FontWeight.w400,
            ),
          ),
          isLoading
              ? const CupertinoActivityIndicator(
                  color: AppColors.black, radius: 7)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
