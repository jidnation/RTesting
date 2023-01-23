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
import 'models/post_feed.dart';

class TimeLineBoxActionRow extends StatefulWidget {
  const TimeLineBoxActionRow({
    Key? key,
    required this.post,
    required this.timeLineId,
  }) : super(key: key);

  final Post post;
  final String timeLineId;

  @override
  State<TimeLineBoxActionRow> createState() => _TimeLineBoxActionRowState();
}

class _TimeLineBoxActionRowState extends State<TimeLineBoxActionRow> {
  LikeModel likeModelInfo = LikeModel(nLikes: 0, isLiked: false);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext routeContext) {
    return Obx(() {
      LikeModel likeModelInfo =
          timeLineController.getLikeValues(id: widget.timeLineId);

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
                  if ((widget.post.nLikes ?? 0) > 0) {
                    showPostReactors(routeContext,
                        postId: widget.post.postId!, reactionType: 'Like');
                  }
                },
                onTap: () {
                  timeLineController.likePost(id: widget.timeLineId);
                  timeLineFeedStore.likePost(widget.timeLineId);
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
                RouteNavigators.route(
                    routeContext,
                    CommentReach(
                        postFeedModel: timeLineFeedStore
                            .getPostModelById(widget.timeLineId)));
              },
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                SvgPicture.asset(
                  'assets/svgs/comment.svg',
                ),
                const SizedBox(width: 3),
                CustomText(
                  text: momentFeedStore.getCountValue(
                    value: widget.post.nComments!,
                  ),
                  size: 15,
                  isCenter: true,
                  weight: FontWeight.w600,
                  color: const Color(0xff001824),
                )
              ]),
            ),
            Visibility(
              visible: timeLineFeedStore
                      .getPostModelById(widget.timeLineId)
                      .postOwnerId !=
                  globals.userId,
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  CupertinoButton(
                    minSize: 0,
                    onPressed: () {
                      pt.PostFeedModel _postModel =
                          timeLineFeedStore.getPostModelById(widget.timeLineId);
                      if (_postModel.postOwnerId != globals.userId) {
                        HapticFeedback.mediumImpact();

                        timeLineFeedStore.messageUser(routeContext,
                            id: _postModel.postOwnerId!,
                            quoteData: jsonEncode(_postModel.toJson()));
                      }
                    },
                    padding: EdgeInsets.zero,
                    child: SvgPicture.asset(
                      'assets/svgs/message.svg',
                      color: Colors.black,
                      width: 24.44,
                      height: 22,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: const Color(0xfff5f5f5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                GestureDetector(
                  onLongPress: () {
                    if ((widget.post.nUpvotes ?? 0) > 0 &&
                        (widget.post.authId == globals.user!.id!)) {
                      showPostReactors(routeContext,
                          postId: widget.post.postId!, reactionType: 'Upvote');
                    }
                  },
                  onTap: () {
                    timeLineFeedStore.votePost(
                      routeContext,
                      id: widget.timeLineId,
                      voteType: 'Upvote',
                    );
                  },
                  child: SizedBox(
                    width: 30,
                    child: SvgPicture.asset(
                      widget.post.isVoted != 'false' &&
                              widget.post.isVoted!.toLowerCase() == 'upvote'
                          ? 'assets/svgs/shoutup-active.svg'
                          : 'assets/svgs/shoutup.svg',
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                CustomText(
                  text: momentFeedStore.getCountValue(
                    value: widget.post.nUpvotes!,
                  ),
                  size: 15,
                  isCenter: true,
                  weight: FontWeight.w600,
                  color: const Color(0xff001824),
                )
              ]),
              const SizedBox(width: 12),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                GestureDetector(
                  onLongPress: () {
                    if ((widget.post.nDownvotes ?? 0) > 0 &&
                        (widget.post.authId == globals.user!.id!)) {
                      showPostReactors(routeContext,
                          postId: widget.post.postId!,
                          reactionType: 'Downvote');
                    }
                  },
                  onTap: () {
                    timeLineFeedStore.votePost(
                      routeContext,
                      id: widget.timeLineId,
                      voteType: 'Downvote',
                    );
                  },
                  child: SizedBox(
                    width: 30,
                    child: SvgPicture.asset(
                      widget.post.isVoted != 'false' &&
                              widget.post.isVoted!.toLowerCase() == 'downvote'
                          ? 'assets/svgs/shoutdown-active.svg'
                          : 'assets/svgs/shoutdown.svg',
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                CustomText(
                  text: momentFeedStore.getCountValue(
                    value: widget.post.nDownvotes!,
                  ),
                  size: 15,
                  isCenter: true,
                  weight: FontWeight.w600,
                  color: const Color(0xff001824),
                )
              ]),
            ])),
      ]);
    });
  }
}
