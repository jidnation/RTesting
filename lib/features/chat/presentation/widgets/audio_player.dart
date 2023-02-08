import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart' as pathfile;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:reach_me/core/services/media_service.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';

import '../../../../core/helper/logger.dart';
import '../../../../core/utils/string_util.dart';
import '../../../moment/moment_feed.dart';
import '../../../timeline/timeline_feed.dart';

class MyAudioPlayer extends StatefulHookWidget {
  const MyAudioPlayer({Key? key, this.sourceFile}) : super(key: key);
  final String? sourceFile;

  @override
  State<MyAudioPlayer> createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  final myAudioPlayer = pathfile.AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    setAudio(widget.sourceFile);

    myAudioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });
    myAudioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    myAudioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  Future setAudio(String? url) async {
    //we can also have a file pickup from the phone.

    /*final result = await FilePicker.platform.pickFiles();
     if(result != null){
      final file = File(result.files.single.path!);
      myaudioPlayer.setSourceUrl(file.path);
     }*/
    //await myAudioPlayer.setReleaseMode(ReleaseMode.loop);

    //It will load it from the Url.
    await myAudioPlayer.setSourceUrl(url!);

    //To load from the internet also

    /*final file = File(...);
    myaudioPlayer.setSourceUrl(file.path);*/
  }

  @override
  void dispose() {
    super.dispose();
    myAudioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            color: Colors.white,
            iconSize: 30,
            onPressed: () async {
              if (isPlaying) {
                await myAudioPlayer.pause();
              } else {
                await myAudioPlayer.resume();
              }
            },
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await myAudioPlayer.seek(position);

                //Optional: Play audio if was paused
                await myAudioPlayer.resume();
              },
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              alignment: Alignment.bottomLeft,
              child: Text(
                formatTime(position),
                style: const TextStyle(
                  fontSize: 10.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}

class PlayAudio extends StatefulWidget {
  const PlayAudio(
      {Key? key,
      this.audioFile,
      required this.isMe,
      required this.timeStamp,
      this.id})
      : super(key: key);
  final String? audioFile;
  final bool isMe;
  final String timeStamp;
  final String? id;
  @override
  State<PlayAudio> createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> {
  late PlayerController playerController;
  bool isPlaying = false;
  bool isInitialised = false;
  bool isReadingComplete = false;
  final currentDurationStream = StreamController<int>();
  int currentDuration = 0;
  int position = 0;
  final MediaService _mediaService = MediaService();

  @override
  void initState() {
    super.initState();
    if (mounted) _initaliseController();
    //directory = await getApplicationDocumentsDirectory();
  }

  void _initaliseController() async {
    late String filePath;
    playerController = PlayerController();
    File? audioFile = await momentFeedStore.videoControllerService
        .getAudioFile(widget.audioFile!);
    if (audioFile == null) {
      var result = await _mediaService.downloadFile(url: widget.audioFile!);
      filePath = result!.path;
    } else {
      filePath = audioFile.path;
    }

    playerController.onCurrentDurationChanged.listen((event) {
      currentDuration = event;
      if (mounted) setState(() {});
    });

    playerController.addListener(() {
      Console.log('<<AUDIO-LISTENER>>', playerController.playerState.name);

      if (playerController.playerState == PlayerState.initialized) {
        isInitialised = true;
        if (mounted) setState(() {});
      } else if (playerController.playerState == PlayerState.playing) {
        isPlaying = true;
        if (mounted) setState(() {});
      } else if (playerController.playerState == PlayerState.paused ||
          playerController.playerState == PlayerState.stopped) {
        isPlaying = false;
        // playerController.seekTo(10);
        if (mounted) setState(() {});
      }
    });
    await playerController.preparePlayer(filePath);
    if (mounted) setState(() {});

    position = await playerController.getDuration(DurationType.max);
    if (mounted) setState(() {});
  }

  /* void _playandPause() async {
    playerController.playerState == PlayerState.playing
        ? await playerController.pausePlayer()
        : await playerController.startPlayer(finishMode: FinishMode.loop);
  }*/

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool status = timeLineController.currentStatus.value;
      timeLineController.currentId.value == widget.id
          ? status
              ? playerController.startPlayer(finishMode: FinishMode.loop)
              : playerController.pausePlayer()
          : playerController.pausePlayer();
      return Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      if (timeLineController.currentId.value == widget.id) {
                        timeLineController.currentStatus(!status);
                      } else {
                        timeLineController.currentId(widget.id);
                      }
                    },
                    icon: !isPlaying
                        ? Icon(
                            Icons.play_arrow,
                            size: 30,
                            color: widget.isMe
                                ? Colors.white
                                : AppColors.textColor2,
                          )
                        : Icon(
                            Icons.pause_circle,
                            size: 30,
                            color: widget.isMe
                                ? Colors.white
                                : AppColors.textColor2,
                          ),
                  ),
                ),
                //Expanded(
                // child:
                //Container(
                // padding: const EdgeInsets.symmetric(horizontal: 5.0),
                //child:
                isInitialised
                    ? AudioFileWaveforms(
                        margin:
                            const EdgeInsets.only(top: 7, bottom: 3, right: 7),
                        size: Size(MediaQuery.of(context).size.width / 2.5, 28),
                        playerController: playerController,
                        density: 1.5,
                        enableSeekGesture: true,
                        playerWaveStyle: PlayerWaveStyle(
                          scaleFactor: 0.2,
                          fixedWaveColor: widget.isMe
                              ? AppColors.greyShade1
                              : AppColors.greyShade1,
                          liveWaveColor:
                              widget.isMe ? Colors.white : AppColors.textColor2,
                          waveCap: StrokeCap.butt,
                        ),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        animationDuration: const Duration(milliseconds: 1000),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: widget.isMe
                            ? const LinearProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                color: AppColors.greyShade1,
                                backgroundColor: AppColors.greyShade1,
                              )
                            : const LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.textColor2),
                                color: AppColors.greyShade1,
                                backgroundColor: AppColors.greyShade1,
                              )),

                // ),
                //),
              ],
            ),
          ),
          Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 29),
                    child: isInitialised
                        ? !isPlaying
                            ? Text(
                                StringUtil.formatDuration(
                                    Duration(milliseconds: position)),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: widget.isMe
                                        ? AppColors.white
                                        : AppColors.textColor2,
                                    fontSize: 10),
                              )
                            : Text(
                                StringUtil.formatDuration(
                                    Duration(milliseconds: currentDuration)),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: widget.isMe
                                        ? AppColors.white
                                        : AppColors.textColor2,
                                    fontSize: 10),
                              )
                        : Text(
                            StringUtil.formatDuration(
                                const Duration(milliseconds: 0)),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: widget.isMe
                                    ? AppColors.white
                                    : AppColors.textColor2,
                                fontSize: 10),
                          ),
                  ),
                  SizedBox(width: getScreenWidth(20)),
                  Text(
                    widget.timeStamp,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color:
                          widget.isMe ? AppColors.white : AppColors.textColor2,
                    ),
                  ),
                ]),
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
  }
}

