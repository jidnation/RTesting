import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../core/services/moment/querys.dart';
import '../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/dimensions.dart';
import 'moment_actions.dart';
import 'moment_preview_editor.dart';

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
      body: Column(children: [
        ClipRRect(
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
                      ])),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        MomentActions(
                          label: 'Filters',
                          svgUrl: 'assets/svgs/filter-n.svg',
                        ),
                        SizedBox(height: 20),
                        MomentActions(
                          label: 'Voice over',
                          svgUrl: 'assets/svgs/mic.svg',
                        ),
                      ]),
                ),
              ),
            ]),
          ),
        ),
        SizedBox(height: getScreenHeight(10)),
        Padding(
          padding: EdgeInsets.only(
            left: getScreenWidth(25),
            right: getScreenWidth(25),
            top: getScreenHeight(30),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              const MomentPreviewEditor(
                label: 'Sticker',
                icon: Icons.emoji_emotions_outlined,
              ),
              SizedBox(width: getScreenWidth(20)),
              const MomentPreviewEditor(
                label: 'Pen',
                icon: Icons.edit,
              ),
              SizedBox(width: getScreenWidth(20)),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Image.asset(
                  'assets/images/text.png',
                  height: 33,
                  width: 33,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 3),
                const CustomText(
                  text: 'Text',
                  color: Colors.white,
                  weight: FontWeight.w600,
                  size: 9.44,
                )
              ])
            ]),
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            )
          ]),
        )
      ]),
    );
  }
}
