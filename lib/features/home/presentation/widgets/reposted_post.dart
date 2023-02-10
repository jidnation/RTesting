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
import 'package:reach_me/features/home/presentation/widgets/post_media.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_globals.dart';
import '../../../account/presentation/views/account.dart';
import '../../../moment/moment_audio_player.dart';
import '../../../profile/new_account.dart';
import '../../../profile/recipientNewAccountProfile.dart';
import '../../../timeline/video_player.dart';

class RepostedPost extends StatelessWidget {
  final PostModel post;
  const RepostedPost({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postDuration = timeago.format(post.repostedPost!.createdAt!);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.greyShade10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                minSize: 0,
                padding: EdgeInsets.zero,
                onPressed: () {
                  final progress = ProgressHUD.of(context);
                  progress?.showWithText('Viewing Reacher...');
                  // Future.delayed(const Duration(seconds: 3),
                  //         () {
                  //       globals.userBloc!.add(
                  //           GetRecipientProfileEvent(
                  //               email: post.postOwnerProfile!.authId));
                  //        post.postOwnerProfile!.authId ==
                  //           globals.user!.id
                  //           ? RouteNavigators.route(
                  //           context, const AccountScreen())
                  //           : RouteNavigators.route(
                  //           context,
                  //           RecipientAccountProfile(
                  //             recipientEmail: 'email',
                  //             recipientImageUrl:  post.postOwnerProfile!.profilePicture,
                  //             recipientId:  post.postOwnerProfile!.authId,
                  //           ));
                  //       progress?.dismiss();
                  //     });

                  Future.delayed(const Duration(seconds: 3), () {
                    globals.userBloc!.add(GetRecipientProfileEvent(
                        email: post.repostedPostOwnerProfile!.authId));
                    post.repostedPostOwnerProfile!.authId == globals.user!.id
                        ? RouteNavigators.route(
                            context, const NewAccountScreen())
                        : RouteNavigators.route(
                            context,
                            RecipientAccountProfile(
                              recipientEmail: 'email',
                              recipientImageUrl:
                                  post.repostedPostOwnerProfile!.profilePicture,
                              recipientId:
                                  post.repostedPostOwnerProfile!.authId,
                            ));
                    progress?.dismiss();
                  });
                },
                child: Row(
                  children: [
                    Helper.renderProfilePicture(
                      post.repostedPostOwnerProfile?.profilePicture,
                      size: 40,
                    ).paddingOnly(l: 13, t: 10),
                    SizedBox(width: getScreenWidth(9)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              '@${post.repostedPostOwnerProfile?.username ?? ''}',
                              style: TextStyle(
                                fontSize: getScreenHeight(14),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor2,
                              ),
                            ),
                            const SizedBox(width: 3),
                            post.repostedPostOwnerProfile?.verified ?? false
                                ? SvgPicture.asset('assets/svgs/verified.svg')
                                : const SizedBox.shrink()
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              post.repostedPost!.location!
                                          .toLowerCase()
                                          .trim()
                                          .toString() ==
                                      'nil'
                                  ? ''
                                  : post.repostedPost!.location!.length > 23
                                      ? post.repostedPost!.location!
                                          .substring(0, 23)
                                      : post.repostedPost!.location!,
                              style: TextStyle(
                                fontSize: getScreenHeight(10),
                                fontFamily: 'Poppins',
                                letterSpacing: 0.4,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor2,
                              ),
                            ),
                            Text(
                              postDuration,
                              style: TextStyle(
                                fontSize: getScreenHeight(10),
                                fontFamily: 'Poppins',
                                letterSpacing: 0.4,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor2,
                              ),
                            ).paddingOnly(l: 6),
                          ],
                        )
                      ],
                    ).paddingOnly(t: 10),
                  ],
                ),
              ),
            ],
          ),
          post.repostedPost!.content == null
              ? const SizedBox.shrink()
              : Row(
                  children: [
                    Flexible(
                      child: ExpandableText(
                        "${post.repostedPost!.content}",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: getScreenHeight(14)),
                        maxLines: 3,
                        animation: true,
                        collapseText: 'see less',
                        expandText: 'see more',
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
                        onMentionTap: (value) {},
                        mentionStyle: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue),
                        hashtagStyle: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue),
                      ),
                    ),
                    SizedBox(width: getScreenWidth(2)),
                    Tooltip(
                      message: 'This Reach has been edited by the Reacher',
                      waitDuration: const Duration(seconds: 1),
                      showDuration: const Duration(seconds: 2),
                      child: Text(
                        post.repostedPost!.edited! ? "(Reach Edited)" : "",
                        style: TextStyle(
                          fontSize: getScreenHeight(12),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ).paddingSymmetric(h: 16, v: 10),
          if ((post.repostedPost?.imageMediaItems ?? []).isNotEmpty)
            PostMedia(post: post).paddingOnly(r: 16, l: 16, b: 16, t: 10)
          else
            const SizedBox.shrink(),
          if ((post.repostedPost?.videoMediaItem ?? '').isNotEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: TimeLineVideoPlayer(
                  post: post,
                  videoUrl: post.repostedPost?.videoMediaItem ?? ''),
            )
          else
            const SizedBox.shrink(),
          (post.repostedPost?.audioMediaItem ?? '').isNotEmpty
              ? Container(
                  height: 59,
                  margin: const EdgeInsets.only(bottom: 10),
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xfff5f5f5)),
                  child: Row(children: [
                    Expanded(
                        child: MomentAudioPlayer(
                      audioPath: post.repostedPost?.audioMediaItem ?? '',
                    )),
                  ]),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
