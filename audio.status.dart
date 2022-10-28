import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/home/presentation/views/status/create.status.dart';
import 'package:reach_me/features/home/presentation/views/status/text.status.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';


class AudioStatus extends StatefulHookWidget {
  const AudioStatus({Key? key}) : super(key: key);

  @override
  State<AudioStatus> createState() => _AudioStatusState();
}

class _AudioStatusState extends State<AudioStatus> {
  bool recordAudio = false;
  //String? _timerText;

  // SocialMediaRecorder media;

  @override
  void initState() {
    initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  final recorder = FlutterSoundRecorder();

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Permission not granted';
    }
    await recorder.openRecorder();
    await recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    await recorder.startRecorder(toFile: "audio");
  }

  Future stopRecord() async {
    final filePath = await recorder.stopRecorder();
    final file = File(filePath!);
    print('Recorded file path: $filePath');
  }

  /*Future<void> playFunc() async {
    recordingPlayer.open(
      Audio.file(pathToAudio!),
      autoStart: true,
      showNotification: true,
    );
  }

  Future<void> stopPlayFunc() async {
    recordingPlayer.stop();
  }*/

  Set active = {};

  handleTap(int index) {
    if (active.isNotEmpty) active.clear();
    setState(() {
      active.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isCameraStatus = useState(false);
    final isAudioStatus = useState(true);
    final isTextStatus = useState(false);
    final currentSelectedBg = useState<String>('assets/images/status-bg-1.jpg');
    final bgList = useState([
      'assets/images/status-bg-1.jpg',
      'assets/images/status-bg-2.jpg',
      'assets/images/status-bg-3.jpg'
    ]);
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(currentSelectedBg.value),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: EdgeInsets.only(
              top: getScreenHeight(60), bottom: getScreenHeight(35)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              !recordAudio
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
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
                    ).paddingSymmetric(h: 24)
                  : Align(
                      alignment: Alignment.topCenter,
                      child: IconButton(
                        onPressed: () {},
                        icon: Transform.scale(
                          scale: 1.8,
                          child: SvgPicture.asset(
                            'assets/svgs/lock_open_outline.svg',
                            height: getScreenHeight(50),
                            color: Colors.white,
                          ),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ).paddingSymmetric(h: 24),
              !recordAudio
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: getScreenWidth(65),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //=========================
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: bgList.value.length,
                                  itemBuilder: (context, index) {
                                    return BgButton(
                                      isSelected:
                                          active.contains(index) ? true : false,
                                      image: bgList.value[index],
                                      onTap: () {
                                        handleTap(index);
                                        currentSelectedBg.value =
                                            bgList.value[index];
                                      },
                                    );
                                  },
                                ),
                                FittedBox(
                                  child: InkWell(
                                    onTap: () {},
                                    child: Text(
                                      'Backgrounds',
                                      style: TextStyle(
                                        fontSize: getScreenHeight(13),
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ).paddingOnly(l: 20),
                        ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.black.withOpacity(0.50),
                              borderRadius: BorderRadius.circular(33),
                            ),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isTextStatus.value
                                          ? AppColors.white
                                          : Colors.transparent,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        isTextStatus.value = true;
                                        isCameraStatus.value = false;
                                        isAudioStatus.value = false;
                                        RouteNavigators.routeReplace(
                                            context, const TextStatus());
                                      },
                                      icon: SvgPicture.asset(
                                          'assets/svgs/pen.svg',
                                          color: isTextStatus.value
                                              ? AppColors.black
                                              : null),
                                      //  padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isAudioStatus.value
                                          ? AppColors.white
                                          : Colors.transparent,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        isTextStatus.value = false;
                                        isCameraStatus.value = false;
                                        isAudioStatus.value = true;
                                      },
                                      icon: SvgPicture.asset(
                                          'assets/svgs/status-mic.svg',
                                          color: isAudioStatus.value
                                              ? AppColors.black
                                              : null),
                                      constraints: const BoxConstraints(),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isCameraStatus.value
                                          ? AppColors.white
                                          : Colors.transparent,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        isCameraStatus.value = true;
                                        isAudioStatus.value = false;
                                        isTextStatus.value = false;
                                        RouteNavigators.routeReplace(
                                            context, const CreateStatus());
                                        //RouteNavigators.pop(context);
                                      },
                                      icon: SvgPicture.asset(
                                          'assets/svgs/Camera.svg',
                                          color: isCameraStatus.value
                                              ? AppColors.black
                                              : null),
                                      //padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ),
                                ]),
                          ).paddingOnly(r: 24),
                        ),
                      ],
                    )
                  : /*Center(
                      child: (Text(
                        '$_timerText',
                        style: const TextStyle(
                            fontSize: 70, color: Colors.black45),
                      )),
                    ),*/

                  Center(
                      child: StreamBuilder<RecordingDisposition>(
                      stream: recorder.onProgress,
                      builder: (context, snapshot) {
                        final duration = snapshot.hasData
                            ? snapshot.data!.duration
                            : Duration.zero;

                        String twoDigits(int n) => n.toString().padLeft(2, '0');
                        final twoDigitMinutes =
                            twoDigits(duration.inMinutes.remainder(60));
                        final twoDigitSeconds =
                            twoDigits(duration.inSeconds.remainder(60));
                        return Text(
                          '$twoDigitMinutes: $twoDigitSeconds',
                          style: const TextStyle(
                              fontSize: 30, color: Colors.black),
                        );
                      },
                    )),
              Container(
                // height: size.height,
                width: size.width,
                decoration: const BoxDecoration(
                    //  color: AppColors.black.withOpacity(0.9),
                    ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: getScreenHeight(44)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: IconButton(
                            onPressed: () async {},
                            icon: Transform.scale(
                              scale: 1.8,
                              child: SvgPicture.asset(
                                'assets/svgs/check-gallery.svg',
                                height: getScreenHeight(71),
                              ),
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                        SizedBox(width: getScreenWidth(70)),
                        Flexible(
                          child: GestureDetector(
                              onTap: () {
                                if (recorder.isRecording) {
                                  stopRecord();
                                } else if (recorder.isStopped) {
                                  startRecord();
                                }
                                setState(() {
                                  recordAudio = !recordAudio;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.white,
                                    border: !recordAudio
                                        ? Border.all(
                                            color: AppColors.black
                                                .withOpacity(0.80),
                                            width: 9,
                                          )
                                        : Border.all(
                                            color: const Color.fromARGB(
                                                    255, 182, 18, 0)
                                                .withOpacity(0.80),
                                            width: 9,
                                          )),
                                padding: const EdgeInsets.all(20),
                                child: SvgPicture.asset(
                                  'assets/svgs/status-mic.svg',
                                  color: AppColors.black,
                                ),
                              )),
                        ),
                        SizedBox(width: getScreenWidth(70)),
                      ],
                    ),
                    SizedBox(height: getScreenHeight(44))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
