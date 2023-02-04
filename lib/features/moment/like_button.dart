import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/custom_text.dart';

class SplashLikeButton extends StatelessWidget {
  final bool likeValue;
  final double? iconSize;
  final Widget iconValue;
  final Future<bool?> Function(bool)? onClick;
  final int valueCount;
  const SplashLikeButton({Key? key,
  required this.likeValue,
    required this.iconValue,
    required this.valueCount,
    this.onClick,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      size: iconSize ?? 30,
      countBuilder: (count,
          isLiked, text) {
        return CustomText(
          text: count
              .toString(),
          weight:
          FontWeight.w500,
          color: Colors.white,
          size: 13.28,
        );
      },
      likeCountPadding:
      const EdgeInsets
          .all(0),
      isLiked:
      likeValue,
      countPostion:
      CountPostion.bottom,
      onTap: onClick,
      circleColor: CircleColor(
          start: AppColors
              .primaryColor,
          end: AppColors
              .primaryColor
              .withOpacity(
              0.5)),
      bubblesColor:
      BubblesColor(
        dotPrimaryColor:
        Colors.red,
        dotSecondaryColor:
        Colors.red
            .withOpacity(
            0.6),
      ),
      likeBuilder:
          (bool isLiked) {
        return iconValue;

        //   Icon(
        //   Icons.home,
        //   color: isLiked
        //       ? Colors
        //           .deepPurpleAccent
        //       : Colors.grey,
        //   size: buttonSize,
        // );
      },
      likeCount:
      valueCount,
    );
  }
}

///
/// return icon
/// Icon(
//           size: iconSize ?? 30,
//           isLiked
//               ? Icons.favorite
//               : Icons
//               .favorite_outline_outlined,
//           color: isLiked
//               ? Colors.red
//               : Colors.white,
//         )