enum Time { start, pause, reset }

class TimerController extends ValueNotifier<Time> {
  TimerController({Time time = Time.reset}) : super(time);
  void startTimer() => value = Time.start;
  void pauseTimer() => value = Time.pause;
  void resetTimer() => value = Time.reset;
}

class TimerWidget extends StatefulWidget {
  final TimerController controller;
  const TimerWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration duration = const Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      switch (widget.controller.value) {
        case Time.start:
          startTimer();
          break;
        case Time.pause:
          stopTimer();
          break;
        case Time.reset:
          reset();
          stopTimer();
          break;
      }
    });
  }

  void reset() => setState(() => duration = const Duration());

  void addTime() {
    const addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer({bool resets = true}) {
    if (!mounted) return;
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    print('....................object...............');
  }

  void stopTimer() {
    if (!mounted) return;
    setState(() => timer?.cancel());
    print(
        '........................iiiiiiiiiiiiiiiiiiiiiiiiiiiii...............');
  }

  @override
  Widget build(BuildContext context) => Center(child: buildTime());

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      '$twoDigitMinutes:$twoDigitSeconds',
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class BlinkText extends StatefulWidget {
  final String _target;
  const BlinkText(this._target, {Key? key}) : super(key: key);

  @override
  State<BlinkText> createState() => _BlinkTextState();
}

class _BlinkTextState extends State<BlinkText> {
  bool _show = true;
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        setState(() {
          _show = !_show;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Text(widget._target,
      style: _show
          ? const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)
          : const TextStyle(color: Colors.transparent));
}
