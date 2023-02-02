import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/features/home/data/models/status.model.dart';
import 'package:reach_me/features/timeline/image_loader.dart';
import 'package:reach_me/features/timeline/models/post_feed.dart';
import 'package:reach_me/features/timeline/post_media.dart';
import 'package:reach_me/features/timeline/show_reacher_bottom_card.dart';
import 'package:reach_me/features/timeline/timeline_control_room.dart';
import 'package:reach_me/features/timeline/timeline_feed.dart';
import 'package:reach_me/features/timeline/timeline_repost_box.dart';
import 'package:reach_me/features/timeline/video_player.dart';

import '../../core/components/snackbar.dart';
import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/app_globals.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/custom_text.dart';
import '../../core/utils/dimensions.dart';
import '../../core/utils/helpers.dart';
import '../account/presentation/views/account.dart';
import '../dictionary/presentation/widgets/view_words_dialog.dart';
import '../home/data/models/post_model.dart';
import '../home/presentation/bloc/user-bloc/user_bloc.dart';
import '../home/presentation/views/full_post.dart';
import '../moment/moment_audio_player.dart';
import '../timeline/models/profile_comment_model.dart';

class CommentBox extends StatelessWidget {
  final GetPersonalComment getPersonalComment;
  final Function()? takeScreenShot;
  final List<StatusFeedResponseModel>? userStatusFeed;
  const CommentBox({
    Key? key,
    required this.takeScreenShot,
    required this.getPersonalComment,
    this.userStatusFeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CommentOwnerProfile? tPostOwnerInfo = getPersonalComment.postOwnerProfile;
    CommentOwnerProfile? tCommentOwnerInfo =
        getPersonalComment.commentOwnerProfile;

    //working on the images
    List<String> images = getPersonalComment.imageMediaItems ?? [];

    final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

    return Container(
      width: SizeConfig.screenWidth,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                height: 35,
                width: 35,
                padding: EdgeInsets.all(
                    tPostOwnerInfo!.profilePicture!.isNotEmpty ? 0 : 5),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                    image: tPostOwnerInfo.profilePicture!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(
                                tCommentOwnerInfo!.profilePicture!),
                            fit: BoxFit.cover,
                          )
                        : null),
                child: tCommentOwnerInfo!.profilePicture!.isEmpty
                    ? Image.asset("assets/images/app-logo.png")
                    : null,
              ),
              SizedBox(width: getScreenWidth(9)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        '@${tCommentOwnerInfo.username}',
                        style: TextStyle(
                          fontSize: getScreenHeight(15),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor2,
                        ),
                      ),
                      // const SizedBox(width: 3),
                      // SvgPicture.asset('assets/svgs/verified.svg')
                    ],
                  ),
                  Text(
                    'Comment on @${tPostOwnerInfo.username}',
                    style: TextStyle(
                      fontSize: getScreenHeight(11),
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor2,
                    ),
                  ),
                ],
              ).paddingOnly(t: 10),
            ]),
            Visibility(
              visible: getPersonalComment.content!.isNotEmpty,
              child: ExpandableText(
                "${getPersonalComment.content}",
                prefixStyle: TextStyle(
                    fontSize: getScreenHeight(12),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryColor),
                onPrefixTap: () {
                  tooltipkey.currentState?.ensureTooltipVisible();
                },
                expandText: 'see more',
                maxLines: 3,
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

                  debugPrint("Value $value");
                },
                mentionStyle: const TextStyle(
                    decoration: TextDecoration.underline, color: Colors.blue),
                hashtagStyle: const TextStyle(
                    decoration: TextDecoration.underline, color: Colors.blue),
              ).paddingSymmetric(h: 16, v: 10),
            ),
            const SizedBox(height: 8),
            Visibility(
                visible: images.isNotEmpty,
                child: TimeLinePostMedia(
                    post: PostModel(imageMediaItems: images))),
            SizedBox(
                height: getPersonalComment.videoMediaItem!.isNotEmpty ? 10 : 0),
            getPersonalComment.videoMediaItem!.isNotEmpty
                ? Container(
                    height: 310,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green,
                    ),
                    child: TimeLineVideoPlayer(
                      post: PostModel(postRating: ''),
                      videoUrl: getPersonalComment.videoMediaItem!,
                      // ),
                    ),
                  )
                : const SizedBox.shrink(),
            SizedBox(
                height: getPersonalComment.audioMediaItem!.isNotEmpty ? 10 : 0),
            Visibility(
              visible: getPersonalComment.audioMediaItem!.isNotEmpty,
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
                    id: getPersonalComment.commentId,
                    audioPath: getPersonalComment.audioMediaItem!,
                  )),
                ]),
              ),
            ),
            SizedBox(
                height: (getPersonalComment.audioMediaItem!.isNotEmpty ||
                        getPersonalComment.videoMediaItem!.isNotEmpty ||
                        getPersonalComment.content!.isNotEmpty)
                    ? 8
                    : 0),
            const SizedBox(height: 42),
          ]),
        ),
      ]),
    );
  }
}
