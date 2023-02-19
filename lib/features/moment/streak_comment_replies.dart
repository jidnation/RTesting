import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:reach_me/features/moment/momentControlRoom/models/comment_reply.dart';
import 'package:reach_me/features/moment/streak_comment_replies_box.dart';
import 'package:reach_me/features/moment/user_posting.dart';

import '../../core/utils/dimensions.dart';

class StreakCommentReplies extends StatelessWidget {
  final String commentId;
  final String streakId;
  final String id;

  const StreakCommentReplies({
    super.key,
    required this.commentId,
    required this.id,
    required this.streakId,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<GetMomentCommentReply> replies =
          momentCtrl.repliesBox[commentId] ?? [];
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
        child: ProgressHUD(
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
            Expanded(
              child: ListView.builder(
                  itemCount: replies.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                      top: 40, bottom: 5, right: 5, left: 5),
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    GetMomentCommentReply replyInfo = replies[index];
                    return StreakCommentRepliesBox(
                      momentId: streakId,
                      id: id,
                      commentId: commentId,
                      replyInfo: replyInfo,
                    );
                  }),
            )
          ]),
        ),
      );
    });
  }
}
