import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reach_me/core/models/file_result.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/home/presentation/widgets/video_preview.dart';

import '../../../../core/helper/logger.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/file_utils.dart';
import '../../../../core/utils/string_util.dart';

class CommentReachMedia extends HookWidget {
  final FileResult fileResult;
  final Function()? onClose;
  final double? size;

  const CommentReachMedia(
      {Key? key, this.onClose, required this.fileResult, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isVideo = FileUtils.isVideo(fileResult.file);
    bool isAudio = FileUtils.isAudio(fileResult.file);

    String? duration = fileResult.duration == null
        ? null
        : StringUtil.formatDuration(Duration(seconds: fileResult.duration!));

    if (isAudio) {
      return CommentReachAudioMedia(
          path: fileResult.file.path, onCancel: onClose!);
    }

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: getScreenWidth(size ?? 200),
          height: getScreenHeight(size ?? 200),
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
              ))
            : Container(),
        (isVideo)
            ? Positioned(
                right: getScreenWidth(4),
                bottom: getScreenWidth(5),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Center(
                      child: (Text(
                        duration ?? '',
                        style: const TextStyle(
                          color: AppColors.grey,
                        ),
                      )),
                    ),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: AppColors.white),
                  ),
                ))
            : Container(),
        (isVideo)
            ? Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(),
                  child: const Icon(
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
        onClose != null
            ? Positioned(
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
              )
            : Container(),
      ],
    ).paddingOnly(r: 10);
  }
}

class CommentReachAudioMedia extends StatefulWidget {
  final String path;
  final EdgeInsets? margin, padding;
  final Function() onCancel;
  const CommentReachAudioMedia(
      {Key? key,
      required this.path,
      required this.onCancel,
      this.margin,
      this.padding})
      : super(key: key);

  @override
  State<CommentReachAudioMedia> createState() => _CommentReachAudioMediaState();
}

class _CommentReachAudioMediaState extends State<CommentReachAudioMedia> {
  late PlayerController playerController;
  bool isInitialised = false;
  bool isPlaying = false;
  final currentDurationStream = StreamController<int>();
  int currentDuration = 0;
  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  Future<void> initPlayer() async {
    // String fileName = widget.path;
    // String? dir = (await getDownloadsDirectory()).path;
    // String savePath = '$dir/$fileName';
    playerController = PlayerController();
    playerController.onCurrentDurationChanged.listen((event) {
      currentDuration = event;
      setState(() {});
      Console.log('<<AUDIO-DURATION>>', event.toString());
    });
    playerController.addListener(() {
      Console.log('<<AUDIO-LISTENER>>', playerController.playerState.name);
      if (playerController.playerState == PlayerState.initialized) {
        isInitialised = true;
        setState(() {});
      } else if (playerController.playerState == PlayerState.playing) {
        isPlaying = true;
        setState(() {});
      } else if (playerController.playerState == PlayerState.paused ||
          playerController.playerState == PlayerState.stopped) {
        isPlaying = false;
        setState(() {});
      }
    });
    await playerController.preparePlayer(widget.path);
    // await playerController.startPlayer();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      height: getScreenHeight(36),
      decoration: const BoxDecoration(
          color: AppColors.audioPlayerBg,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (isPlaying) {
                playerController.pausePlayer();
              } else {
                playerController.startPlayer(finishMode: FinishMode.pause);
              }
            },
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 32,
              color: AppColors.black,
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          isInitialised
              ? AudioFileWaveforms(
                  size: Size(MediaQuery.of(context).size.width / 2, 24),
                  playerController: playerController,
                  density: 2,
                  enableSeekGesture: true,
                  playerWaveStyle: const PlayerWaveStyle(
                    scaleFactor: 0.2,
                    waveThickness: 3,
                    fixedWaveColor: AppColors.greyShade1,
                    liveWaveColor: Colors.black,
                    waveCap: StrokeCap.round,
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: const LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    color: AppColors.greyShade1,
                    backgroundColor: AppColors.greyShade1,
                  ),
                ),
          SizedBox(
            width: getScreenWidth(12),
          ),
          Text(
            StringUtil.formatDuration(Duration(milliseconds: currentDuration)),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const Spacer(
            flex: 1,
          ),
          GestureDetector(
            onTap: widget.onCancel,
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(4),
                alignment: Alignment.center,
                height: getScreenHeight(36),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.white),
                child: Icon(
                  Icons.close_rounded,
                  size: getScreenHeight(16),
                  color: AppColors.audioPlayerClose,
                )),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
  }
}
