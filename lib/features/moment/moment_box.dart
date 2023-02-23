import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:marquee/marquee.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/home/data/models/post_model.dart' as pt;
import 'package:reach_me/features/moment/user_posting.dart';
import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/app_globals.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/custom_text.dart';
import '../../core/utils/dimensions.dart';
import '../timeline/timeline_feed.dart';
import 'momentControlRoom/control_room.dart';
import 'moment_appbar.dart';
import 'moment_feed.dart';
import 'moment_feed_comment.dart';
import 'moment_videoplayer_item.dart';

class MomentBox extends StatelessWidget {
  final MomentModel momentFeed;
  const MomentBox({Key? key, required this.momentFeed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pt.PostFeedModel _postModel = pt.PostFeedModel(
        feedOwnerId: momentFeed.feedOwnerInfo.authId,
        firstName: momentFeed.feedOwnerInfo.firstName,
        lastName: momentFeed.feedOwnerInfo.lastName,
        location: momentFeed.feedOwnerInfo.location,
        username: "isStreak",
        profilePicture: momentFeed.feedOwnerInfo.profilePicture,
        post: pt.PostModel(
            content:
                momentFeed.caption != 'No Caption' ? momentFeed.caption : "",
            authId: momentFeed.momentOwnerInfo.authId,
            audioMediaItem: momentFeed.soundUrl,
            videoMediaItem: momentFeed.videoUrl,
            postId: momentFeed.momentId,
            postOwnerProfile: pt.PostProfileModel(
              firstName: momentFeed.momentOwnerInfo.firstName,
              lastName: momentFeed.momentOwnerInfo.lastName,
              authId: momentFeed.momentOwnerInfo.authId,
              location: momentFeed.momentOwnerInfo.location,
              profilePicture: momentFeed.momentOwnerInfo.profilePicture,
              profileSlug: momentFeed.momentOwnerInfo.profileSlug,
            )));
    return Stack(children: [
      VideoPlayerItem(
        videoUrl: momentFeed.videoUrl,
      ),
      Positioned(
        top: getScreenHeight(300),
        right: 20,
        child: Align(
          alignment: Alignment.centerRight,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Stack(children: [
              InkWell(
                onTap: () {
                  momentFeedStore.reachUser(
                    toReachId: momentFeed.momentOwnerInfo.authId!,
                    id: momentFeed.id,
                  );
                },
                child: SizedBox(
                  height: 70,
                  child: Column(children: [
                    Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(30),
                          image: momentFeed
                                  .momentOwnerInfo.profilePicture!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(momentFeed
                                      .momentOwnerInfo.profilePicture!),
                                  fit: BoxFit.cover,
                                )
                              : null),
                      child: momentFeed.momentOwnerInfo.profilePicture!.isEmpty
                          ? Image.asset("assets/images/app-logo.png")
                          : null,
                    ),
                  ]),
                ),
              ),
              Positioned(
                  bottom: 10,
                  right: 14,
                  child: Container(
                    height: 20,
                    width: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: momentFeed.reachingUser
                          ? Colors.green
                          : AppColors.primaryColor,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.4,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                        child: Icon(
                      momentFeed.reachingUser ? Icons.check : Icons.add,
                      size: 13,
                      color: Colors.white,
                    )),
                  ))
            ]),
            const SizedBox(height: 10),
            ///////////////////
            LikeButton(
              size: 30,
              countBuilder: (count, isLiked, text) {
                return CustomText(
                  text: count.toString(),
                  weight: FontWeight.w500,
                  color: Colors.white,
                  size: 13.28,
                );
              },
              likeCountPadding: const EdgeInsets.all(0),
              isLiked: momentFeed.isLiked,
              countPostion: CountPostion.bottom,
              onTap: (isLiked) async {
                momentFeedStore.likingMoment(
                    momentId: momentFeed.momentId, id: momentFeed.id);
                return !isLiked;
              },
              circleColor: CircleColor(
                  start: AppColors.primaryColor,
                  end: AppColors.primaryColor.withOpacity(0.5)),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Colors.red,
                dotSecondaryColor: Colors.red.withOpacity(0.6),
              ),
              likeBuilder: (bool isLiked) {
                return Icon(
                  size: 30,
                  isLiked ? Icons.favorite : Icons.favorite_outline_outlined,
                  color: isLiked ? Colors.red : Colors.white,
                );
              },
              likeCount: momentFeed.nLikes,
            ),
            const SizedBox(height: 15),
            MomentFeedComment(momentFeed: momentFeed),
            const SizedBox(height: 15),
            Visibility(
              visible: momentFeed.momentOwnerInfo.authId != globals.userId,
              child: InkWell(
                onTap: () {
                  momentFeedStore.videoCtrl(false);
                  // if (momentFeed.momentOwnerInfo.authId != globals.userId) {
                  HapticFeedback.mediumImpact();

                  timeLineFeedStore.messageUser(context,
                      isStreak: true,
                      quoteData: jsonEncode(_postModel.toJson()),
                      id: momentFeed.momentOwnerInfo.authId!);
                  // }
                },
                child: SvgPicture.asset(
                  'assets/svgs/message.svg',
                  color: Colors.white,
                  width: 24.44,
                  height: 22,
                ),
              ),
            ),
          ]),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 20,
        right: 20,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FittedBox(
            child: CustomText(
              text: '@${momentFeed.momentOwnerInfo.username}',
              color: Colors.white,
              weight: FontWeight.w600,
              size: 16.28,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: getScreenWidth(300),
            child: CustomText(
              text: momentFeed.caption != 'No Caption'
                  ? momentFeed.caption
                  : 'No Caption',
              color: Colors.white,
              isItalic: FontStyle.italic,
              weight: FontWeight.w600,
              // overflow: TextOverflow.ellipsis,
              size: 14,
            ),
          ),
          const SizedBox(height: 3),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(children: [
                  SvgPicture.asset('assets/svgs/music.svg'),
                  const SizedBox(width: 10),
                  momentFeed.soundUrl != 'Original Audio'
                      ? SizedBox(
                          height: 30,
                          width: 200,
                          child: Column(
                            children: [
                              Expanded(
                                // height: 20,
                                // width: 130,
                                child: Marquee(
                                  text: momentFeed.musicName.toString(),
                                  style: const TextStyle(
                                    fontSize: 12.44,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  pauseAfterRound: const Duration(seconds: 2),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const CustomText(
                          text: 'Original Audio',
                          color: Colors.white,
                          weight: FontWeight.w600,
                          size: 15.28,
                        )
                ]),
                const AudioImageLoader()
              ]),
          const SizedBox(height: 20)
        ]),
      ),
      Positioned(
        top: 2,
        right: 0,
        left: 0,
        child: Align(
          alignment: Alignment.center,
          child: Visibility(
            visible: momentFeedStore.postingUserComment,
            child: const CustomText(
              text: 'Posting Comment...',
              color: Colors.green,
              size: 18,
              weight: FontWeight.w600,
            ),
          ),
        ),
      )
    ]);
  }
}

