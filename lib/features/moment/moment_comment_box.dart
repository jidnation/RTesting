import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/moment/streak_comment_replies.dart';
import 'package:reach_me/features/moment/user_posting.dart';

import '../../../../core/components/snackbar.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/dialog_box.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/helpers.dart';
import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/app_globals.dart';
import '../account/presentation/views/account.dart';
import '../home/presentation/bloc/user-bloc/user_bloc.dart';
import '../profile/new_account.dart';
import 'momentControlRoom/control_room.dart';
import 'momentControlRoom/models/get_comments_model.dart';
import 'moment_audio_player.dart';
import 'moment_feed.dart';

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
        vertical: 2.5,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            height: 30,
            width: 30,
            padding: EdgeInsets.all(cInfo.profilePicture!.isNotEmpty ? 0 : 5),
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(30),
                image: cInfo.profilePicture!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(cInfo.profilePicture!),
                        fit: BoxFit.cover,
                      )
                    : null),
            child: momentFeed.momentOwnerInfo.profilePicture?.isEmpty ?? false
                ? Image.asset("assets/images/app-logo.png")
                : null,
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              final progress = ProgressHUD.of(context);
              progress?.showWithText('Viewing Reacher...');
              Future.delayed(const Duration(seconds: 3), () {
                globals.userBloc!.add(GetRecipientProfileEvent(
                    email: commentInfo
                        .getMomentComment.commentOwnerProfile?.authId));
                commentInfo.getMomentComment.commentOwnerProfile?.authId ==
                        globals.user!.id
                    ? RouteNavigators.route(context, const NewAccountScreen())
                    : RouteNavigators.route(
                        context,
                        RecipientAccountProfile(
                          recipientEmail: 'email',
                          recipientImageUrl:
                              momentFeed.momentOwnerInfo.profilePicture,
                          recipientId: momentFeed.momentOwnerInfo.authId,
                        ));
                progress?.dismiss();
              });
            },
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CustomText(
                text:
                    '${cInfo.firstName.toString().toCapitalized()} ${cInfo.lastName.toString().toCapitalized()}',
                color: Colors.black,
                size: 14.28,
                weight: FontWeight.w600,
              ),
              const SizedBox(height: 1.5),
              Row(children: [
                Visibility(
                  visible: cInfo.location!.isNotEmpty,
                  child: Row(children: [
                    CustomText(
                      text: cInfo.location.toString().toCapitalized(),
                      color: const Color(0xff252525).withOpacity(0.5),
                      size: 10.44,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(width: 5),
                  ]),
                ),
                CustomText(
                  text: Helper.parseUserLastSeen(
                      commentInfo.getMomentComment.createdAt!),
                  color: const Color(0xff252525).withOpacity(0.5),
                  size: 11.44,
                  weight: FontWeight.w600,
                ),
              ]),
            ]),
          )
        ]),
        Visibility(
            visible: commentInfo.getMomentComment.audioMediaItem!.isNotEmpty ||
                commentInfo.getMomentComment.content!.isNotEmpty,
            child: const SizedBox(height: 10)),
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
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xfff5f5f5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
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
              const SizedBox(width: 12),
              InkWell(
                onTap: () {
                  replyMomentComment(context, userCommentTextCtrl);
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
                          value: commentInfo.getMomentComment.nReplies!,
                        ),
                        size: 15,
                        isCenter: true,
                        weight: FontWeight.w600,
                        color: const Color(0xff001824),
                      )
                    ]),
              ),
              // SvgPicture.asset(
              //   'assets/svgs/message.svg',
              //   color: Colors.black,
              //   width: 24.44,
              //   height: 22,
              // ),
            ]),
          ),
          Visibility(
            visible: commentInfo.getMomentComment.nReplies! > 0,
            child: GestureDetector(
              onTap: () {
                momentCtrl.fetchReplies(
                  commentId: commentInfo.getMomentComment.commentId!,
                  streakId: momentFeed.momentId,
                );
                Get.bottomSheet(
                    StreakCommentReplies(
                      id: momentFeed.id,
                      commentInfo: commentInfo,
                      momentFeed: momentFeed,
                    ),
                    isScrollControlled: true);
              },
              child: Container(
                padding: const EdgeInsets.only(
                  right: 3,
                  left: 3,
                  top: 20,
                  bottom: 3,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 0.5, color: Colors.blue.withOpacity(0.5)))),
                child: const CustomText(
                  text: 'view replies',
                  color: Colors.blue,
                  weight: FontWeight.w300,
                  size: 14,
                ),
              ),
            ),
          )
          // Row(children: [
          //   // Container(
          //   //   height: 41,
          //   //   width: 25.7,
          //   //   decoration: BoxDecoration(
          //   //     borderRadius: BorderRadius.circular(10),
          //   //     color: const Color(0xfff5f5f5),
          //   //   ),
          //   //   child: SvgPicture.asset('assets/svgs/upvote.svg'),
          //   // ),
          //   // const SizedBox(width: 12),
          //   // Container(
          //   //   height: 41,
          //   //   width: 25.7,
          //   //   decoration: BoxDecoration(
          //   //     borderRadius: BorderRadius.circular(10),
          //   //     color: const Color(0xfff5f5f5),
          //   //   ),
          //   //   child: SvgPicture.asset('assets/svgs/downvote.svg'),
          //   // ),
          // ])
        ])
      ]),
    );
  }

  void replyMomentComment(
      BuildContext context, TextEditingController userCommentTextCtrl) {
    CustomDialog.openDialogBox(
        height: 200,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                  if (userCommentTextCtrl.text.isNotEmpty) {
                    FocusScope.of(context).unfocus();
                    bool isDone = await momentFeedStore.replyCommentOnMoment(
                        context,
                        id: momentFeed.id,
                        commentId: commentInfo.getMomentComment.commentId!,
                        userInput: userCommentTextCtrl.text);
                    if (isDone) {
                      momentCtrl.fetchReplies(
                        commentId: commentInfo.getMomentComment.commentId!,
                        streakId: momentFeed.momentId,
                        isUpdate: true,
                      );
                      userCommentTextCtrl.clear();
                    }

                    Get.back();
                  } else {
                    Snackbars.error(
                      context,
                      message: 'Input Field can not be empty',
                      milliseconds: 1400,
                    );
                    // FocusScope.of(context).f(replyCommentFocus);
                  }
                },
                child: SvgPicture.asset('assets/svgs/send.svg'))
          ]),
        ]));
  }
}
