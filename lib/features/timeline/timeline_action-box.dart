import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reach_me/features/home/data/models/post_model.dart' as pt;
import 'package:reach_me/features/timeline/post_control_room.dart';
import 'package:reach_me/features/timeline/timeline_feed.dart';

import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/app_globals.dart';
import '../../core/utils/custom_text.dart';
import '../../core/utils/dimensions.dart';
import '../home/presentation/views/comment_reach.dart';
import '../home/presentation/views/moment_feed.dart';
import 'models/post_feed.dart';

class TimeLineBoxActionRow extends StatefulWidget {
  const TimeLineBoxActionRow({
    Key? key,
    required this.posts,
    required this.timeLineId,
  }) : super(key: key);

  final List<CustomPostModel> posts;
  final String timeLineId;

  @override
  State<TimeLineBoxActionRow> createState() => _TimeLineBoxActionRowState();
}

class _TimeLineBoxActionRowState extends State<TimeLineBoxActionRow> {
  late Post tPostInfo;

  @override
  void initState() {
    super.initState();
    for (CustomPostModel element in widget.posts) {
      if (element.id == widget.timeLineId) {
        tPostInfo = element.post;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    pt.PostFeedModel _postModel =
        timeLineFeedStore.getPostModelById(widget.timeLineId);

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
                postStore.likePost(widget.timeLineId);
              },
              padding: EdgeInsets.zero,
              child: SvgPicture.asset(
                tPostInfo.isLiked!
                    ? 'assets/svgs/like-active.svg'
                    : 'assets/svgs/like.svg',
              ),
            ),
            const SizedBox(width: 3),
            CustomText(
              text: momentFeedStore.getCountValue(
                value: tPostInfo.nLikes!,
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
                  context,
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
                  value: tPostInfo.nComments!,
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
              if (_postModel.postOwnerId != globals.userId) {
                HapticFeedback.mediumImpact();

                timeLineFeedStore.messageUer(context,
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
                  postStore.votePost(
                    context,
                    id: widget.timeLineId,
                    voteType: 'Upvote',
                  );
                },
                padding: EdgeInsets.zero,
                child: SizedBox(
                  width: 30,
                  child: SvgPicture.asset(
                    tPostInfo.isVoted != 'false' &&
                            tPostInfo.isVoted!.toLowerCase() == 'upvote'
                        ? 'assets/svgs/shoutup-active.svg'
                        : 'assets/svgs/shoutup.svg',
                  ),
                ),
              ),
              const SizedBox(width: 3),
              CustomText(
                text: momentFeedStore.getCountValue(
                  value: tPostInfo.nUpvotes!,
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
                  postStore.votePost(
                    context,
                    id: widget.timeLineId,
                    voteType: 'Downvote',
                  );
                },
                padding: EdgeInsets.zero,
                child: SizedBox(
                  width: 30,
                  child: SvgPicture.asset(
                    tPostInfo.isVoted != 'false' &&
                            tPostInfo.isVoted!.toLowerCase() == 'downvote'
                        ? 'assets/svgs/shoutdown-active.svg'
                        : 'assets/svgs/shoutdown.svg',
                  ),
                ),
              ),
              const SizedBox(width: 3),
              CustomText(
                text: momentFeedStore.getCountValue(
                  value: tPostInfo.nDownvotes!,
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
