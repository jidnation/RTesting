import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    Key? key,
    this.width = 100,
    this.height = 100,
    this.fontSize = 10,
    this.border,
  }) : super(key: key);

  final double height, width, fontSize;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          shape: BoxShape.circle,
          border: border),
      child: FittedBox(
          child: Image.asset(
        'assets/images/blank-dp.png',
        fit: BoxFit.cover,
        gaplessPlayback: true,
      )),
    );
  }
}
