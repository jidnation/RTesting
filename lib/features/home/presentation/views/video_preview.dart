import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';

class VideoPreview extends StatelessWidget {
  final bool isLocalVideo;
  final String path;
  final double? aspectRatio;
  const VideoPreview(
      {Key? key,
      required this.isLocalVideo,
      required this.path,
      this.aspectRatio})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppColors.black,
        child: BetterPlayer(
          controller: BetterPlayerController(
            BetterPlayerConfiguration(
                overlay: Container(
                  width: double.infinity,
                  color: AppColors.black.withOpacity(0.1),
                ),
                controlsConfiguration: BetterPlayerControlsConfiguration(
                    enableQualities: false,
                    enableSubtitles: false,
                    enableAudioTracks: false,
                    enableOverflowMenu: false),
                autoPlay: true,
                aspectRatio: aspectRatio ?? 0.8),
            betterPlayerDataSource: isLocalVideo
                ? BetterPlayerDataSource.file(path)
                : BetterPlayerDataSource.network(path),
          ),
        ),
      ),
    );
  }
}
