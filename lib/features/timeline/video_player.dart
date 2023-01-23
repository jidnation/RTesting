import 'package:better_player/better_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/features/home/presentation/widgets/post_media.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../home/data/models/post_model.dart';
import '../moment/moment_feed.dart';
import 'loading_widget.dart';

class TimeLineVideoPlayer extends StatefulWidget {
  final PostModel post;
  final String videoUrl;
  const TimeLineVideoPlayer({
    Key? key,
    required this.post,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _TimeLineVideoPlayerState createState() => _TimeLineVideoPlayerState();
}

class _TimeLineVideoPlayerState extends State<TimeLineVideoPlayer> {
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
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      allowFullScreen: true,
      looping: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
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
        color: const Color(0xff001824),
      ),
      // autoInitialize: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _videoPlayerController.dispose();
    _chewieController?.dispose();
  }

  Future<void> toggleVideo() async {
    await _videoPlayerController.pause();
    await initializePlayer();
  }

  bool show = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (widget.post.postRating == "Sensitive" ||
        widget.post.postRating == "Graphic Violence" ||
        widget.post.postRating == "Nudity") {
      if (show) {
        return Container(
          width: size.width,
          height: size.height,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: AppColors.audioPlayerBg,
              borderRadius: BorderRadius.circular(20)),
          child: _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? VisibilityDetector(
                  key: Key('my-widget-key'),
                  onVisibilityChanged: (visibilityInfo) {
                    var visiblePercentage =
                        visibilityInfo.visibleFraction * 100;
                    visiblePercentage > 60
                        ? _chewieController!.videoPlayerController.play()
                        : _chewieController!.videoPlayerController.pause();
                  },
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Chewie(
                        controller: _chewieController!,
                      )),
                )
              : Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loadingEffect2(),
                      ]),
                ),
        );
      } else {
        return ImageBlur(
            widget.post,
            SizedBox(
              height: size.height,
              width: size.width,
            ), () {
          setState(() {
            show = true;
          });
        });
      }
    } else {
      return
          // Stack(children: [
          Container(
        width: size.width,
        height: size.height,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: AppColors.audioPlayerBg,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(0.05, 0.02),
                blurRadius: 0.4,
                spreadRadius: 1,
              )
            ],
            borderRadius: BorderRadius.circular(20)),
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? VisibilityDetector(
                key: Key('my-widget-key'),
                onVisibilityChanged: (visibilityInfo) {
                  var visiblePercentage = visibilityInfo.visibleFraction * 100;
                  visiblePercentage > 60
                      ? _chewieController!.videoPlayerController.play()
                      : _chewieController!.videoPlayerController.pause();
                },
                child: AspectRatio(
                    aspectRatio: 1,
                    child: Chewie(
                      controller: _chewieController!,
                    )),
              )
            : Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loadingEffect2(),
                      // const SizedBox(height: 20),
                      // Text('Loading'),
                    ]),
              ),
      );
    }
  }
}

///
/// for fullPost
///
class TimeLineVideoPlayer2 extends StatefulWidget {
  final String videoUrl;
  const TimeLineVideoPlayer2({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _TimeLineVideoPlayer2State createState() => _TimeLineVideoPlayer2State();
}

class _TimeLineVideoPlayer2State extends State<TimeLineVideoPlayer2> {
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
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      allowFullScreen: true,
      looping: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
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
    // _videoPlayerController.dispose();
    _chewieController?.dispose();
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
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: AppColors.audioPlayerBg,
          borderRadius: BorderRadius.circular(15)),
      child: _chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized
          ? VisibilityDetector(
              key: Key('my-widget-key'),
              onVisibilityChanged: (visibilityInfo) {
                var visiblePercentage = visibilityInfo.visibleFraction * 100;
                visiblePercentage > 60
                    ? _chewieController!.videoPlayerController.play()
                    : _chewieController!.videoPlayerController.pause();
              },
              child: AspectRatio(
                  aspectRatio: 1,
                  child: Chewie(
                    controller: _chewieController!,
                  )),
            )
          : Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loadingEffect2(),
                    // const SizedBox(height: 20),
                    // Text('Loading'),
                  ]),
            ),
    );
  }
}

class TimeLineVideoPreview extends StatefulWidget {
  final String path;
  const TimeLineVideoPreview({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  State<TimeLineVideoPreview> createState() => _TimeLineVideoPreviewState();
}

class _TimeLineVideoPreviewState extends State<TimeLineVideoPreview> {
  late BetterPlayerController _betterPlayerController;

  @override
  initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    BetterPlayerDataSource betterPlayerDataSource = await momentFeedStore
        .videoControllerService
        .getControllerForTimeLineVideo(widget.path);

    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            placeholder: const Center(
              child: LoadingEffect(
                  // color: AppColors.white,
                  ),
            ),
            overlay: Container(
              width: double.infinity,
              color: AppColors.black.withOpacity(0.1),
            ),
            controlsConfiguration: const BetterPlayerControlsConfiguration(
                enableQualities: false,
                enableSubtitles: false,
                enableAudioTracks: false,
                showControls: true,
                enableOverflowMenu: false),
            autoPlay: false,
            looping: false);

    _betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: betterPlayerDataSource,
    );

    _betterPlayerController.addEventsListener((BetterPlayerEvent event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        print('::::::::::>>>>>>>>>>>>>>>>> it is initilized');
        _betterPlayerController.setOverriddenAspectRatio(
            _betterPlayerController.videoPlayerController?.value.aspectRatio ??
                1);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _betterPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppColors.black,
        child: _betterPlayerController.videoPlayerController!.value.initialized
            ? BetterPlayer(
                controller: _betterPlayerController,
              )
            : Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loadingEffect2(),
                    ]),
              ),
      ),
    );
  }
}
