import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/moment/momentControlRoom/models/comment_reply.dart';
import 'package:reach_me/features/moment/streak_comment_replies_box.dart';
import 'package:reach_me/features/moment/user_posting.dart';

import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/app_globals.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/custom_text.dart';
import '../../core/utils/dimensions.dart';
import '../../core/utils/helpers.dart';
import '../account/presentation/views/account.dart';
import '../home/presentation/bloc/user-bloc/user_bloc.dart';
import '../profile/new_account.dart';
import 'momentControlRoom/control_room.dart';
import 'momentControlRoom/models/get_comments_model.dart';
import 'moment_audio_player.dart';
import 'moment_feed.dart';

class StreakCommentReplies extends StatelessWidget {
  final CustomMomentCommentModel commentInfo;
  final MomentModel momentFeed;
  final String id;

  const StreakCommentReplies({
    super.key,
    required this.commentInfo,
    required this.id,
    required this.momentFeed,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      CommentOwnerProfile cInfo =
          commentInfo.getMomentComment.commentOwnerProfile!;
      List<GetMomentCommentReply> replies =
          momentCtrl.repliesBox[commentInfo.getMomentComment.commentId] ?? [];
      return Container(
        height: SizeConfig.screenHeight * 0.65,
        width: SizeConfig.screenWidth,
        padding: const EdgeInsets.only(top: 5),
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
            const SizedBox(height: 20),
            /////////////////////
            Container(
              width: SizeConfig.screenWidth,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                        height: 30,
                        width: 30,
                        padding: EdgeInsets.all(
                            cInfo.profilePicture!.isNotEmpty ? 0 : 5),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(30),
                            image: cInfo.profilePicture!.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(cInfo.profilePicture!),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                        child: momentFeed
                                    .momentOwnerInfo.profilePicture?.isEmpty ??
                                false
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
                                email: commentInfo.getMomentComment
                                    .commentOwnerProfile?.authId));
                            commentInfo.getMomentComment.commentOwnerProfile
                                        ?.authId ==
                                    globals.user!.id
                                ? RouteNavigators.route(
                                    context, const NewAccountScreen())
                                : RouteNavigators.route(
                                    context,
                                    RecipientAccountProfile(
                                      recipientEmail: 'email',
                                      recipientImageUrl: momentFeed
                                          .momentOwnerInfo.profilePicture,
                                      recipientId:
                                          momentFeed.momentOwnerInfo.authId,
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
                                      text: cInfo.location
                                          .toString()
                                          .toCapitalized(),
                                      color: const Color(0xff252525)
                                          .withOpacity(0.5),
                                      size: 10.44,
                                      weight: FontWeight.w600,
                                    ),
                                    const SizedBox(width: 5),
                                  ]),
                                ),
                                CustomText(
                                  text: Helper.parseUserLastSeen(
                                      commentInfo.getMomentComment.createdAt!),
                                  color:
                                      const Color(0xff252525).withOpacity(0.5),
                                  size: 11.44,
                                  weight: FontWeight.w600,
                                ),
                              ]),
                            ]),
                      )
                    ]),
                    Visibility(
                        visible: commentInfo
                                .getMomentComment.audioMediaItem!.isNotEmpty ||
                            commentInfo.getMomentComment.content!.isNotEmpty,
                        child: const SizedBox(height: 10)),
                    Visibility(
                      visible: commentInfo
                          .getMomentComment.audioMediaItem!.isNotEmpty,
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
                            audioPath:
                                commentInfo.getMomentComment.audioMediaItem!,
                          )),
                        ]),
                      ),
                    ),
                    Visibility(
                      visible: commentInfo.getMomentComment.content!.isNotEmpty,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 3),
                        width: SizeConfig.screenWidth,
                        child: CustomText(
                          text: commentInfo.getMomentComment.content.toString(),
                          size: 14,
                        ),
                      ),
                    ),
                  ]),
            ),
            Divider(
              height: 0,
              color: Colors.grey.withOpacity(0.5),
              thickness: 0.8,
            ),
            /////////////////////
            Expanded(
              child: ListView.builder(
                  itemCount: replies.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 5, right: 20, left: 20),
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    GetMomentCommentReply replyInfo = replies[index];
                    return StreakCommentRepliesBox(
                      momentId: momentFeed.momentId,
                      id: id,
                      commentId: commentInfo.getMomentComment.commentId!,
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
