import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';

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

  @override
  void initState() {
    super.initState();

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
        widget.path);

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
      child: Container(
        color: AppColors.black,
        child: BetterPlayer(
          controller: _betterPlayerController,
        ),
        // child: BetterPlayer(
        //   controller: BetterPlayerController(
        //     BetterPlayerConfiguration(
        //         autoDispose: true,
        //         overlay: Container(
        //           width: double.infinity,
        //           color: AppColors.black.withOpacity(0.1),
        //         ),
        //         controlsConfiguration: const BetterPlayerControlsConfiguration(
        //             enableQualities: false,
        //             enableSubtitles: false,
        //             enableAudioTracks: false,
        //             enableOverflowMenu: false),
        //         autoPlay: true,
        //         aspectRatio: widget.aspectRatio ?? 0.8),
        //     betterPlayerDataSource: widget.isLocalVideo
        //         ? BetterPlayerDataSource.file(widget.path)
        //         : BetterPlayerDataSource.network(widget.path),
        //   ),
        // ),
      ),
    );
  }
}
