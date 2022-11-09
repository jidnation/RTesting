import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reach_me/core/models/file_result.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/file_utils.dart';
import 'package:reach_me/features/home/presentation/views/video_preview.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/string_util.dart';

class PostReachMedia extends StatelessWidget {
  final FileResult fileResult;
  final Function() onClose;
  const PostReachMedia(
      {Key? key, required this.onClose, required this.fileResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isVideo = FileUtils.isVideo(fileResult.file);
    String? duration = fileResult.duration == null
        ? null
        : StringUtil.formatDuration(Duration(seconds: fileResult.duration!));
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: getScreenWidth(200),
          height: getScreenHeight(200),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.file(
            (isVideo) ? File(fileResult.thumbnail!) : fileResult.file,
            fit: BoxFit.cover,
          ),
        ),
        (isVideo)
            ? Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.black.withAlpha(50),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              )
            : Container(),
        (isVideo)
            ? Positioned(
                right: getScreenWidth(4),
                bottom: getScreenWidth(5),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Center(
                        child: Text(
                      duration ?? '',
                      style: TextStyle(color: AppColors.grey),
                    )),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: AppColors.white),
                  ),
                ),
              )
            : Container(),
        (isVideo)
            ? Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: AppColors.white,
                    size: 52,
                  ),
                ),
              )
            : Container(),
        Positioned.fill(child: GestureDetector(onTap: () {
          RouteNavigators.route(
              context,
              (isVideo)
                  ? VideoPreview(
                      path: fileResult.file.path,
                      isLocalVideo: true,
                      aspectRatio: fileResult.width! / fileResult.height!,
                    )
                  : PhotoView(
                      imageProvider: FileImage(
                        fileResult.file,
                      ),
                    ));
        })),
        Positioned(
          right: getScreenWidth(4),
          top: getScreenWidth(5),
          child: GestureDetector(
            onTap: onClose,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: getScreenHeight(26),
                width: getScreenWidth(26),
                child: Center(
                  child: Icon(
                    Icons.close,
                    color: AppColors.grey,
                    size: getScreenHeight(14),
                  ),
                ),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.white),
              ),
            ),
          ),
        ),
      ],
    ).paddingOnly(r: 10);
  }
}

class PostReachAudioMedia extends StatefulWidget {
  final String path;
  const PostReachAudioMedia({Key? key, required this.path}) : super(key: key);

  @override
  State<PostReachAudioMedia> createState() => _PostReachAudioMediaState();
}

class _PostReachAudioMediaState extends State<PostReachAudioMedia> {
  late PlayerController playerController;
  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  Future<void> initPlayer() async {
    // String fileName = widget.path;
    // String? dir = (await getDownloadsDirectory()).path;
    // String savePath = '$dir/$fileName';
    print('emi ni:  ---->>>>>   ' + Uri.parse(widget.path).path);
    playerController = PlayerController();
    await playerController.preparePlayer(widget.path);
    await playerController.setVolume(1.0);
    await playerController.startPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      child: AudioFileWaveforms(
        size: Size(MediaQuery.of(context).size.width / 2, 70),
        playerController: playerController,
        density: 1.5,
        playerWaveStyle: const PlayerWaveStyle(
          scaleFactor: 0.8,
          fixedWaveColor: Colors.white30,
          liveWaveColor: Colors.white,
          waveCap: StrokeCap.butt,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
  }
}
