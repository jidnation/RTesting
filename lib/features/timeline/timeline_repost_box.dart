import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/view_words_dialog.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';
import 'package:reach_me/features/timeline/post_media.dart';
import 'package:reach_me/features/timeline/timeline_feed.dart';
import 'package:reach_me/features/timeline/video_player.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_globals.dart';
import '../../core/utils/custom_text.dart';
import '../account/presentation/views/account.dart';
import '../moment/moment_audio_player.dart';
import '../profile/new_account.dart';
import '../profile/recipientNewAccountProfile.dart';

class TimelineRepostedPost extends StatelessWidget {
  final PostModel tPostInfo;
  const TimelineRepostedPost({Key? key, required this.tPostInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostProfileModel tPostOwnerInfo = tPostInfo.repostedPostOwnerProfile!;
    List<String> images = tPostInfo.repostedPost!.imageMediaItems ?? [];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.greyShade10)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //////
            Row(children: [
              Container(
                height: 35,
                width: 35,
                padding: EdgeInsets.all(
                    tPostOwnerInfo.profilePicture!.isNotEmpty ? 0 : 5),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                    image: tPostOwnerInfo.profilePicture!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(tPostOwnerInfo.profilePicture!),
                            fit: BoxFit.cover,
                          )
                        : null),
                child: tPostOwnerInfo.profilePicture!.isEmpty
                    ? Image.asset("assets/images/app-logo.png")
                    : null,
              ),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                GestureDetector(
                  onTap: () {
                    // if (onViewProfile != null) {
                    //   onViewProfile!();
                    if (false) {
                      // onViewProfile!();
                    } else {
                      final progress = ProgressHUD.of(context);
                      progress?.showWithText('Viewing Reacher...');
                      Future.delayed(const Duration(seconds: 3), () {
                        globals.userBloc!.add(GetRecipientProfileEvent(
                            email: tPostOwnerInfo.authId));
                        tPostOwnerInfo.authId == globals.user!.id
                            ? RouteNavigators.route(
                                context, const NewAccountScreen())
                            : RouteNavigators.route(
                                context,
                                RecipientAccountProfile(
                                  recipientEmail: 'email',
                                  recipientImageUrl:
                                      tPostOwnerInfo.profilePicture,
                                  recipientId: tPostOwnerInfo.authId,
                                ));
                        progress?.dismiss();
                      });
                    }
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          text:
                              "@${tPostOwnerInfo.username.toString().toCapitalized()}",
                          color: Colors.black,
                          size: 14.28,
                          weight: FontWeight.w600,
                        ),
                        const SizedBox(width: 10),
                        tPostOwnerInfo.verified!
                            ? SvgPicture.asset('assets/svgs/verified.svg')
                            : const SizedBox.shrink()
                      ]),
                ),
                const SizedBox(height: 1.5),
                Row(children: [
                  Visibility(
                    visible: tPostInfo.location!.isNotEmpty &&
                        tPostInfo.location!.toLowerCase().trim() != 'nil',
                    child: Row(children: [
                      CustomText(
                        text: tPostInfo.location.toString().length > 23
                            ? tPostInfo.location
                                .toString()
                                .trim()
                                .toCapitalized()
                                .substring(0, 23)
                            : tPostInfo.location
                                .toString()
                                .trim()
                                .toCapitalized(),
                        color: const Color(0xff252525).withOpacity(0.5),
                        size: 10.44,
                        weight: FontWeight.w600,
                      ),
                      SizedBox(
                          width: tPostInfo.location!.isNotEmpty &&
                                  tPostInfo.location!.toLowerCase().trim() !=
                                      'nil'
                              ? 5
                              : 0),
                    ]),
                  ),
                  CustomText(
                    text: Helper.parseUserLastSeen(
                        tPostInfo.createdAt.toString()),
                    color: const Color(0xff252525).withOpacity(0.5),
                    size: 11.44,
                    weight: FontWeight.w600,
                  ),
                  SizedBox(
                      width: tPostInfo.location!.isNotEmpty &&
                                  tPostInfo.location!.toLowerCase().trim() !=
                                      'nil' ||
                              tPostInfo.location!.toLowerCase().trim() !=
                                  'NIL' ||
                              tPostInfo.location!.toLowerCase().trim() != 'Nil'
                          ? 5
                          : 0),
                ]),
              ]),
            ]),
            const SizedBox(height: 8),
            Visibility(
              visible: tPostInfo.repostedPost!.content!.isNotEmpty,
              child: ExpandableText(
                "${tPostInfo.repostedPost!.content}",
                prefixText:
                    tPostInfo.repostedPost!.edited! ? "(Reach Edited)" : null,
                prefixStyle: TextStyle(
                    fontSize: getScreenHeight(12),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryColor),
                onPrefixTap: () {
                  // tooltipkey.currentState?.ensureTooltipVisible();
                },
                expandText: 'see more',
                maxLines: 2,
                linkColor: Colors.blue,
                animation: true,
                expanded: false,
                collapseText: 'see less',
                onHashtagTap: (value) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DictionaryDialog(
                          abbr: value,
                          meaning: '',
                          word: '',
                        );
                      });
                },
                onMentionTap: (value) {
                  timeLineFeedStore.getUserByUsername(context, username: value);
                },
                mentionStyle: const TextStyle(
                    decoration: TextDecoration.underline, color: Colors.blue),
                hashtagStyle: const TextStyle(
                    decoration: TextDecoration.underline, color: Colors.blue),
              ).paddingSymmetric(h: 16, v: 10),
            ),
            SizedBox(
                height: tPostInfo.repostedPost!.content!.isNotEmpty ? 8 : 0),
            Visibility(
                visible: images.isNotEmpty,
                child: TimeLinePostMedia(post: tPostInfo.repostedPost!)),
            SizedBox(
                height: tPostInfo.repostedPost!.videoMediaItem!.isNotEmpty
                    ? 10
                    : 0),
            tPostInfo.repostedPost!.videoMediaItem!.isNotEmpty
                ? Container(
                    height: 310,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    child: TimeLineVideoPlayer(
                      post: tPostInfo,
                      videoUrl: tPostInfo.repostedPost!.videoMediaItem!,
                      // ),
                    ),
                  )
                : const SizedBox.shrink(),
            SizedBox(
                height: tPostInfo.repostedPost!.audioMediaItem!.isNotEmpty
                    ? 10
                    : 0),
            Visibility(
              visible: tPostInfo.repostedPost!.audioMediaItem!.isNotEmpty,
              child: Container(
                height:
                    tPostInfo.repostedPost!.audioMediaItem!.isNotEmpty ? 59 : 0,
                margin: const EdgeInsets.only(bottom: 10),
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xfff5f5f5)),
                child: Row(children: [
                  Expanded(
                      child: MomentAudioPlayer(
                    id: "${tPostInfo.postSlug}${tPostInfo.repostedPost!.audioMediaItem}",
                    audioPath: tPostInfo.repostedPost!.audioMediaItem!,
                  )),
                ]),
              ),
            ),
            SizedBox(
              height: (tPostInfo.repostedPost!.audioMediaItem!.isNotEmpty ||
                      tPostInfo.repostedPost!.videoMediaItem!.isNotEmpty ||
                      tPostInfo.repostedPost!.content!.isNotEmpty)
                  ? 8
                  : 0,
            ),

            /////////////////
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     CupertinoButton(
            //       minSize: 0,
            //       padding: EdgeInsets.zero,
            //       onPressed: () {
            //         final progress = ProgressHUD.of(context);
            //         progress?.showWithText('Viewing Reacher...');
            //         // Future.delayed(const Duration(seconds: 3),
            //         //         () {
            //         //       globals.userBloc!.add(
            //         //           GetRecipientProfileEvent(
            //         //               email: post.postOwnerProfile!.authId));
            //         //        post.postOwnerProfile!.authId ==
            //         //           globals.user!.id
            //         //           ? RouteNavigators.route(
            //         //           context, const AccountScreen())
            //         //           : RouteNavigators.route(
            //         //           context,
            //         //           RecipientAccountProfile(
            //         //             recipientEmail: 'email',
            //         //             recipientImageUrl:  post.postOwnerProfile!.profilePicture,
            //         //             recipientId:  post.postOwnerProfile!.authId,
            //         //           ));
            //         //       progress?.dismiss();
            //         //     });
            //
            //         Future.delayed(const Duration(seconds: 3), () {
            //           globals.userBloc!.add(GetRecipientProfileEvent(
            //               email: post.repostedPostOwnerProfile!.authId));
            //           post.repostedPostOwnerProfile!.authId == globals.user!.id
            //               ? RouteNavigators.route(context, const AccountScreen())
            //               : RouteNavigators.route(
            //                   context,
            //                   RecipientAccountProfile(
            //                     recipientEmail: 'email',
            //                     recipientImageUrl:
            //                         post.repostedPostOwnerProfile!.profilePicture,
            //                     recipientId:
            //                         post.repostedPostOwnerProfile!.authId,
            //                   ));
            //           progress?.dismiss();
            //         });
            //       },
            //       child: Row(
            //         children: [
            //           Helper.renderProfilePicture(
            //             post.repostedPostOwnerProfile?.profilePicture,
            //             size: 40,
            //           ).paddingOnly(l: 13, t: 10),
            //           SizedBox(width: getScreenWidth(9)),
            //           Column(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Row(
            //                 children: [
            //                   Text(
            //                     '@${post.repostedPostOwnerProfile?.username ?? ''}',
            //                     style: TextStyle(
            //                       fontSize: getScreenHeight(14),
            //                       fontFamily: 'Poppins',
            //                       fontWeight: FontWeight.w500,
            //                       color: AppColors.textColor2,
            //                     ),
            //                   ),
            //                   const SizedBox(width: 3),
            //                   post.repostedPostOwnerProfile?.verified ?? false
            //                       ? SvgPicture.asset('assets/svgs/verified.svg')
            //                       : const SizedBox.shrink()
            //                 ],
            //               ),
            //               Row(
            //                 children: [
            //                   Text(
            //                     post.repostedPost!.location! == 'nil'
            //                         ? ''
            //                         : post.repostedPost!.location!,
            //                     style: TextStyle(
            //                       fontSize: getScreenHeight(10),
            //                       fontFamily: 'Poppins',
            //                       letterSpacing: 0.4,
            //                       fontWeight: FontWeight.w400,
            //                       color: AppColors.textColor2,
            //                     ),
            //                   ),
            //                   Text(
            //                     postDuration,
            //                     style: TextStyle(
            //                       fontSize: getScreenHeight(10),
            //                       fontFamily: 'Poppins',
            //                       letterSpacing: 0.4,
            //                       fontWeight: FontWeight.w400,
            //                       color: AppColors.textColor2,
            //                     ),
            //                   ).paddingOnly(l: 6),
            //                 ],
            //               )
            //             ],
            //           ).paddingOnly(t: 10),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // post.repostedPost!.content == null
            //     ? const SizedBox.shrink()
            //     : Row(
            //         children: [
            //           Flexible(
            //             child: ExpandableText(
            //               "${post.repostedPost!.content}",
            //               style: TextStyle(
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: getScreenHeight(14)),
            //               maxLines: 3,
            //               animation: true,
            //               collapseText: 'see less',
            //               expandText: 'see more',
            //               onHashtagTap: (value) {
            //                 showDialog(
            //                     context: context,
            //                     builder: (BuildContext context) {
            //                       return DictionaryDialog(
            //                         abbr: value,
            //                         meaning: '',
            //                         word: '',
            //                       );
            //                     });
            //               },
            //               onMentionTap: (value) {},
            //               mentionStyle: const TextStyle(
            //                   decoration: TextDecoration.underline,
            //                   color: Colors.blue),
            //               hashtagStyle: const TextStyle(
            //                   decoration: TextDecoration.underline,
            //                   color: Colors.blue),
            //             ),
            //           ),
            //           SizedBox(width: getScreenWidth(2)),
            //           Tooltip(
            //             message: 'This Reach has been edited by the Reacher',
            //             waitDuration: const Duration(seconds: 1),
            //             showDuration: const Duration(seconds: 2),
            //             child: Text(
            //               post.repostedPost!.edited! ? "(Reach Edited)" : "",
            //               style: TextStyle(
            //                 fontSize: getScreenHeight(12),
            //                 fontFamily: 'Poppins',
            //                 fontWeight: FontWeight.w400,
            //                 color: AppColors.primaryColor,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ).paddingSymmetric(h: 16, v: 10),
            // if ((post.repostedPost?.imageMediaItems ?? []).isNotEmpty)
            //   Helper.renderPostImages(post.repostedPost!, context)
            //       .paddingOnly(r: 16, l: 16, b: 16, t: 10)
            // else
            //   const SizedBox.shrink(),
          ]),
    );
  }
}
