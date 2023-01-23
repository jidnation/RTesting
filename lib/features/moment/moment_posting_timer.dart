import 'package:flutter/material.dart';

import '../../core/utils/custom_text.dart';

class MomentPostingTimer extends StatelessWidget {
  final String time;
  final bool isSelected;
  final Function()? onClick;
  const MomentPostingTimer({
    Key? key,
    required this.time,
    required this.isSelected,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 29,
        width: 29,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color:
              isSelected ? Colors.black.withOpacity(0.4) : Colors.transparent,
        ),
        child: CustomText(
          text: time,
          color: Colors.white,
          size: 12.44,
          weight: FontWeight.w600,
        ),
      ),
    );
  }
}
