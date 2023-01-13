import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reach_me/features/home/data/models/post_model.dart' as pt;
import 'package:reach_me/features/timeline/timeline_feed.dart';

import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/app_globals.dart';
import '../../core/utils/custom_text.dart';
import '../../core/utils/dimensions.dart';
import '../home/presentation/views/comment_reach.dart';
import '../moment/moment_feed.dart';
import 'models/post_feed.dart';

class TimeLineBoxActionRow extends StatelessWidget {
  const TimeLineBoxActionRow({
    Key? key,
    required this.post,
    required this.timeLineId,
  }) : super(key: key);

  final Post post;
  final String timeLineId;

  @override
  Widget build(BuildContext routeContext) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        height: 40,
        width: getScreenWidth(160),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: const Color(0xfff5f5f5),
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            CupertinoButton(
              minSize: 0,
              onPressed: () {
                timeLineFeedStore.likePost(timeLineId);
              },
              padding: EdgeInsets.zero,
              child: SvgPicture.asset(
                post.isLiked!
                    ? 'assets/svgs/like-active.svg'
                    : 'assets/svgs/like.svg',
              ),
            ),
            const SizedBox(width: 3),
            CustomText(
              text: momentFeedStore.getCountValue(
                value: post.nLikes!,
              ),
              size: 15,
              isCenter: true,
              weight: FontWeight.w600,
              color: const Color(0xff001824),
            )
          ]),
          InkWell(
            onTap: () {
              RouteNavigators.route(
                  routeContext,
                  CommentReach(
                      postFeedModel:
                          timeLineFeedStore.getPostModelById(timeLineId)));
            },
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SvgPicture.asset(
                'assets/svgs/comment.svg',
              ),
              const SizedBox(width: 3),
              CustomText(
                text: momentFeedStore.getCountValue(
                  value: post.nComments!,
                ),
                size: 15,
                isCenter: true,
                weight: FontWeight.w600,
                color: const Color(0xff001824),
              )
            ]),
          ),
          CupertinoButton(
            minSize: 0,
            onPressed: () {
              pt.PostFeedModel _postModel =
                  timeLineFeedStore.getPostModelById(timeLineId);
              if (_postModel.postOwnerId != globals.userId) {
                HapticFeedback.mediumImpact();

                timeLineFeedStore.messageUer(routeContext,
                    email: _postModel.postOwnerId!);
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
              CupertinoButton(
                minSize: 0,
                onPressed: () {
                  timeLineFeedStore.votePost(
                    routeContext,
                    id: timeLineId,
                    voteType: 'Upvote',
                  );
                },
                padding: EdgeInsets.zero,
                child: SizedBox(
                  width: 30,
                  child: SvgPicture.asset(
                    post.isVoted != 'false' &&
                            post.isVoted!.toLowerCase() == 'upvote'
                        ? 'assets/svgs/shoutup-active.svg'
                        : 'assets/svgs/shoutup.svg',
                  ),
                ),
              ),
              const SizedBox(width: 3),
              CustomText(
                text: momentFeedStore.getCountValue(
                  value: post.nUpvotes!,
                ),
                size: 15,
                isCenter: true,
                weight: FontWeight.w600,
                color: const Color(0xff001824),
              )
            ]),
            const SizedBox(width: 12),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              CupertinoButton(
                minSize: 0,
                onPressed: () {
                  timeLineFeedStore.votePost(
                    routeContext,
                    id: timeLineId,
                    voteType: 'Downvote',
                  );
                },
                padding: EdgeInsets.zero,
                child: SizedBox(
                  width: 30,
                  child: SvgPicture.asset(
                    post.isVoted != 'false' &&
                            post.isVoted!.toLowerCase() == 'downvote'
                        ? 'assets/svgs/shoutdown-active.svg'
                        : 'assets/svgs/shoutdown.svg',
                  ),
                ),
              ),
              const SizedBox(width: 3),
              CustomText(
                text: momentFeedStore.getCountValue(
                  value: post.nDownvotes!,
                ),
                size: 15,
                isCenter: true,
                weight: FontWeight.w600,
                color: const Color(0xff001824),
              )
            ]),
          ])),
    ]);
  }
}
