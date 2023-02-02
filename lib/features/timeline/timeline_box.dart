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
import '../home/presentation/bloc/user-bloc/user_bloc.dart';
import '../home/presentation/views/full_post.dart';
import '../moment/moment_audio_player.dart';

class TimeLineBox extends StatelessWidget {
  final TimeLineModel timeLineModel;
  final Function()? takeScreenShot;
  final List<StatusFeedResponseModel>? userStatusFeed;
  const TimeLineBox({
    Key? key,
    required this.takeScreenShot,
    required this.timeLineModel,
    this.userStatusFeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ErProfile? tVoterInfo = timeLineModel.getPostFeed.voterProfile;
    Post? tPostInfo = timeLineModel.getPostFeed.post;
    ErProfile? tPostOwnerInfo = tPostInfo?.postOwnerProfile;

    //working on the images
    List<String> images = tPostInfo?.imageMediaItems ?? [];

    Future<String> saveImage(Uint8List? bytes) async {
      await [Permission.storage].request();
      String time = DateTime.now().microsecondsSinceEpoch.toString();
      final name = 'screenshot_${time}_reachme';
      final result = await ImageGallerySaver.saveImage(bytes!, name: name);
      debugPrint("Result ${result['filePath']}");
      Snackbars.success(context, message: 'Image saved to Gallery');
      RouteNavigators.pop(context);
      return result['filePath'];
    }

    final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (builder) => FullPostScreen(
                postFeedModel: timeLineFeedStore.getPostModel(
                    timeLineModel: timeLineModel),
              ))),
      child: Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Visibility(
            visible: tVoterInfo != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: RichText(
                    text: TextSpan(
                        text:
                            '@${tVoterInfo?.authId != globals.userId ? tVoterInfo?.username?.appendOverflow(15) : 'You'}',
                        style: const TextStyle(
                            color: AppColors.black,
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                        children: const [
                          TextSpan(
                              text: ' shouted out this reach',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w500))
                        ]),
                  ),
                ),
                SizedBox(
                  height: getScreenHeight(8),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                GestureDetector(
                  onTap: userStatusFeed != null
                      ? () async {
                          if (userStatusFeed!
                              .any((e) => e.id == tPostOwnerInfo!.username)) {
                            showProfilePictureOrViewStatus(context,
                                tPostOwnerInfo: tPostOwnerInfo!,
                                userStatus: userStatusFeed!);
                          } else if (tPostOwnerInfo!
                              .profilePicture!.isNotEmpty) {
                            RouteNavigators.route(
                              context,
                              pictureViewer(context,
                                  ownerProfilePicture: tPostOwnerInfo),
                            );
                          } else {
                            Snackbars.error(context,
                                message: 'No Profile Photo');
                          }
                        }
                      : null,
                  child: Container(
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
                                    tPostOwnerInfo.profilePicture!),
                                fit: BoxFit.cover,
                              )
                            : null),
                    child: tPostOwnerInfo.profilePicture!.isEmpty
                        ? Image.asset("assets/images/app-logo.png")
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // if (onViewProfile != null) {
                                  //   onViewProfile!();
                                  if (false) {
                                    // onViewProfile!();
                                  } else {
                                    final progress = ProgressHUD.of(context);
                                    progress
                                        ?.showWithText('Viewing Reacher...');
                                    Future.delayed(const Duration(seconds: 3),
                                        () {
                                      globals.userBloc!.add(
                                          GetRecipientProfileEvent(
                                              email: timeLineModel
                                                  .getPostFeed
                                                  .post!
                                                  .postOwnerProfile!
                                                  .authId));
                                      timeLineModel.getPostFeed.post!
                                                  .postOwnerProfile!.authId ==
                                              globals.user!.id
                                          ? RouteNavigators.route(
                                              context, const AccountScreen())
                                          : RouteNavigators.route(
                                              context,
                                              RecipientAccountProfile(
                                                recipientEmail: 'email',
                                                recipientImageUrl: timeLineModel
                                                    .getPostFeed
                                                    .post!
                                                    .postOwnerProfile!
                                                    .profilePicture,
                                                recipientId: timeLineModel
                                                    .getPostFeed
                                                    .post!
                                                    .postOwnerProfile!
                                                    .authId,
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
                                          ? SvgPicture.asset(
                                              'assets/svgs/verified.svg')
                                          : const SizedBox.shrink()
                                    ]),
                              ),
                              const SizedBox(height: 1.5),
                              Row(children: [
                                Visibility(
                                  visible: tPostInfo!.location!.isNotEmpty &&
                                      tPostInfo.location!
                                              .toLowerCase()
                                              .trim() !=
                                          'nil',
                                  child: Row(children: [
                                    CustomText(
                                      text:
                                          tPostInfo.location.toString().length >
                                                  23
                                              ? tPostInfo.location
                                                  .toString()
                                                  .trim()
                                                  .toCapitalized()
                                                  .substring(0, 23)
                                              : tPostInfo.location
                                                  .toString()
                                                  .trim()
                                                  .toCapitalized(),
                                      color: const Color(0xff252525)
                                          .withOpacity(0.5),
                                      size: 10.44,
                                      weight: FontWeight.w600,
                                    ),
                                    SizedBox(
                                        width: tPostInfo.location!.isNotEmpty &&
                                                tPostInfo.location!
                                                        .toLowerCase()
                                                        .trim() !=
                                                    'nil'
                                            ? 5
                                            : 0),
                                  ]),
                                ),
                                CustomText(
                                  text: Helper.parseUserLastSeen(
                                      tPostInfo.createdAt.toString()),
                                  color:
                                      const Color(0xff252525).withOpacity(0.5),
                                  size: 11.44,
                                  weight: FontWeight.w600,
                                ),
                              ]),
                            ]),
                        InkWell(
                          onTap: () async {
                            await showReacherTimeLineCardBottomSheet(
                              context,
                              type: userStatusFeed == null ? 'profile' : 'post',
                              downloadPost: takeScreenShot,
                              timeLineModel: timeLineModel,
                            );
                          },
                          child: SizedBox(
                            height: 30,
                            width: 40,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/kebab card.svg',
                                    color: const Color(0xff717F85),
                                  ),
                                ]),
                          ),
                        )
                      ]),
                ),
              ]),
              const SizedBox(height: 8),
              Visibility(
                visible: tPostInfo.content!.isNotEmpty,
                child: ExpandableText(
                  "${tPostInfo.content}",
                  prefixText: tPostInfo.edited! ? "(Reach Edited)" : null,
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
                    timeLineFeedStore.getUserByUsername(context,
                        username: value);

                    debugPrint("Value $value");
                  },
                  mentionStyle: const TextStyle(
                      decoration: TextDecoration.underline, color: Colors.blue),
                  hashtagStyle: const TextStyle(
                      decoration: TextDecoration.underline, color: Colors.blue),
                ).paddingSymmetric(h: 16, v: 10),
              ),
              Tooltip(
                key: tooltipkey,
                triggerMode: TooltipTriggerMode.manual,
                showDuration: const Duration(seconds: 1),
                message:
                    'This reach was edited ${Helper.parseUserLastSeen(tPostInfo.updatedAt.toString())}',
              ),
              SizedBox(height: tPostInfo.content!.isNotEmpty ? 8 : 0),
              Visibility(
                  visible: images.isNotEmpty,
                  child: TimeLinePostMedia(
                      post: timeLineFeedStore
                          .getPostModel(timeLineModel: timeLineModel)!
                          .post!)),
              SizedBox(height: tPostInfo.videoMediaItem!.isNotEmpty ? 10 : 0),
              timeLineModel.getPostFeed.post!.videoMediaItem!.isNotEmpty
                  ? Container(
                      height: 310,
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                      ),
                      child: TimeLineVideoPlayer(
                        post: timeLineFeedStore
                            .getPostModel(timeLineModel: timeLineModel)!
                            .post!,
                        videoUrl:
                            timeLineModel.getPostFeed.post!.videoMediaItem!,
                        // ),
                      ),
                    )
                  : const SizedBox.shrink(),
              SizedBox(height: tPostInfo.audioMediaItem!.isNotEmpty ? 10 : 0),
              Visibility(
                visible: tPostInfo.audioMediaItem!.isNotEmpty,
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
                      id: timeLineModel.id,
                      audioPath: tPostInfo.audioMediaItem!,
                    )),
                  ]),
                ),
              ),
              SizedBox(
                  height: (tPostInfo.audioMediaItem!.isNotEmpty ||
                          tPostInfo.videoMediaItem!.isNotEmpty ||
                          tPostInfo.content!.isNotEmpty)
                      ? 8
                      : 0),
              (timeLineModel.getPostFeed.post!.repostedPost != null)
                  ? TimelineRepostedPost(
                      tPostInfo: timeLineFeedStore
                          .getPostModel(timeLineModel: timeLineModel)!
                          .post!,
                    ).paddingOnly(l: 0, r: 0, b: 10, t: 0)
                  : const SizedBox.shrink(),
              const SizedBox(height: 42),
            ]),
          ),
        ]),
      ),
    );
  }
}
