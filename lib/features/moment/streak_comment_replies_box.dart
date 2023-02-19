import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/moment/streak_comment_replies.dart';
import 'package:reach_me/features/moment/user_posting.dart';
import 'package:reach_me/features/timeline/models/post_feed.dart';

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
import 'momentControlRoom/models/comment_reply.dart';
import 'momentControlRoom/models/get_comments_model.dart';
import 'moment_audio_player.dart';
import 'moment_feed.dart';

class StreakCommentRepliesBox extends HookWidget {
  final String momentId;
  final String id;
  final String commentId;
  final GetMomentCommentReply replyInfo;

  const StreakCommentRepliesBox({
    Key? key,
    required this.momentId,
    required this.commentId,
    required this.id,
    required this.replyInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TextEditingController userCommentTextCtrl = useTextEditingController();
    ErProfile cInfo = replyInfo.replyOwnerProfile!;
    return Container(
      width: SizeConfig.screenWidth,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(0, 0.2),
            blurRadius: 1,
          )
        ],
        // border: Border.all(
        //   color: Colors.grey,
        //   width: 0.5,
        // ),
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
              child: cInfo.profilePicture?.isEmpty ?? false
                  ? Image.asset("assets/images/app-logo.png")
                  : null,
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                final progress = ProgressHUD.of(context);
                progress?.showWithText('Viewing Reacher...');
                Future.delayed(const Duration(seconds: 3), () {
                  globals.userBloc!
                      .add(GetRecipientProfileEvent(email: cInfo.authId));
                  cInfo.authId == globals.user!.id
                      ? RouteNavigators.route(context, const NewAccountScreen())
                      : RouteNavigators.route(
                          context,
                          RecipientAccountProfile(
                            recipientEmail: 'email',
                            recipientImageUrl: cInfo.profilePicture,
                            recipientId: cInfo.authId,
                          ));
                  progress?.dismiss();
                });
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            replyInfo.createdAt.toString()),
                        color: const Color(0xff252525).withOpacity(0.5),
                        size: 11.44,
                        weight: FontWeight.w600,
                      ),
                    ]),
                  ]),
            )
          ]),
          Visibility(
            visible: replyInfo.replyOwnerProfile?.authId == globals.userId,
            child: GestureDetector(
              onTap: () {
                Get.bottomSheet(
                    Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                        color: Colors.white,
                      ),
                      child: InkWell(
                        onTap: () {
                          momentCtrl.deleteReply(
                            id: id,
                            replyId: replyInfo.replyId!,
                            momentId: momentId,
                            commentId: commentId,
                          );
                        },
                        child: const SizedBox(
                          height: 30,
                          child: CustomText(
                            text: 'Delete Reply',
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    isScrollControlled: true);
              },
              child: SvgPicture.asset(
                'assets/svgs/kebab card.svg',
                color: const Color(0xff717F85),
              ),
            ),
          ),
        ]),
        Visibility(
            visible: replyInfo.audioMediaItem!.isNotEmpty ||
                replyInfo.content!.isNotEmpty,
            child: const SizedBox(height: 10)),
        Visibility(
          visible: replyInfo.audioMediaItem!.isNotEmpty,
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
                audioPath: replyInfo.audioMediaItem!,
              )),
            ]),
          ),
        ),
        Visibility(
          visible: replyInfo.content!.isNotEmpty,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: SizeConfig.screenWidth,
            child: CustomText(
              text: replyInfo.content.toString(),
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
                LikeButton(
                  size: 23,
                  countBuilder: (count, isLiked, text) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: CustomText(
                        text: count.toString(),
                        weight: FontWeight.w600,
                        color: Colors.black,
                        size: 15,
                      ),
                    );
                  },
                  likeCountPadding: const EdgeInsets.all(0),
                  isLiked: replyInfo.isLiked,
                  countPostion: CountPostion.right,
                  onTap: (isLiked) async {
                    momentFeedStore.likeCommentReply(
                      commentId: commentId,
                      streakId: momentId,
                      replyId: replyInfo.replyId!,
                      isLiking: !isLiked,
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
                  likeCount: replyInfo.nLikes,
                ),
                ///////////////////
                // InkWell(
                //   onTap: () {
                //     momentFeedStore.likeCommentReply(
                //       commentId: commentId,
                //       streakId: momentId,
                //       replyId: replyInfo.replyId!,
                //       isLiking: !replyInfo.isLiked!,
                //     );
                //   },
                //   child: SvgPicture.asset(
                //     replyInfo.isLiked!
                //         ? 'assets/svgs/like-active.svg'
                //         : 'assets/svgs/like.svg',
                //   ),
                // ),
                // const SizedBox(width: 3),
                // CustomText(
                //   text: momentFeedStore.getCountValue(
                //     value: replyInfo.nLikes!,
                //   ),
                //   size: 15,
                //   isCenter: true,
                //   weight: FontWeight.w600,
                //   color: const Color(0xff001824),
                // )
              ]),
              // const SizedBox(width: 12),
              // InkWell(
              //   onTap: () {
              //     // replyMomentComment(context, userCommentTextCtrl);
              //   },
              //   child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         SvgPicture.asset(
              //           'assets/svgs/comment.svg',
              //         ),
              //         const SizedBox(width: 3),
              //         CustomText(
              //           text: momentFeedStore.getCountValue(
              //             value: replyInfo.nLikes!,
              //           ),
              //           size: 15,
              //           isCenter: true,
              //           weight: FontWeight.w600,
              //           color: const Color(0xff001824),
              //         )
              //       ]),
              // ),
              // SvgPicture.asset(
              //   'assets/svgs/message.svg',
              //   color: Colors.black,
              //   width: 24.44,
              //   height: 22,
              // ),
            ]),
          ),
          // Visibility(
          //   visible: replyInfo.nReplies! > 0,
          //   child: GestureDetector(
          //     onTap: () {
          //       momentCtrl.fetchReplies(
          //         commentId: replyInfo.commentId!,
          //         streakId: momentFeed.momentId,
          //       );
          //       Get.bottomSheet(
          //           StreakCommentReplies(
          //             commentId: replyInfo.commentId!,
          //             streakId: momentFeed.momentId,
          //           ),
          //           isScrollControlled: true);
          //     },
          //     child: Container(
          //       padding: const EdgeInsets.only(
          //         right: 3,
          //         left: 3,
          //         top: 20,
          //         bottom: 3,
          //       ),
          //       alignment: Alignment.center,
          //       decoration: BoxDecoration(
          //           border: Border(
          //               bottom: BorderSide(
          //                   width: 0.5, color: Colors.blue.withOpacity(0.5)))),
          //       child: const CustomText(
          //         text: 'view replies',
          //         color: Colors.blue,
          //         weight: FontWeight.w300,
          //         size: 14,
          //       ),
          //     ),
          //   ),
          // )
          /////////////////////////////////////////
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
}
