import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../momentControlRoom/control_room.dart';
import '../widgets/moment_appbar.dart';
import '../widgets/moment_videoplayer_item.dart';
import '../widgets/video_loader.dart';

class MomentFeed extends StatefulWidget {
  final PageController pageController;
  const MomentFeed({Key? key, required this.pageController}) : super(key: key);

  @override
  State<MomentFeed> createState() => _MomentFeedState();
}

final MomentFeedStore momentFeedStore = MomentFeedStore();
CarouselController carouselController = CarouselController();
// const colors = [Colors.green, Colors.blue, Colors.red, Colors.yellow];

class _MomentFeedState extends State<MomentFeed> {
//   @override
//   void initState() {
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff001824),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(children: [
            MomentsAppBar(
              pageController: widget.pageController,
            ),
            SizedBox(
              child: ValueListenableBuilder(
                valueListenable: MomentFeedStore(),
                builder: (context, List<MomentModel> value, child) {
                  print('from the feed room.........??? $value }');
                  final List<MomentModel> momentFeeds = value;
                  return momentFeedStore.gettingMoments
                      ? const VideoLoader()
                      : CarouselSlider(
                          options: CarouselOptions(
                            viewportFraction: 1,
                            aspectRatio: 9 / 16,
                            onPageChanged: (index, _) {
                              checkMeOut(index);
                            },
                            enableInfiniteScroll: false,
                            scrollDirection: Axis.vertical,
                          ),
                          items: List<Widget>.generate(
                              momentFeedStore.momentCount,
                              (index) => Builder(builder: (context) {
                                    final MomentModel momentFeed = value[index];
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
                                                      momentFeedStore.reachUser(
                                                        toReachId: momentFeed
                                                            .momentOwnerId,
                                                        id: momentFeed.id,
                                                      );
                                                    },
                                                    child: SizedBox(
                                                      height: 70,
                                                      child: CircleAvatar(
                                                        radius: 25.5,
                                                        backgroundColor:
                                                            AppColors
                                                                .primaryColor,
                                                        backgroundImage: (momentFeed
                                                                        .profilePicture !=
                                                                    null ||
                                                                momentFeed
                                                                        .profilePicture !=
                                                                    '')
                                                            ? NetworkImage(
                                                                    momentFeed
                                                                        .profilePicture!)
                                                                as ImageProvider
                                                            : const AssetImage(
                                                                "assets/images/app-logo.png"),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      bottom: 2,
                                                      right: 14,
                                                      child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: momentFeed
                                                                  .reachingUser
                                                              ? Colors.green
                                                              : AppColors
                                                                  .primaryColor,
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 1.2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        child: Center(
                                                            child: Icon(
                                                          momentFeed
                                                                  .reachingUser
                                                              ? Icons.check
                                                              : Icons.add,
                                                          size: 13,
                                                          color: Colors.white,
                                                        )),
                                                      ))
                                                ]),
                                                const SizedBox(height: 20),
                                                MomentTabs(
                                                  icon: momentFeed.isLiked
                                                      ? Icons.favorite
                                                      : Icons
                                                          .favorite_outline_outlined,
                                                  color: momentFeed.isLiked
                                                      ? Colors.red
                                                      : null,
                                                  value: momentFeedStore
                                                      .getCountValue(
                                                          value: momentFeed
                                                                  .nLikes ??
                                                              0),
                                                  onClick: () {
                                                    momentFeedStore
                                                        .likingMoment(
                                                            momentId: momentFeed
                                                                .momentId,
                                                            id: momentFeed.id);
                                                  },
                                                ),
                                                const SizedBox(height: 20),
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                          'assets/svgs/comment.svg',
                                                          color: Colors.white),
                                                      const SizedBox(height: 5),
                                                      CustomText(
                                                        text: momentFeedStore
                                                            .getCountValue(
                                                                value: momentFeed
                                                                    .nComment),
                                                        weight: FontWeight.w500,
                                                        color: Colors.white,
                                                        size: 13.28,
                                                      )
                                                    ]),
                                                const SizedBox(height: 20),
                                                SvgPicture.asset(
                                                  'assets/svgs/message.svg',
                                                  color: Colors.white,
                                                  width: 24.44,
                                                  height: 22,
                                                ),
                                              ]),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: getScreenHeight(30),
                                        left: 20,
                                        right: 20,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FittedBox(
                                                child: CustomText(
                                                  text:
                                                      '@${momentFeed.momentOwnerUserName}',
                                                  color: Colors.white,
                                                  weight: FontWeight.w600,
                                                  size: 16.28,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              SizedBox(
                                                width: getScreenWidth(300),
                                                child: CustomText(
                                                  text: momentFeed.caption !=
                                                          'No Caption'
                                                      ? momentFeed.caption
                                                      : '',
                                                  color: Colors.white,
                                                  weight: FontWeight.w600,
                                                  // overflow: TextOverflow.ellipsis,
                                                  size: 16.28,
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Row(children: [
                                                      SvgPicture.asset(
                                                          'assets/svgs/music.svg'),
                                                      const SizedBox(width: 10),
                                                      const CustomText(
                                                        text: 'Original Audio',
                                                        color: Colors.white,
                                                        weight: FontWeight.w600,
                                                        size: 15.28,
                                                      )
                                                    ]),
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: Colors.red,
                                                      ),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: 10,
                                                              width: 10,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                            )
                                                          ]),
                                                    )
                                                  ])
                                            ]),
                                      ),
                                    ])

                                        ////////////
                                        ;
                                  })));
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
