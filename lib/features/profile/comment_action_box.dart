import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/features/home/data/models/post_model.dart' as pt;
import 'package:reach_me/features/timeline/timeline_control_room.dart';
import 'package:reach_me/features/timeline/timeline_feed.dart';

import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/app_globals.dart';
import '../../core/utils/custom_text.dart';
import '../home/presentation/views/comment_reach.dart';
import '../moment/moment_feed.dart';
import '../timeline/models/profile_comment_model.dart';

class CommentBoxActionRow extends StatefulWidget {
  final GetPersonalComment getPersonalComment;
  final String type;
  const CommentBoxActionRow({
    Key? key,
    required this.getPersonalComment,
    required this.type,
    // required this.timeLineId,
  }) : super(key: key);

  // final Post post;
  // final String timeLineId;
  // final String type;

  @override
  State<CommentBoxActionRow> createState() => _CommentBoxActionRowState();
}

class _CommentBoxActionRowState extends State<CommentBoxActionRow> {
  LikeModel likeModelInfo = LikeModel(nLikes: 0, isLiked: false);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext routeContext) {
    return Obx(() {
      LikeModel likeModelInfo = timeLineController.getLikeValues(
          id: widget.getPersonalComment.commentId!, type: widget.type);

      // bool isLiked = widget.getPersonalComment.isLiked != "false";
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          height: 40,
          // width: getScreenWidth(160),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xfff5f5f5),
            borderRadius: BorderRadius.circular(8),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              GestureDetector(
                onLongPress: () {
                  if ((widget.getPersonalComment.nLikes ?? 0) > 0) {
                    showPostReactors(routeContext,
                        postId: widget.getPersonalComment.postId!,
                        reactionType: 'Like');
                  }
                },
                onTap: () {
                  timeLineController.likePost(
                      id: widget.getPersonalComment.commentId!,
                      isLikes: widget.getPersonalComment.isLiked,
                      postId: widget.getPersonalComment.postId,
                      type: widget.type);
                },
                child: SvgPicture.asset(
                  // widget.post.isLiked!
                  likeModelInfo.isLiked
                      ? 'assets/svgs/like-active.svg'
                      : 'assets/svgs/like.svg',
                ),
              ),
              const SizedBox(width: 3),
              CustomText(
                text: momentFeedStore.getCountValue(
                  // value: widget.post.nLikes!,
                  value: likeModelInfo.nLikes,
                ),
                size: 15,
                isCenter: true,
                weight: FontWeight.w600,
                color: const Color(0xff001824),
              )
            ]),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                print(
                    ":::::::::::::::commentId ${widget.getPersonalComment.commentId}");
                print(
                    ":::::::::::::::postId ${widget.getPersonalComment.postId}");
                timeLineController.replyComment(
                  context,
                  postId: widget.getPersonalComment.postId,
                  commentId: widget.getPersonalComment.commentId,
                );
              },
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                SvgPicture.asset(
                  'assets/svgs/comment.svg',
                ),
                const SizedBox(width: 3),
                CustomText(
                  text: momentFeedStore.getCountValue(
                    value: widget.getPersonalComment.nReplies!,
                  ),
                  size: 15,
                  isCenter: true,
                  weight: FontWeight.w600,
                  color: const Color(0xff001824),
                )
              ]),
            ),
          ]),
        ),
        const SizedBox(),
      ]);
    });
  }
}
