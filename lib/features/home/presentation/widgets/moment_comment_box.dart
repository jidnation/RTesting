import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/momentControlRoom/models/get_comments_model.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/dialog_box.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../momentControlRoom/control_room.dart';
import '../views/moment_feed.dart';
import 'moment_audio_player.dart';

class MomentCommentBox extends HookWidget {
  final MomentModel momentFeed;
  final CustomMomentCommentModel commentInfo;
  const MomentCommentBox({
    Key? key,
    required this.momentFeed,
    required this.commentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController userCommentTextCtrl = useTextEditingController();
    CommentOwnerProfile cInfo =
        commentInfo.getMomentComment.commentOwnerProfile!;
    return Container(
      width: SizeConfig.screenWidth,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            height: 50,
            width: 50,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(30),
                image: cInfo.profilePicture!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(cInfo.profilePicture!),
                        fit: BoxFit.cover,
                      )
                    : null),
            child: momentFeed.profilePicture.isEmpty
                ? Image.asset("assets/images/app-logo.png")
                : null,
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomText(
              text:
                  '${cInfo.firstName.toString().toCapitalized()} ${cInfo.lastName.toString().toCapitalized()}',
              color: Colors.black,
              size: 16.28,
              weight: FontWeight.w600,
            ),
            const SizedBox(height: 1.5),
            CustomText(
              text: cInfo.location.toString().toCapitalized(),
              color: const Color(0xff252525).withOpacity(0.5),
              size: 11.44,
              weight: FontWeight.w600,
            ),
          ])
        ]),
        const SizedBox(height: 10),
        Visibility(
          visible: commentInfo.getMomentComment.audioMediaItem!.isNotEmpty,
          child: Container(
            height: 59,
            margin: const EdgeInsets.only(bottom: 10),
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xfff5f5f5)),
            child: Row(children: [
              Expanded(
                  child: MomentAudioPlayer(
                audioPath: commentInfo.getMomentComment.audioMediaItem!,
                // audioPath:
                //     'https://res.cloudinary.com/dwj7naozp/video/upload/v1671552267/2-03_Thursday_zrklln.mp3',
              )),
            ]),
          ),
        ),
        Visibility(
          visible: commentInfo.getMomentComment.content!.isNotEmpty,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: SizeConfig.screenWidth,
            child: CustomText(
              text: commentInfo.getMomentComment.content.toString(),
              size: 14,
            ),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            height: 47,
            width: getScreenWidth(160),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: const Color(0xfff5f5f5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    InkWell(
                      onTap: () {
                        momentFeedStore.likingMomentComment(
                          commentId: commentInfo.id,
                          id: momentFeed.id,
                        );
                      },
                      child: SvgPicture.asset(
                        commentInfo.getMomentComment.isLiked != "false"
                            ? 'assets/svgs/like-active.svg'
                            : 'assets/svgs/like.svg',
                      ),
                    ),
                    const SizedBox(width: 3),
                    CustomText(
                      text: momentFeedStore.getCountValue(
                        value: commentInfo.getMomentComment.nLikes!,
                      ),
                      size: 15,
                      isCenter: true,
                      weight: FontWeight.w600,
                      color: const Color(0xff001824),
                    )
                  ]),
                  InkWell(
                    onTap: () {
                      CustomDialog.openDialogBox(
                          height: 200,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CustomText(
                                  text: 'Enter your comments',
                                  size: 15,
                                  weight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 30),
                                Row(children: [
                                  Expanded(
                                    child: Container(
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xfff5f5f5),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextFormField(
                                        controller: userCommentTextCtrl,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                      onTap: () async {
                                        // FocusScope.of(context).unfocus();
                                        // bool isDone = await momentFeedStore.commentOnMoment(context,
                                        //     id: momentFeed.id,
                                        //     userComment: inputController.text.isNotEmpty
                                        //         ? inputController.text
                                        //         : null);
                                        // isDone ? inputController.clear() : null;
                                      },
                                      child: SvgPicture.asset(
                                          'assets/svgs/send.svg'))
                                ])
                              ]));
                    },
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/comment.svg',
                          ),
                          const SizedBox(width: 3),
                          CustomText(
                            text: momentFeedStore.getCountValue(
                              value: commentInfo.getMomentComment.nComments!,
                            ),
                            size: 15,
                            isCenter: true,
                            weight: FontWeight.w600,
                            color: const Color(0xff001824),
                          )
                        ]),
                  ),
                  SvgPicture.asset(
                    'assets/svgs/message.svg',
                    color: Colors.black,
                    width: 24.44,
                    height: 22,
                  ),
                ]),
          ),
          Row(children: [
            Container(
              height: 41,
              width: 25.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xfff5f5f5),
              ),
              child: SvgPicture.asset('assets/svgs/upvote.svg'),
            ),
            const SizedBox(width: 12),
            Container(
              height: 41,
              width: 25.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xfff5f5f5),
              ),
              child: SvgPicture.asset('assets/svgs/downvote.svg'),
            ),
          ])
        ])
      ]),
    );
  }
}
