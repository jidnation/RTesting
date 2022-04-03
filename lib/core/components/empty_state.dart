import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/utils/constants.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key? key,
    required this.emptyText,
  }) : super(key: key);
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/svgs/ic_empty.svg'),
          const SizedBox(height: 17),
          Text(
            emptyText,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textColor2),
          ),
        ],
      ),
    );
  }
}
