import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/home/data/dtos/create.status.dto.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/views/status/create.status.dart';
import 'package:reach_me/features/home/presentation/views/status/text.status.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_me/core/components/snackbar.dart';

class AudioStatus extends StatefulHookWidget {
  const AudioStatus({Key? key}) : super(key: key);

  @override
  State<AudioStatus> createState() => _AudioStatusState();
}

class _AudioStatusState extends State<AudioStatus> {
  bool recordAudio = false;
  //String? _timerText;
  bool islocked = false;
  String? audioPath1;
  File? audioRecordComplete;
  String? filePath;

  // SocialMediaRecorder media;

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    super.dispose();
    recorder.closeRecorder();
  }

  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  FlutterSoundPlayer? flutterSoundPlayer = FlutterSoundPlayer();

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Permission not granted';
    }

    await recorder.openRecorder();
    await recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future<void> startRecord() async {
    var tempDir = await getTemporaryDirectory();
    var path = '${tempDir.path}/flutter_sound.aac';

    await recorder.startRecorder(toFile: path);
  }

  Future<String?> stopRecord() async {
    final file = await recorder.stopRecorder();
    return file;
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

                          String twoDigits(int n) =>
                              n.toString().padLeft(2, '0');
                          final twoDigitMinutes =
                              twoDigits(duration.inMinutes.remainder(60));
                          final twoDigitSeconds =
                              twoDigits(duration.inSeconds.remainder(60));
                          return Center(
                            child: CircleAvatar(
                              backgroundColor: AppColors.black,
                              radius: 48,
                              child: CircleAvatar(
                                backgroundColor: AppColors.white,
                                radius: 46,
                                child: Text(
                                  '$twoDigitMinutes: $twoDigitSeconds',
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              Container(
                // height: size.height,
                width: size.width,
                decoration: const BoxDecoration(
                    // color: AppColors.black.withOpacity(0.9),
                    ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: getScreenHeight(44)),
                    !recordAudio
                        ? Row(
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
                                  onTap: () async {
                                    await startRecord();

                                    setState(() {
                                      recordAudio = true;
                                      //!recordAudio;
                                    });
                                    debugPrint("Started");
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.white,
                                        border: Border.all(
                                          color:
                                              AppColors.black.withOpacity(0.80),
                                          width: 9,
                                        )
                                        /* : Border.all(
                                                color: const Color.fromARGB(
                                                        255, 182, 18, 0)
                                                    .withOpacity(0.80),
                                                width: 9,
                                              )*/
                                        ),
                                    padding: const EdgeInsets.all(20),
                                    child: SvgPicture.asset(
                                      'assets/svgs/status-mic.svg',
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: getScreenWidth(70)),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () {
                                      RouteNavigators.pop(context);
                                    },
                                    child: const CircleAvatar(
                                      backgroundColor: AppColors.black,
                                      radius: 23,
                                      child: Icon(
                                        Icons.delete,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: getScreenWidth(70)),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () async {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.white,
                                          border: Border.all(
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
                                    ),
                                  ),
                                ),
                                SizedBox(width: getScreenWidth(70)),
                                Flexible(
                                    child: GestureDetector(
                                  onTap: () async {
                                    debugPrint("Icon check");
                                    var filePath = await stopRecord();

                                    if (filePath == null) {
                                      print('No saved file');
                                    } else {
                                      print('The FilePath is $filePath');
                                    }
                                    audioRecordComplete = File(filePath!);
                                    print(audioRecordComplete!.path);

                                    RouteNavigators.routeReplace(
                                        context,
                                        BuildAudioPreview(
                                            audio: audioRecordComplete!));
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: AppColors.black,
                                    radius: 23,
                                    child: Icon(
                                      Icons.check,
                                      color: AppColors.white,
                                    ),
                                  ),
                                )),
                              ]),
                    SizedBox(height: getScreenHeight(44)),
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

class BuildAudioPreview extends StatefulWidget {
  const BuildAudioPreview({Key? key, required this.audio}) : super(key: key);
  final File audio;

  @override
  State<BuildAudioPreview> createState() => _BuildAudioPreviewState();
}

class _BuildAudioPreviewState extends State<BuildAudioPreview> {
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void dispose() {
   
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001824),
      body: BlocConsumer<SocialServiceBloc, SocialServiceState>(
        bloc: globals.socialServiceBloc,
        listener: (context, state) {
          if (state is MediaUploadLoading) {
            Snackbars.success(context,
                message: 'Uploading status', milliseconds: 100);
          }
          if (state is MediaUploadError) {
            Snackbars.error(context, message: state.error);
          }
          if (state is MediaUploadSuccess) {
            globals.socialServiceBloc!.add(CreateStatusEvent(
              createStatusDto: CreateStatusDto(
                  caption: 'NIL', type: 'audio', audioMedia: state.image),
            ));
            RouteNavigators.pop(context);
          }
        },
        builder: ((context, state) {
          debugPrint("Audio path ${widget.audio.path}");

          audioPlayer.play(
            UrlSource(widget.audio.path),
          );
          audioPlayer.play(DeviceFileSource(
            widget.audio.path,
          ));
          audioPlayer.play(AssetSource(widget.audio.path));
          Uint8List bytes = widget.audio.readAsBytesSync();
          audioPlayer.play(BytesSource(bytes));
          return Container(
            decoration: const BoxDecoration(
              color: Colors.black12,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: getScreenHeight(60), bottom: getScreenHeight(35)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
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
                          onPressed: () {
                            globals.socialServiceBloc!.add(MediaUploadEvent(
                                media: File(widget.audio.path)));
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
                      ],
                    ).paddingSymmetric(h: 24),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '${globals.user!.firstName}' +
                              ' ' +
                              '${globals.user!.lastName}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600),
                        ),

                        Text(
                          '${globals.user!.location}',
                          style: const TextStyle(fontSize: 16),
                        ), //To get the name of the global users
                        const SizedBox(height: 10),
                        Helper.renderProfilePicture(
                            globals.user!.profilePicture,
                            size: 100)
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //CircleAvatar or
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 20),
                                child: const Text(
                                  'Add moment',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  'assets/svgs/download.svg',
                                  height: getScreenHeight(50),
                                  color: Colors.white,
                                )),
                          )
                        ]),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
