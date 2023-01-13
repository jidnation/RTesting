import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  final bool isLocalVideo;
  final bool? showControls, loop;
  final String path;
  final double? aspectRatio;
  const VideoPreview(
      {Key? key,
      required this.isLocalVideo,
      required this.path,
      this.aspectRatio,
      this.showControls,
      this.loop})
      : super(key: key);

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late BetterPlayerController _betterPlayerController;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    initBetterPlayer();
    // initializePlayer();
  }

  void initBetterPlayer() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            placeholder: Center(
              child: CircularProgressIndicator(
                color: AppColors.white,
              ),
            ),
            overlay: Container(
              width: double.infinity,
              color: AppColors.black.withOpacity(0.1),
            ),
            controlsConfiguration: BetterPlayerControlsConfiguration(
                enableQualities: false,
                enableSubtitles: false,
                enableAudioTracks: false,
                showControls: widget.showControls ?? true,
                enableOverflowMenu: false),
            autoPlay: true,
            looping: widget.loop ?? false);

    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        widget.isLocalVideo
            ? BetterPlayerDataSourceType.file
            : BetterPlayerDataSourceType.network,
        widget.path,
        cacheConfiguration: BetterPlayerCacheConfiguration(
          useCache: true,
          // preCacheSize: 10 * 1024 * 1024,
          // maxCacheSize: 10 * 1024 * 1024,
          // maxCacheFileSize: 10 * 1024 * 1024,

          ///Android only option to use cached video between app sessions
          key: widget.path,
        ));

    _betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: betterPlayerDataSource,
    );

    _betterPlayerController.addEventsListener((BetterPlayerEvent event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
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
      key: Key(widget.path),
      child: Container(
        color: AppColors.black,
        child: BetterPlayer(
          controller: _betterPlayerController,
        ),
      ),
    );
  }
}
