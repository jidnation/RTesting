import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/features/home/data/models/post_model.dart' as pt;
import 'package:reach_me/features/timeline/timeline_control_room.dart';
import 'package:reach_me/features/timeline/timeline_feed.dart';

import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/app_globals.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/custom_text.dart';
import '../home/presentation/views/comment_reach.dart';
import '../moment/moment_feed.dart';
import 'models/post_feed.dart';

class TimeLineBoxActionRow extends StatefulWidget {
  const TimeLineBoxActionRow({
    Key? key,
    required this.type,
    required this.post,
    this.userId,
    required this.timeLineId,
  }) : super(key: key);

  final Post post;
  final String timeLineId;
  final String type;
  final String? userId;

  @override
  State<TimeLineBoxActionRow> createState() => _TimeLineBoxActionRowState();
}

class _TimeLineBoxActionRowState extends State<TimeLineBoxActionRow> {
  LikeModel likeModelInfo = LikeModel(nLikes: 0, isLiked: false);
  bool isReaching = false;
  @override
  void initState() {
    super.initState();
  }

  usersReaching() async {
    bool isReachingUser = await timeLineFeedStore.usersReaching();
    // setState(() {
    isReaching = isReachingUser;
    // });
  }

  @override
  Widget build(BuildContext routeContext) {
    return Obx(() {
      LikeModel likeModelInfo = timeLineController.getLikeValues(
          id: widget.timeLineId, type: widget.type);

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
                child: LikeButton(
                  size: 23,
                  countBuilder: (count, isLiked, text) {
                    return CustomText(
                      text: count.toString(),
                      weight: FontWeight.w600,
                      color: Colors.black,
                      size: 15,
                    ).paddingOnly(left: 3);
                  },
                  likeCountPadding: const EdgeInsets.all(0),
                  isLiked: widget.post.isLiked,
                  countPostion: CountPostion.right,
                  onTap: (isLiked) async {
                    timeLineController.likePost(
                      id: widget.timeLineId,
                      type: widget.type,
                    );
                    timeLineFeedStore.likeTimeLinePost(
                      widget.timeLineId,
                      type: widget.type,
                    );
                    return !isLiked;
                  },
                  circleColor: CircleColor(
                      start: AppColors.primaryColor,
                      end: AppColors.primaryColor.withOpacity(0.5)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: AppColors.primaryColor,
                    dotSecondaryColor: AppColors.primaryColor.withOpacity(0.6),
                  ),
                  likeBuilder: (bool isLiked) {
                    return SvgPicture.asset(
                      isLiked
                          ? 'assets/svgs/like-active.svg'
                          : 'assets/svgs/like.svg',
                    );
                  },
                  likeCount: widget.post.nLikes!,
                ),
              ),
            ]),
            const SizedBox(width: 12),
            commentIcon(context),
            !(widget.type == 'profile')
                ? Visibility(
                    visible:
                        widget.post.postOwnerProfile?.authId != globals.userId,
                    child: Row(children: [
                      const SizedBox(width: 12),
                      CupertinoButton(
                        minSize: 0,
                        onPressed: () {
                          pt.PostFeedModel _postModel = timeLineFeedStore
                              .getPostModelById(widget.timeLineId,
                                  type: widget.type)!;
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
                    ]),
                  )
                : const SizedBox.shrink(),
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
                  onTap: (widget.type.toLowerCase() != 'downvote')
                      ? () {
                          timeLineFeedStore.votePost(routeContext,
                              id: widget.timeLineId,
                              voteType: 'Upvote',
                              type: widget.type);
                        }
                      : null,
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
              Visibility(
                visible: !(widget.post.authId == globals.user!.id!),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          if ((widget.post.nDownvotes ?? 0) > 0 &&
                              (widget.post.authId == globals.user!.id!)) {
                            showPostReactors(routeContext,
                                postId: widget.post.postId!,
                                reactionType: 'Downvote');
                          }
                        },
                        onTap: (widget.type.toLowerCase() != 'downvote')
                            ? () {
                                timeLineFeedStore.votePost(routeContext,
                                    id: widget.timeLineId,
                                    voteType: 'Downvote',
                                    type: widget.type);
                              }
                            : null,
                        child: SizedBox(
                          width: 30,
                          child: SvgPicture.asset(
                            widget.post.isVoted != 'false' &&
                                    widget.post.isVoted!.toLowerCase() ==
                                        'downvote'
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
              ),
            ])),
      ]);
    });
  }

  Widget commentIcon(BuildContext routeContext) {
    usersReaching();
    switch (widget.post.commentOption) {
      case "everyone":
        return InkWell(
          onTap: () {
            RouteNavigators.route(
                routeContext,
                CommentReach(
                    postFeedModel: timeLineFeedStore.getPostModelById(
                        widget.timeLineId,
                        type: widget.type)));
          },
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
        );

      case "people_you_follow":
        if (widget.post.postOwnerProfile!.authId == globals.userId ||
            isReaching) {
          return InkWell(
            onTap: () {
              RouteNavigators.route(
                  routeContext,
                  CommentReach(
                      postFeedModel: timeLineFeedStore.getPostModelById(
                          widget.timeLineId,
                          type: widget.type)));
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
          );
        } else {
          return const SizedBox.shrink();
        }
      case "only_people_you_mention":
        if (widget.post.mentionList!.contains(globals.user!.username) ||
            (widget.post.postOwnerProfile!.authId == globals.userId)) {
          return InkWell(
            onTap: () {
              RouteNavigators.route(
                  routeContext,
                  CommentReach(
                      postFeedModel: timeLineFeedStore.getPostModelById(
                          widget.timeLineId,
                          type: widget.type)));
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
          );
        } else {
          return const SizedBox.shrink();
        }
      default:
        return InkWell(
          onTap: () {
            RouteNavigators.route(
                routeContext,
                CommentReach(
                    postFeedModel: timeLineFeedStore.getPostModelById(
                        widget.timeLineId,
                        type: widget.type)));
          },
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
        );
    }
  }
}
