import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/utils/custom_text.dart';

class MomentActions extends StatelessWidget {
  final String label;
  final Function()? onClick;
  final String svgUrl;
  const MomentActions({
    Key? key,
    required this.label,
    this.onClick,
    required this.svgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SvgPicture.asset(svgUrl),
        const SizedBox(height: 2),
        CustomText(
          text: label,
          color: Colors.white,
          size: 10,
          weight: FontWeight.w600,
        )
      ]),
    );
  }
}
