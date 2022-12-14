import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:video_player/video_player.dart';

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
  bool isPlaying = false;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        _videoPlayerController.play();
        _videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isPlaying) {
        setState(() {
          isPlaying = true;
        });
      } else {
        setState(() {
          isPlaying = false;
        });
      }
    });
    // _videoPlayerController.addListener(() {
    // if (_videoPlayerController.value.isInitialized) {
    //   setState(() {
    //     isInitialized = true;
    //   });
    //   print(
    //       ';;;;;;;from init::::: ${_videoPlayerController.value.isInitialized}');
    // // }
    // if (_videoPlayerController.value.isPlaying) {
    //   setState(() {
    //     isPlaying = true;
    //   });
    // } else {
    //   setState(() {
    //     isPlaying = false;
    //   });
    // }
    // Center(
    //   child: InkWell(
    //     onTap: () async {
    //       isPlaying
    //           ? _videoPlayerController.pause()
    //           : _videoPlayerController.play();
    //     },
    //     child: Icon(
    //       isPlaying ? Icons.pause : Icons.play_arrow_rounded,
    //       color: Colors.white,
    //       size: 50,
    //     ),
    //   ),
    // )
    // });
    return Stack(children: [
      Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          color: AppColors.audioPlayerBg,
        ),
        child:
            // isInitialized
            //     ?
            AspectRatio(
          aspectRatio: _videoPlayerController.value.aspectRatio,
          child: VideoPlayer(_videoPlayerController),
        ),
        // : const VideoLoader(),
      ),
      Center(
        child: InkWell(
          onTap: () async {
            isPlaying
                ? _videoPlayerController.pause()
                : _videoPlayerController.play();
          },
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow_rounded,
            color: Colors.transparent,
            size: 50,
          ),
        ),
      )
    ]);
  }
}