class MomentBox2 extends StatelessWidget {
  final MomentModel momentFeed;
  final PageController pageController;
  const MomentBox2(
      {Key? key, required this.momentFeed, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pt.PostFeedModel _postModel = pt.PostFeedModel(
        feedOwnerId: momentFeed.feedOwnerInfo.authId,
        firstName: momentFeed.feedOwnerInfo.firstName,
        lastName: momentFeed.feedOwnerInfo.lastName,
        location: momentFeed.feedOwnerInfo.location,
        username: "isStreak",
        profilePicture: momentFeed.feedOwnerInfo.profilePicture,
        post: pt.PostModel(
            content:
                momentFeed.caption != 'No Caption' ? momentFeed.caption : "",
            authId: momentFeed.momentOwnerInfo.authId,
            audioMediaItem: momentFeed.soundUrl,
            videoMediaItem: momentFeed.videoUrl,
            postId: momentFeed.momentId,
            postOwnerProfile: pt.PostProfileModel(
              firstName: momentFeed.momentOwnerInfo.firstName,
              lastName: momentFeed.momentOwnerInfo.lastName,
              authId: momentFeed.momentOwnerInfo.authId,
              location: momentFeed.momentOwnerInfo.location,
              profilePicture: momentFeed.momentOwnerInfo.profilePicture,
              profileSlug: momentFeed.momentOwnerInfo.profileSlug,
            )));
    return Stack(children: [
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          color: Colors.black,
          height: 58,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0.0, 0.2),
                          blurRadius: 20,
                          color: AppColors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset('assets/svgs/back.svg',
                        color: Colors.white),
                  ),
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    pageController.jumpToPage(0);
                    RouteNavigators.pop(context);
                  },
                ),
                SizedBox(width: getScreenWidth(24)),
                Text(
                  'Moments',
                  style: TextStyle(
                      fontSize: getScreenHeight(18),
                      fontWeight: FontWeight.w600,
                      color: AppColors.white),
                ),
              ],
            ),
            Row(children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0.0, 0.2),
                      blurRadius: 20,
                      color: AppColors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/svgs/fluent_live-24-regular.svg',
                  ),
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(),
                  onPressed: () async {
                    // var cameras = await availableCameras();
                    Get.to(
                      () => const UserPosting(
                        initialIndex: 2,
                        // phoneCameras: cameras,
                      ),
                      transition: Transition.fadeIn,
                    );
                    momentFeedStore.currentVideoController.pause();
                  },
                ),
              ),
              SizedBox(width: getScreenWidth(40)),
              IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0.0, 0.2),
                        blurRadius: 20,
                        color: AppColors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    'assets/svgs/Camera.svg',
                  ),
                ),
                padding: const EdgeInsets.all(0),
                constraints: const BoxConstraints(),
                onPressed: () {
                  // var cameras = await availableCameras();
                  Get.to(
                    () => const UserPosting(
                      initialIndex: 0,
                      // phoneCameras: cameras,
                    ),
                    transition: Transition.fadeIn,
                  );
                  momentFeedStore.currentVideoController.pause();
                },
              ),
            ]),
          ]),
        ),
      ),
      Positioned(
        top: 60,
        child: VideoPlayerItem(
          videoUrl: momentFeed.videoUrl,
        ),
      ),
      Positioned(
        top: getScreenHeight(300),
        right: 20,
        child: Align(
          alignment: Alignment.centerRight,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Stack(children: [
              InkWell(
                onTap: () {
                  momentFeedStore.reachUser(
                    toReachId: momentFeed.momentOwnerInfo.authId!,
                    id: momentFeed.id,
                  );
                },
                child: SizedBox(
                  height: 70,
                  child: Column(children: [
                    Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(30),
                          image: momentFeed
                                  .momentOwnerInfo.profilePicture!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(momentFeed
                                      .momentOwnerInfo.profilePicture!),
                                  fit: BoxFit.cover,
                                )
                              : null),
                      child: momentFeed.momentOwnerInfo.profilePicture!.isEmpty
                          ? Image.asset("assets/images/app-logo.png")
                          : null,
                    ),
                  ]),
                ),
              ),
              Positioned(
                  bottom: 10,
                  right: 14,
                  child: Container(
                    height: 20,
                    width: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: momentFeed.reachingUser
                          ? Colors.green
                          : AppColors.primaryColor,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.4,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                        child: Icon(
                      momentFeed.reachingUser ? Icons.check : Icons.add,
                      size: 13,
                      color: Colors.white,
                    )),
                  ))
            ]),
            const SizedBox(height: 10),
            ///////////////////
            LikeButton(
              size: 30,
              countBuilder: (count, isLiked, text) {
                return CustomText(
                  text: count.toString(),
                  weight: FontWeight.w500,
                  color: Colors.white,
                  size: 13.28,
                );
              },
              likeCountPadding: const EdgeInsets.all(0),
              isLiked: momentFeed.isLiked,
              countPostion: CountPostion.bottom,
              onTap: (isLiked) async {
                momentFeedStore.likingMoment(
                    momentId: momentFeed.momentId, id: momentFeed.id);
                return !isLiked;
              },
              circleColor: CircleColor(
                  start: AppColors.primaryColor,
                  end: AppColors.primaryColor.withOpacity(0.5)),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Colors.red,
                dotSecondaryColor: Colors.red.withOpacity(0.6),
              ),
              likeBuilder: (bool isLiked) {
                return Icon(
                  size: 30,
                  isLiked ? Icons.favorite : Icons.favorite_outline_outlined,
                  color: isLiked ? Colors.red : Colors.white,
                );
              },
              likeCount: momentFeed.nLikes,
            ),
            const SizedBox(height: 15),
            MomentFeedComment(momentFeed: momentFeed),
            const SizedBox(height: 15),
            Visibility(
              visible: momentFeed.momentOwnerInfo.authId != globals.userId,
              child: InkWell(
                onTap: () {
                  momentFeedStore.videoCtrl(false);
                  // if (momentFeed.momentOwnerInfo.authId != globals.userId) {
                  HapticFeedback.mediumImpact();

                  timeLineFeedStore.messageUser(context,
                      isStreak: true,
                      quoteData: jsonEncode(_postModel.toJson()),
                      id: momentFeed.momentOwnerInfo.authId!);
                  // }
                },
                child: SvgPicture.asset(
                  'assets/svgs/message.svg',
                  color: Colors.white,
                  width: 24.44,
                  height: 22,
                ),
              ),
            ),
          ]),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 20,
        right: 20,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FittedBox(
            child: CustomText(
              text: '@${momentFeed.momentOwnerInfo.username}',
              color: Colors.white,
              weight: FontWeight.w600,
              size: 16.28,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: getScreenWidth(300),
            child: CustomText(
              text: momentFeed.caption != 'No Caption'
                  ? momentFeed.caption
                  : 'No Caption',
              color: Colors.white,
              isItalic: FontStyle.italic,
              weight: FontWeight.w600,
              // overflow: TextOverflow.ellipsis,
              size: 14,
            ),
          ),
          const SizedBox(height: 3),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(children: [
                  SvgPicture.asset('assets/svgs/music.svg'),
                  const SizedBox(width: 10),
                  momentFeed.soundUrl != 'Original Audio'
                      ? SizedBox(
                          height: 30,
                          width: 200,
                          child: Column(
                            children: [
                              Expanded(
                                // height: 20,
                                // width: 130,
                                child: Marquee(
                                  text: momentFeed.musicName.toString(),
                                  style: const TextStyle(
                                    fontSize: 12.44,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  pauseAfterRound: const Duration(seconds: 2),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const CustomText(
                          text: 'Original Audio',
                          color: Colors.white,
                          weight: FontWeight.w600,
                          size: 15.28,
                        )
                ]),
                const AudioImageLoader()
              ]),
          const SizedBox(height: 20)
        ]),
      ),
      Positioned(
        top: 2,
        right: 0,
        left: 0,
        child: Align(
          alignment: Alignment.center,
          child: Visibility(
            visible: momentFeedStore.postingUserComment,
            child: const CustomText(
              text: 'Posting Comment...',
              color: Colors.green,
              size: 18,
              weight: FontWeight.w600,
            ),
          ),
        ),
      )
    ]);
  }
}
