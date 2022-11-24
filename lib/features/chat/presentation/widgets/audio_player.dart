import 'dart:async';

import 'package:audioplayers/audioplayers.dart' as pathfile;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
//import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reach_me/core/services/media_service.dart';

import '../../../../core/helper/logger.dart';

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
  const PlayAudio({Key? key, this.audioFile, required this.isMe})
      : super(key: key);
  final String? audioFile;
  final bool isMe;
  @override
  State<PlayAudio> createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> {
  late final PlayerController playerController;
  bool isPlaying = false;
  //bool isInitialised = false;
  final currentDurationStream = StreamController<int>();
  int currentDuration = 0;
  final MediaService _mediaService = MediaService();

  @override
  void initState() {
    super.initState();
    if (mounted) _initaliseController();
    //directory = await getApplicationDocumentsDirectory();
  }

  void _initaliseController() async {
    final res = await _mediaService.downloadFile(url: widget.audioFile!);
    if (res == null) {
      print("THE URL FIELD IS NULL!!!!");
      return;
    }
    playerController = PlayerController();
    playerController.onCurrentDurationChanged.listen((event) {
      currentDuration = event;
      if (mounted) setState(() {});
    });
    playerController.addListener(() {
      Console.log('<<AUDIO-LISTENER>>', playerController.playerState.name);

      if (playerController.playerState == PlayerState.initialized) {
        //isInitialised = true;
        setState(() {});
      } else if (playerController.playerState == PlayerState.playing) {
        isPlaying = true;
        if (mounted) setState(() {});
      } else if (playerController.playerState == PlayerState.paused ||
          playerController.playerState == PlayerState.stopped) {
        isPlaying = false;
        if (mounted) setState(() {});
      }
    });
    await playerController.preparePlayer(res.path);
    if (mounted) setState(() {});
  }

  /* void _playandPause() async {
    playerController.playerState == PlayerState.playing
        ? await playerController.pausePlayer()
        : await playerController.startPlayer(finishMode: FinishMode.loop);
  }*/

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          child: IconButton(
            onPressed: () {
              if (isPlaying) {
                playerController.pausePlayer();
              } else {
                playerController.startPlayer(finishMode: FinishMode.pause);
              }
              setState(() {
                isPlaying = !isPlaying;
              });
            },
            icon: isPlaying
                ? Icon(
                    Icons.play_arrow,
                    size: 30,
                    color: widget.isMe ? Colors.white : Colors.blue,
                  )
                : Icon(
                    Icons.pause_circle,
                    size: 30,
                    color: widget.isMe ? Colors.white : Colors.blue,
                  ),
          ),
        ),
        //Expanded(
        // child:
        //Container(
        // padding: const EdgeInsets.symmetric(horizontal: 5.0),
        //child:
        AudioFileWaveforms(
          margin: const EdgeInsets.only(top: 7, bottom: 7, right: 7),
          size: Size(MediaQuery.of(context).size.width / 2.0, 24),
          playerController: playerController,
          density: 1.5,
          enableSeekGesture: true,
          playerWaveStyle: PlayerWaveStyle(
            scaleFactor: 0.8,
            fixedWaveColor: widget.isMe ? Colors.grey : Colors.lightBlueAccent,
            liveWaveColor: widget.isMe ? Colors.white : Colors.blue,
            waveCap: StrokeCap.round,
          ),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          animationDuration: const Duration(milliseconds: 1000),
        ),
        // ),
        //),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
  }
}
