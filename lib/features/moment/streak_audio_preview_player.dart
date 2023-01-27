import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reach_me/features/moment/user_posting.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/custom_text.dart';
import '../../core/utils/dimensions.dart';
import '../../core/utils/string_util.dart';

class AudioPreviewer extends StatefulWidget {
  final String audioPath;
  const AudioPreviewer({Key? key, required this.audioPath}) : super(key: key);

  @override
  State<AudioPreviewer> createState() => _AudioPreviewerState();
}

class _AudioPreviewerState extends State<AudioPreviewer> {
  late PlayerController playerController;
  bool isInitialised = false;
  int currentDuration = 0;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (mounted) initPlayer();
  }

  Future<void> initPlayer() async {
    String filePath = widget.audioPath;
    playerController = PlayerController();

    momentCtrl.previewerAudioController(playerController);
    // if(playerController == null) return;
    playerController.onCurrentDurationChanged.listen((event) {
      currentDuration = event;
      if (mounted) setState(() {});
    });

    playerController.onPlayerStateChanged.listen((event) {
      print(
          ';;;;;;;;;;;;;;;;;<<AUDIO-LISTENER>> ${playerController.playerState.name}');
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
    await playerController.preparePlayer(filePath);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      InkWell(
        onTap: () {
          // if (playerController == null) return;
          if (isPlaying) {
            playerController.pausePlayer();
          } else {
            // playerController!.stopAllPlayers();
            playerController.startPlayer(finishMode: FinishMode.loop);
          }
        },
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          size: 32,
          color: const Color(0xff0077B6),
        ),
      ),
      SizedBox(
        width: getScreenWidth(3),
      ),
      isInitialised
          ? Expanded(
              child: AudioFileWaveforms(
              size: Size(120, 24),
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
            ))
          : Expanded(
              // width: MediaQuery.of(context).size.width / 1.7,
              child: const LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                color: AppColors.greyShade1,
                backgroundColor: AppColors.greyShade1,
              ).paddingOnly(right: 5),
            ),
      CustomText(
        text:
            StringUtil.formatDuration(Duration(milliseconds: currentDuration)),
        color: const Color(0xff0077B6),
        weight: FontWeight.w700,
        size: 14,
      ),
      SizedBox(
        width: getScreenWidth(12),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
  }
}
