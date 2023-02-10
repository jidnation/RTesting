import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:reach_me/features/moment/moment_videoplayer_item.dart';
import 'package:reach_me/features/moment/user_posting.dart';
import 'package:reach_me/features/home/data/models/post_model.dart' as pt;
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/dimensions.dart';
import '../../core/utils/app_globals.dart';
import '../home/presentation/widgets/video_loader.dart';
import '../timeline/loading_widget.dart';
import '../timeline/timeline_feed.dart';
import 'momentControlRoom/control_room.dart';
import 'moment_appbar.dart';
import 'moment_feed_comment.dart';

class MomentFeed extends StatefulWidget {
  final PageController pageController;
  const MomentFeed({Key? key, required this.pageController}) : super(key: key);

  @override
  State<MomentFeed> createState() => _MomentFeedState();
}

final MomentFeedStore momentFeedStore = MomentFeedStore();

CarouselController carouselController = CarouselController();

class _MomentFeedState extends State<MomentFeed> {
  double rightValue = (SizeConfig.screenHeight > 782) ? 16 : 14.435;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff001824),
        body: SizedBox(
          // height: size.height ,
          width: size.width,
          child: Column(children: [
            MomentsAppBar(
              pageController: widget.pageController,
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: MomentFeedStore(),
                builder: (context, List<MomentModel> value, child) {
                  final List<MomentModel> momentFeeds = value;
                  return momentFeedStore.gettingMoments
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              loadingEffect2(),
                            ])
                      : momentFeeds.isNotEmpty
                          ? CarouselSlider(
                              options: CarouselOptions(
                                // height: SizeConfig.screenHeight - 151.5,
                                viewportFraction:
                                    (SizeConfig.screenHeight > 782) ? 1 : 1.25,
                                aspectRatio: 9 / rightValue,
                                onPageChanged: (index, _) {
                                  checkMeOut(index);
                                },
                                enableInfiniteScroll: false,
                                scrollDirection: Axis.vertical,
                              ),
                              items: List<Widget>.generate(
                                  momentFeedStore.momentCount,
                                  (index) => Builder(builder: (context) {
                                        final MomentModel momentFeed =
                                            value[index];
                                        final pt.PostFeedModel _postModel =
                                            pt.PostFeedModel(
                                                feedOwnerId: momentFeed
                                                    .feedOwnerInfo.authId,
                                                firstName: momentFeed
                                                    .feedOwnerInfo.firstName,
                                                lastName: momentFeed
                                                    .feedOwnerInfo.lastName,
                                                location: momentFeed
                                                    .feedOwnerInfo.location,
                                                profilePicture: momentFeed
                                                    .feedOwnerInfo
                                                    .profilePicture,
                                                post: pt.PostModel(
                                                    content:
                                                        momentFeed.caption !=
                                                                'No Caption'
                                                            ? momentFeed.caption
                                                            : "",
                                                    authId: momentFeed
                                                        .momentOwnerInfo.authId,
                                                    audioMediaItem:
                                                        momentFeed.soundUrl,
                                                    videoMediaItem:
                                                        momentFeed.videoUrl,
                                                    postOwnerProfile:
                                                        pt.PostProfileModel(
                                                      firstName: momentFeed
                                                          .momentOwnerInfo
                                                          .firstName,
                                                      lastName: momentFeed
                                                          .momentOwnerInfo
                                                          .lastName,
                                                      authId: momentFeed
                                                          .momentOwnerInfo
                                                          .authId,
                                                      location: momentFeed
                                                          .momentOwnerInfo
                                                          .location,
                                                      profilePicture: momentFeed
                                                          .momentOwnerInfo
                                                          .profilePicture,
                                                      profileSlug: momentFeed
                                                          .momentOwnerInfo
                                                          .profileSlug,
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
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Stack(children: [
                                                      InkWell(
                                                        onTap: () {
                                                          momentFeedStore
                                                              .reachUser(
                                                            toReachId: momentFeed
                                                                .momentOwnerInfo
                                                                .authId!,
                                                            id: momentFeed.id,
                                                          );
                                                        },
                                                        child: SizedBox(
                                                          height: 70,
                                                          child: Column(
                                                              children: [
                                                                Container(
                                                                  height: 50,
                                                                  width: 50,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(12),
                                                                  decoration: BoxDecoration(
                                                                      color: AppColors.primaryColor,
                                                                      borderRadius: BorderRadius.circular(30),
                                                                      image: momentFeed.momentOwnerInfo.profilePicture!.isNotEmpty
                                                                          ? DecorationImage(
                                                                              image: NetworkImage(momentFeed.momentOwnerInfo.profilePicture!),
                                                                              fit: BoxFit.cover,
                                                                            )
                                                                          : null),
                                                                  child: momentFeed
                                                                          .momentOwnerInfo
                                                                          .profilePicture!
                                                                          .isEmpty
                                                                      ? Image.asset(
                                                                          "assets/images/app-logo.png")
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
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: momentFeed
                                                                      .reachingUser
                                                                  ? Colors.green
                                                                  : AppColors
                                                                      .primaryColor,
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width: 1.4,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                            ),
                                                            child: Center(
                                                                child: Icon(
                                                              momentFeed
                                                                      .reachingUser
                                                                  ? Icons.check
                                                                  : Icons.add,
                                                              size: 13,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                          ))
                                                    ]),
                                                    const SizedBox(height: 10),
                                                    ///////////////////
                                                    LikeButton(
                                                      size: 30,
                                                      countBuilder: (count,
                                                          isLiked, text) {
                                                        return CustomText(
                                                          text:
                                                              count.toString(),
                                                          weight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                          size: 13.28,
                                                        );
                                                      },
                                                      likeCountPadding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      isLiked:
                                                          momentFeed.isLiked,
                                                      countPostion:
                                                          CountPostion.bottom,
                                                      onTap: (isLiked) async {
                                                        momentFeedStore
                                                            .likingMoment(
                                                                momentId:
                                                                    momentFeed
                                                                        .momentId,
                                                                id: momentFeed
                                                                    .id);
                                                        return !isLiked;
                                                      },
                                                      circleColor: CircleColor(
                                                          start: AppColors
                                                              .primaryColor,
                                                          end: AppColors
                                                              .primaryColor
                                                              .withOpacity(
                                                                  0.5)),
                                                      bubblesColor:
                                                          BubblesColor(
                                                        dotPrimaryColor:
                                                            Colors.red,
                                                        dotSecondaryColor:
                                                            Colors.red
                                                                .withOpacity(
                                                                    0.6),
                                                      ),
                                                      likeBuilder:
                                                          (bool isLiked) {
                                                        return Icon(
                                                          size: 30,
                                                          isLiked
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_outline_outlined,
                                                          color: isLiked
                                                              ? Colors.red
                                                              : Colors.white,
                                                        );
                                                      },
                                                      likeCount:
                                                          momentFeed.nLikes,
                                                    ),
                                                    const SizedBox(height: 15),
                                                    MomentFeedComment(
                                                        momentFeed: momentFeed),
                                                    const SizedBox(height: 15),
                                                    InkWell(
                                                      onTap: () {
                                                        if (momentFeed
                                                                .momentOwnerInfo
                                                                .authId !=
                                                            globals.userId) {
                                                          HapticFeedback
                                                              .mediumImpact();

                                                          timeLineFeedStore.messageUser(
                                                              context,
                                                              quoteData: jsonEncode(
                                                                  _postModel
                                                                      .toJson()),
                                                              id: momentFeed
                                                                  .momentOwnerInfo
                                                                  .authId!);
                                                        }
                                                      },
                                                      child: SvgPicture.asset(
                                                        'assets/svgs/message.svg',
                                                        color: Colors.white,
                                                        width: 24.44,
                                                        height: 22,
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: getScreenHeight(
                                                momentFeed.caption !=
                                                        'No Caption'
                                                    ? 30
                                                    : (SizeConfig.screenHeight >
                                                            782)
                                                        ? 30
                                                        : 100),
                                            left: 20,
                                            right: 20,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  FittedBox(
                                                    child: CustomText(
                                                      text:
                                                          '@${momentFeed.momentOwnerInfo.username}',
                                                      color: Colors.white,
                                                      weight: FontWeight.w600,
                                                      size: 16.28,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  SizedBox(
                                                    width: getScreenWidth(300),
                                                    child: CustomText(
                                                      text: momentFeed
                                                                  .caption !=
                                                              'No Caption'
                                                          ? momentFeed.caption
                                                          : 'No Caption',
                                                      color: Colors.white,
                                                      isItalic:
                                                          FontStyle.italic,
                                                      weight: FontWeight.w600,
                                                      // overflow: TextOverflow.ellipsis,
                                                      size: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Row(children: [
                                                          SvgPicture.asset(
                                                              'assets/svgs/music.svg'),
                                                          const SizedBox(
                                                              width: 10),
                                                          CustomText(
                                                            text: momentFeed
                                                                        .soundUrl ==
                                                                    'Original Audio'
                                                                ? 'Original Audio'
                                                                : '',
                                                            color: Colors.white,
                                                            weight:
                                                                FontWeight.w600,
                                                            size: 15.28,
                                                          )
                                                        ]),
                                                        AudioImageLoader(
                                                          audioUrl: momentFeed
                                                              .soundUrl,
                                                        )
                                                      ])
                                                ]),
                                          ),
                                          Positioned(
                                            top: 2,
                                            right: 0,
                                            left: 0,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Visibility(
                                                visible: momentFeedStore
                                                    .postingUserComment,
                                                child: const CustomText(
                                                  text: 'Posting Comment...',
                                                  color: Colors.green,
                                                  size: 18,
                                                  weight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          )
                                        ])

                                            ////////////
                                            ;
                                      })))
                          : SizedBox(
                              height: SizeConfig.screenHeight - 200,
                              width: SizeConfig.screenWidth,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CustomText(
                                      text: 'No Streak Available yet.....',
                                      color: Colors.white,
                                      weight: FontWeight.w500,
                                    ),
                                    const SizedBox(height: 20),
                                    InkWell(
                                      onTap: () async {
                                        var cameras = await availableCameras();
                                        Get.to(
                                          () => UserPosting(
                                            initialIndex: 1,
                                            phoneCameras: cameras,
                                          ),
                                          transition: Transition.fadeIn,
                                        );
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 120,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.white,
                                          ),
                                          // color: Colors.white,
                                        ),
                                        child: const CustomText(
                                          text: 'Create Streak',
                                          color: AppColors.white,
                                          size: 14,
                                        ),
                                      ),
                                    )
                                  ]),
                            );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void checkMeOut(int index) {
    print('....check Me out is running>>>>>>>>>>>>>>>>');
    int currentSaved = momentFeedStore.currentSaveIndex;
    if (index == (currentSaved - 2)) {
      momentFeedStore.cacheNextFive(currentSaved);
    }
  }
}

class AudioImageLoader extends StatefulWidget {
  final String? audioUrl;
  const AudioImageLoader({
    Key? key,
    required this.audioUrl,
  }) : super(key: key);

  @override
  State<AudioImageLoader> createState() => _AudioImageLoaderState();
}

String? result;

class _AudioImageLoaderState extends State<AudioImageLoader> {
  @override
  void initState() {
    convertUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        // widget.audioUrl != null
        //   ?
        Container(
      height: 50,
      width: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.primaryColor,
          image: const DecorationImage(
            image: AssetImage('assets/images/app-logo.png'),
            fit: BoxFit.contain,
          )),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)))
      ]),
    );
    // : AudioEffects(
    //     height: 50,
    //     width: 50,
    //     color: Colors.black,
    //     artworkWidth: 40,
    //     artworkHeight: 40,
    //     artworkBorder: BorderRadius.circular(30),
    //     isLocal: false,
    //     isPlaying: true,
    //     url: widget.audioUrl,
    //     type: ArtworkType.AUDIO,
    //     id: "Audio ID",
    //   );
  }

  convertUrl() async {
    if (widget.audioUrl != null) {
      // FileResult? file = await MediaService().downloadFile(
      //   url: widget.audioUrl!,
      // );
      // try {
      //   final thumbnailPath = await getTemporaryDirectory();
      //   result = await MediaThumbnail.videoThumbnail(
      //       "widget.audioUrl!", "${thumbnailPath.path}/xx.jpg");
      //   print(":::::::::::::::::::::::::: ${thumbnailPath.path}");
      //
      //   // result = await MetadataRetriever.fromFile(
      //   //   File(file.path),
      //   // );
      //   if (result != null) {
      //     setState(() {});
      //   }
      // } catch (ex) {
      //   debugPrint(ex.toString());
      // }
    }
  }
}
