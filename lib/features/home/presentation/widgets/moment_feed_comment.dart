import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/utils/custom_text.dart';
import '../../../momentControlRoom/control_room.dart';
import '../views/moment_feed.dart';
import 'moment_comment_house.dart';

class MomentFeedComment extends StatefulWidget {
  final MomentModel momentFeed;
  const MomentFeedComment({
    Key? key,
    required this.momentFeed,
  }) : super(key: key);

  @override
  State<MomentFeedComment> createState() => _MomentFeedCommentState();
}

class _MomentFeedCommentState extends State<MomentFeedComment> {
  @override
  // void initState() {
  //   super.initState();
  //   momentFeedStore.getMomentComments(momentId: widget.momentFeed.momentId);
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        momentFeedStore.videoCtrl(false);
        Get.to(
          () => MomentCommentStation2(momentFeedId: widget.momentFeed.id),
          transition: Transition.downToUp,
        );
        // Get.bottomSheet(
        //   StatefulBuilder(
        //       builder: (BuildContext context, StateSetter setCommentState) {
        //     momentFeedStore.gettingUserComment ? setCommentState(() {}) : null;
        //     return MomentCommentStation(momentFeed: widget.momentFeed);
        //   }),
        //   isScrollControlled: true,
        // );
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SvgPicture.asset(
          'assets/svgs/comment.svg',
          color: Colors.white,
        ),
        const SizedBox(height: 5),
        CustomText(
          text:
              momentFeedStore.getCountValue(value: widget.momentFeed.nComment),
          weight: FontWeight.w500,
          color: Colors.white,
          size: 13.28,
        )
      ]),
    );
  }
}
