import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:video_player/video_player.dart';

class VideoMomentScreen extends StatefulHookWidget {
  static const String id = 'video_moment_screen';

  const VideoMomentScreen({Key? key}) : super(key: key);

  @override
  State<VideoMomentScreen> createState() => _VideoMomentScreenState();
}

class _VideoMomentScreenState extends State<VideoMomentScreen>
    with AutomaticKeepAliveClientMixin<VideoMomentScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    final videos = [
      'assets/videos/video-1.mp4',
      'assets/videos/video-2.mp4',
      'assets/videos/video-3.mp4',
    ];
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(children: [
          Swiper(
            itemBuilder: (BuildContext context, int index) {
              return ContentScreen(
                src: videos,
              );
            },
            itemCount: videos.length,
            scrollDirection: Axis.vertical,
          ),
          const MomentsAppBar(),
        ]),
      ),
    );
  }
}

class MomentsAppBar extends StatelessWidget {
  const MomentsAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(height: getScreenHeight(45)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            Row(
              children: [
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
                    onPressed: () {
                      //Navigator.pop(context);
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
                    //Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}

class OptionsWidget extends StatelessWidget {
  const OptionsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            ImagePlaceholder(
                              width: getScreenWidth(50),
                              height: getScreenHeight(50),
                            ),
                            Positioned(
                              top: getScreenHeight(37),
                              child: Container(
                                width: getScreenWidth(20),
                                height: getScreenHeight(20),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.white,
                                    size: getScreenHeight(15),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: getScreenHeight(25)),
                        Column(
                          mainAxisSize: MainAxisSize.min,
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
                                child: SvgPicture.asset(
                                  'assets/svgs/like for tv.svg',
                                ),
                              ),
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                //Navigator.pop(context);
                              },
                            ),
                            SizedBox(height: getScreenHeight(5)),
                            Text(
                              '24k',
                              style: TextStyle(
                                  fontSize: getScreenHeight(14),
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(
                                        offset: const Offset(0.0, 0.2),
                                        blurRadius: 20,
                                        color: AppColors.black.withOpacity(0.4)
                                        //color: AppColors.black,
                                        ),
                                  ]),
                            )
                          ],
                        ),
                        SizedBox(height: getScreenHeight(25)),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                                  'assets/svgs/Vector(1).svg',
                                ),
                                padding: const EdgeInsets.all(0),
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  //Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(height: getScreenHeight(5)),
                            Text(
                              '3k',
                              style: TextStyle(
                                fontSize: getScreenHeight(14),
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                      offset: const Offset(0.0, 0.2),
                                      blurRadius: 20,
                                      color: AppColors.black.withOpacity(0.4)
                                      //color: AppColors.black,
                                      ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: getScreenHeight(25)),
                        Column(
                          mainAxisSize: MainAxisSize.min,
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
                                child: SvgPicture.asset(
                                  'assets/svgs/message.svg',
                                  color: AppColors.white,
                                ),
                              ),
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                //Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: getScreenHeight(10)),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '@badguy',
                        style: TextStyle(
                          fontSize: getScreenHeight(17),
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          shadows: [
                            Shadow(
                                offset: const Offset(0.0, 0.2),
                                blurRadius: 20,
                                color: AppColors.black.withOpacity(0.4)
                                //color: AppColors.black,
                                ),
                          ],
                        ),
                      ),
                      SizedBox(height: getScreenHeight(5)),
                      Text(
                        "Girlie wanna play with a big playboy like me...\nOooof!",
                        style: TextStyle(
                          fontSize: getScreenHeight(14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          shadows: [
                            Shadow(
                                offset: const Offset(0.0, 0.2),
                                blurRadius: 20,
                                color: AppColors.black.withOpacity(0.4)
                                //color: AppColors.black,
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
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
                        'assets/svgs/pop-vertical.svg',
                        color: AppColors.white,
                      ),
                    ),
                    padding: const EdgeInsets.all(0),
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      //Navigator.pop(context);
                    },
                  ).paddingOnly(r: getScreenWidth(13)),
                ),
                SizedBox(height: getScreenHeight(23)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                            child: SvgPicture.asset(
                              'assets/svgs/music.svg',
                            ),
                          ),
                          padding: const EdgeInsets.all(0),
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            //Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: getScreenWidth(10)),
                        Text(
                          'Original Sound',
                          style: TextStyle(
                            fontSize: getScreenHeight(16),
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                  offset: const Offset(0.0, 0.2),
                                  blurRadius: 20,
                                  color: AppColors.black.withOpacity(0.4)
                                  //color: AppColors.black,
                                  ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: getScreenHeight(20)),
              ],
            ),
          )
        ]);
  }
}

class ContentScreen extends StatefulHookWidget {
  const ContentScreen({Key? key, required this.src}) : super(key: key);
  final List<String> src;

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadController() async {
    await _videoPlayerController?.initialize().then((value) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        showControls: false,
        looping: true,
      );
      setState(() {});
    });

    // _videoPlayerController?.setLooping(true);
  }

  @override
  void didChangeDependencies() {
    // _videoPlayerController = VideoPlayerController.asset(widget.src[0]);
    // loadController();
    super.didChangeDependencies();
  }

  // Future initializePlayer() async {
  //   // _videoPlayerController =
  //   //     VideoPlayerController.asset('assets/Butterfly-209.mp4');

  //   _videoPlayerController.addListener(() {
  //     setState(() {});
  //   });
  //   _videoPlayerController.initialize().then((_) {
  // _chewieController = ChewieController(
  //   videoPlayerController: _videoPlayerController,
  //   autoPlay: true,
  //   showControls: false,
  //   looping: true,
  // );
  // setState(() {});
  //   });

  //   // await _videoPlayerController.initialize().then((value) {
  //   //   _chewieController = ChewieController(
  //   //     videoPlayerController: _videoPlayerController,
  //   //     autoPlay: true,
  //   //     showControls: false,
  //   //     looping: true,
  //   //   );
  //   // });
  //   // setState(() {});
  // }

  @override
  void dispose() {
    // _videoPlayerController!.dispose();
    // _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: double.infinity,
            height: getScreenHeight(90),
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(0.0, 4),
                end: const Alignment(0.0, -1.2),
                colors: <Color>[
                  AppColors.black.withOpacity(0.5),
                  Colors.black12.withOpacity(0.0)
                ],
              ),
            ),
            // decoration: BoxDecoration(
            //   color: AppColors.grey.withOpacity(0.14),
            // )
          ),
        ),
        _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? GestureDetector(
                onTap: () {
                  if (_chewieController!.isPlaying) {
                    _chewieController!.pause();
                  } else {
                    _chewieController!.play();
                  }
                },
                onDoubleTap: () {
                  setState(() {
                    _liked = !_liked;
                  });
                },
                child: SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoPlayerController!.value.size.width,
                      height: _videoPlayerController!.value.size.height,
                      child: Chewie(
                        controller: _chewieController!,
                      ),
                    ),
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Loading...')
                ],
              ),
        if (_liked)
          Center(
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              child: SvgPicture.asset(
                'assets/svgs/like for tv.svg',
                color: _liked ? Colors.red : AppColors.black,
              ),
              height: getScreenHeight(50),
              width: getScreenWidth(50),
            ),
          ),
        const OptionsWidget(),
      ],
    );
  }
}
