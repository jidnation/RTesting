import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/utils/custom_text.dart';

class PosingType extends StatelessWidget {
  final String label;
  final bool isSelected;
  const PosingType({
    Key? key,
    required this.label,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CustomText(
        text: label,
        size: 13.3,
        weight: isSelected ? FontWeight.w600 : FontWeight.w400,
        color: isSelected ? AppColors.white : AppColors.greyShade5,
      ),
      const SizedBox(height: 5),
      SvgPicture.asset(
        'assets/svgs/custom-arrow.svg',
        color: !isSelected ? Colors.transparent : null,
      ),
    ]);
  }
}
