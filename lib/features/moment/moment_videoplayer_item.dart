import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:video_player/video_player.dart';

import '../../core/utils/custom_text.dart';
import '../../core/utils/dimensions.dart';
import '../timeline/loading_widget.dart';
import 'moment_feed.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
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
        .getControllerForVideo(widget.videoUrl);
    await Future.wait([_videoPlayerController.initialize()]);
    _createChewieController();
    setState(() {});
  }

  final deviceRatio = SizeConfig.screenWidth / SizeConfig.screenHeight;
  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      allowFullScreen: true,
      aspectRatio: 9 / 15.5,
      maxScale: 5,
      //     (0.9 * _videoPlayerController.value.aspectRatio) / deviceRatio,
      looping: true,
      // showOptions: false,

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
        color: Colors.white,
      ),
    );
    momentFeedStore.videoCtrl(true, vController: _videoPlayerController);
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    // _chewieController?.dispose();
  }

  Future<void> toggleVideo() async {
    await _videoPlayerController.pause();
    await initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> :::::: ${size.width}");
    return
        // Stack(children: [
        Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: _chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized
          ? Transform.scale(
              scaleY: SizeConfig.screenHeight > 785 ? 1.055 : 1,
              scaleX: SizeConfig.screenWidth > 385 ? 1.065 : 1,
              child: Chewie(
                controller: _chewieController!,
              ),
            )
          : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              loadingEffect2(),
            ]),
    );
  }
}

class VideoPlayerItem2 extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem2({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerItem2State createState() => _VideoPlayerItem2State();
}

class _VideoPlayerItem2State extends State<VideoPlayerItem2> {
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
        .getControllerForVideo(widget.videoUrl);
    await Future.wait([_videoPlayerController.initialize()]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      // aspectRatio: 3.8 / 3.3,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      // aspectRatio: 1,
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      // showOptions: false,
      allowFullScreen: true,
      looping: true,

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
        color: const Color(0xff001824),
      ),
      // autoInitialize: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    // _chewieController?.dispose();
  }

  Future<void> toggleVideo() async {
    await _videoPlayerController.pause();
    await initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: _chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized
          ? AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: Chewie(
                controller: _chewieController!,
              ))
          : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              loadingEffect2(),
            ]),
    );
  }
}

class MomentTabs extends StatelessWidget {
  final String value;
  final IconData icon;
  final Function()? onClick;
  final Color? color;
  const MomentTabs({
    Key? key,
    required this.value,
    required this.icon,
    this.onClick,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      InkWell(
        onTap: onClick,
        child: Icon(
          icon,
          color: color ?? Colors.white,
          size: 30,
        ),
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
