import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../momentControlRoom/models/get_moment_feed.dart';
import '../views/moment_feed.dart';

class VideoPlayerItem extends StatefulWidget {
  final GetMomentFeed momentFeed;
  const VideoPlayerItem({
    Key? key,
    required this.momentFeed,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoPlayerController;

  ChewieController? _chewieController;
  int? bufferDelay;
  bool isPlaying = false;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = await momentFeedStore.videoControllerService
        .getControllerForVideo(widget.momentFeed.moment!.videoMediaItem!);
    await Future.wait([_videoPlayerController.initialize()]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      aspectRatio: _videoPlayerController.value.aspectRatio,
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      allowFullScreen: true,
      // fullScreenByDefault: true,
      looping: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      overlay: Stack(children: [
        Positioned(
          top: getScreenHeight(300),
          right: 20,
          child: Align(
            alignment: Alignment.centerRight,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Stack(children: [
                SizedBox(
                  height: 70,
                  child: Column(
                    children: [
                      Container(
                        height: 49.44,
                        width: 49.44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.add,
                        size: 13,
                        color: Colors.white,
                      )),
                    ))
              ]),
              const SizedBox(height: 20),
              const MomentTabs(
                icon: Icons.favorite_outline_outlined,
                value: "24k",
              ),
              const SizedBox(height: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                SvgPicture.asset('assets/svgs/comment.svg',
                    color: Colors.white),
                const SizedBox(height: 5),
                const CustomText(
                  text: '3k',
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const CustomText(
              text: '@jasonstatham',
              color: Colors.white,
              weight: FontWeight.w600,
              size: 16.28,
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: getScreenWidth(300),
              child: const CustomText(
                text:
                    'The normal ride through the street...\ni sure miss my home #moviestudio...\nMore',
                color: Colors.white,
                weight: FontWeight.w600,
                // overflow: TextOverflow.ellipsis,
                size: 16.28,
              ),
            ),
            const SizedBox(height: 15),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(children: [
                    SvgPicture.asset('assets/svgs/music.svg'),
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
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.red,
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          )
                        ]),
                  )
                ])
          ]),
        ),
      ]),
      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            onTap: toggleVideo,
            iconData: Icons.live_tv_sharp,
            title: 'Toggle Video Src',
          ),
        ];
      },

      hideControlsTimer: const Duration(seconds: 1),

      // Try playing around with some of these other options:

      // showControls: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Container(
        color: Colors.grey,
      ),
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  Future<void> toggleVideo() async {
    await _videoPlayerController.pause();
    await initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return
        // Stack(children: [
        Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        color: AppColors.audioPlayerBg,
      ),
      child: _chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized
          ? AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: Chewie(
                controller: _chewieController!,
              ))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading'),
                ]),
    );
  }
}

class MomentTabs extends StatelessWidget {
  final String value;
  final IconData icon;
  const MomentTabs({
    Key? key,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Icon(
        icon,
        color: Colors.white,
        size: 30,
      ),
      const SizedBox(height: 5),
      CustomText(
        text: value,
        weight: FontWeight.w500,
        color: Colors.white,
        size: 13.28,
      )
    ]);
  }
}
