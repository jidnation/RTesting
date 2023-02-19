import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/dimensions.dart';

class StreakCommentReplies extends StatelessWidget {
  final String commentId;
  final String streakId;
  const StreakCommentReplies({
    super.key,
    required this.commentId,
    required this.streakId,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: SizeConfig.screenHeight * 0.65,
        width: SizeConfig.screenWidth,
        padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            )),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: 4,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.withOpacity(0.5),
              ),
            )
          ]),
          // StreakCommentRepliesBox()
        ]),
      );
    });
  }
}
