import 'package:audioplayers/audioplayers.dart' as pathfile;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
//import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
//import 'package:path_provider/path_provider.dart';

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
  const PlayAudio({Key? key, this.audioFile}) : super(key: key);
  final String? audioFile;

  @override
  State<PlayAudio> createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> {
  late final PlayerController playerController;
  String? path;
  bool isPlaying = false;

  late Directory directory;

  void _initaliseController() {
    playerController = PlayerController();
  }

  /* void _playandPause() async {
    playerController.playerState == PlayerState.playing
        ? await playerController.pausePlayer()
        : await playerController.startPlayer(finishMode: FinishMode.loop);
  }*/

  @override
  void initState() {
    super.initState();
    _initaliseController();
    //directory = await getApplicationDocumentsDirectory();
    path = widget.audioFile;
    //'${directory.path}/test_audio.aac';

    playerController.preparePlayer(path!);
    print(widget.audioFile);
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AudioFileWaveforms(
          size: Size(MediaQuery.of(context).size.width / 2, 70),
          playerController: playerController,
          density: 1.5,
          playerWaveStyle: const PlayerWaveStyle(
            scaleFactor: 0.8,
            fixedWaveColor: Colors.blue,
            liveWaveColor: Colors.yellow,
            waveCap: StrokeCap.butt,
          ),
        ),
        IconButton(
          onPressed: () async {
            if (isPlaying) {
              await playerController.stopPlayer();
            } else {
              await playerController.startPlayer();
            }
            setState(() {
              isPlaying = !isPlaying;
            });
          },
          icon: isPlaying
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.stop_circle),
        )
      ],
    );
  }
}