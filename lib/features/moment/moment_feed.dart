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

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/dimensions.dart';
import '../../core/utils/app_globals.dart';
import '../home/presentation/widgets/video_loader.dart';
import '../timeline/loading_widget.dart';
import '../timeline/timeline_feed.dart';
import 'momentControlRoom/control_room.dart';
import 'moment_appbar.dart';
import 'moment_box.dart';
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
                                viewportFraction: 1,
                                // (SizeConfig.screenHeight > 782)
                                //     ? 1
                                //     : (SizeConfig.screenWidth > 360)
                                //         ? 1.3
                                //         : 1.25,
                                // aspectRatio: 9 / rightValue,
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
                                        return MomentBox(
                                            momentFeed: momentFeed);

                                        ////////////
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
