import 'package:flutter/material.dart';

import 'constants.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final bool? isCenter;
  final FontStyle? isItalic;
  final Color? color;
  final TextOverflow? overflow;
  final FontWeight? weight;
  const CustomText({
    Key? key,
    required this.text,
    this.size,
    this.color,
    this.weight,
    this.isCenter,
    this.isItalic,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: (isCenter == true) ? TextAlign.center : TextAlign.left,
      overflow: overflow ?? TextOverflow.clip,
      style: TextStyle(
        fontFamily: 'QSand',
        fontStyle: isItalic ?? FontStyle.normal,
        fontWeight: weight ?? FontWeight.normal,
        color: color ?? AppColors.black,
        fontSize: size ?? 16,
      ),
    );
  }
}
