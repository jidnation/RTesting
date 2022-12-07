import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../core/services/moment/querys.dart';
import '../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../core/utils/dimensions.dart';

class VideoPreviewer extends StatefulWidget {
  final VideoPlayerController videoController;
  final String video;
  const VideoPreviewer(
      {Key? key, required this.video, required this.videoController})
      : super(key: key);

  @override
  State<VideoPreviewer> createState() => _VideoPreviewerState();
}

class _VideoPreviewerState extends State<VideoPreviewer> {
  @override
  void dispose() {
    widget.videoController.dispose();
    super.dispose();
  }

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    widget.videoController.addListener(() {
      // print('......... ${widget.videoController.setPlaybackSpeed(2)}');
      print('......... ${widget.videoController.value.playbackSpeed}');
      if (widget.videoController.value.isPlaying) {
        setState(() {
          isPlaying = true;
        });
      } else {
        setState(() {
          isPlaying = false;
        });
      }
    });
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: AspectRatio(
          aspectRatio: widget.videoController.value.aspectRatio,
          child: Stack(children: [
            VideoPlayer(widget.videoController),
            Positioned(
                top: size.height * 0.42,
                right: size.width * 0.42,
                child: InkWell(
                  onTap: () async {
                    isPlaying
                        ? widget.videoController.pause()
                        : widget.videoController.play();
                  },
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                )),
            Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          RouteNavigators.pop(context);
                        },
                        icon: Transform.scale(
                          scale: 1.8,
                          child: SvgPicture.asset(
                            'assets/svgs/dc-cancel.svg',
                            height: getScreenHeight(71),
                          ),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      IconButton(
                        onPressed: () async {
                          var res = await MomentQuery.postMoment();
                          // globals.socialServiceBloc!
                          //     .add(MediaUploadEvent(media: File(path)));
                        },
                        icon: Transform.scale(
                          scale: 1.8,
                          child: SvgPicture.asset(
                            'assets/svgs/dc-send.svg',
                            height: getScreenHeight(71),
                          ),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ]))
          ]),
        ),
      ),
    );
  }
}
