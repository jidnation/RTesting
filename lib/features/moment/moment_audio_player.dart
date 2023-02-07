import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/media_service.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/string_util.dart';
import '../timeline/timeline_feed.dart';
import 'moment_feed.dart';

class MomentAudioPlayer extends StatefulWidget {
  final String audioPath;
  final String? id;
  const MomentAudioPlayer({Key? key, required this.audioPath, this.id})
      : super(key: key);

  @override
  State<MomentAudioPlayer> createState() => _MomentAudioPlayerState();
}

class _MomentAudioPlayerState extends State<MomentAudioPlayer> {
  late PlayerController playerController;
  bool isInitialised = false;
  bool isPlaying = false;
  final currentDurationStream = StreamController<int>();
  int currentDuration = 0;
  final MediaService mediaService = MediaService();

  @override
  void initState() {
    super.initState();
    if (mounted) initPlayer();
  }

  Future<void> initPlayer() async {
    late String filePath;
    playerController = PlayerController();
    File? audioFile = await momentFeedStore.videoControllerService
        .getAudioFile(widget.audioPath);
    if (audioFile == null) {
      var result = await mediaService.downloadFile(url: widget.audioPath);
      filePath = result!.path;
    } else {
      filePath = audioFile.path;
    }
    // if(playerController == null) return;
    playerController.onCurrentDurationChanged.listen((event) {
      currentDuration = event;
      if (mounted) setState(() {});
    });

    playerController.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.initialized) {
        isInitialised = true;
        if (mounted) setState(() {});
      } else if (event == PlayerState.playing) {
        isPlaying = true;
        if (mounted) setState(() {});
      } else if (event == PlayerState.paused) {
        isPlaying = false;
        // playerController?.seekTo(0);
        if (mounted) setState(() {});
      } else if (event == PlayerState.stopped) {
        isPlaying = false;
        playerController.seekTo(10);
        if (mounted) setState(() {});
      }
    });
    playerController.playerKey.isNotEmpty
        ? await playerController.preparePlayer(filePath)
        : null;
    // await playerController.startPlayer();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // bool status = timeLineController.currentStatus.value;
      String currentId = timeLineController.currentId.value;
      if (currentId.isNotEmpty) {
        print(":::::::::::::::::: calling me again like this, PLEASE STOP!!!");
        currentId == widget.id
            // ? status
            ? playerController.startPlayer(finishMode: FinishMode.loop)
            : playerController.pausePlayer();
        // : playerController.pausePlayer();
      } else {
        playerController.pausePlayer();
      }
      return Row(children: [
        InkWell(
          onTap: () {
            if (currentId == widget.id) {
              print(":::::::::::: 1");
              // timeLineController.currentStatus(!status);
              timeLineController.currentId('');
            } else {
              print(":::::::::::: 2");

              timeLineController.currentId(widget.id);
              // timeLineController.currentStatus(!status);
            }
          },
          child: Icon(
            currentId == widget.id
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            size: 32,
            color: const Color(0xff0077B6),
          ),
        ),
        SizedBox(
          width: getScreenWidth(3),
        ),
        isInitialised
            ? Expanded(
                child: LayoutBuilder(builder: (context, constraint) {
                  return AudioFileWaveforms(
                    size: Size(constraint.maxWidth < 250 ? 230 : 260, 24),
                    playerController: playerController,
                    density: 2,
                    enableSeekGesture: true,
                    playerWaveStyle: const PlayerWaveStyle(
                      scaleFactor: 0.2,
                      waveThickness: 3,
                      fixedWaveColor: Colors.white,
                      liveWaveColor: Color(0xff0077B6),
                      waveCap: StrokeCap.round,
                    ),
                  );
                }),
              )
            : const Expanded(
                // width: MediaQuery.of(context).size.width / 1.7,
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    color: AppColors.greyShade1,
                    backgroundColor: AppColors.greyShade1,
                  ),
                ),
              ),
        CustomText(
          text: StringUtil.formatDuration(
              Duration(milliseconds: currentDuration)),
          color: const Color(0xff0077B6),
          weight: FontWeight.w700,
          size: 14,
        ),
        SizedBox(
          width: getScreenWidth(12),
        ),
      ]);
    });
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
  }
}
