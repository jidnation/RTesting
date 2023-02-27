import 'dart:developer';
import 'dart:io';

// import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:neon_circular_timer/neon_circular_timer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:reach_me/features/home/presentation/views/status/widgets/host_post.dart';
import 'package:reach_me/features/home/presentation/views/status/widgets/live_screen.dart';
import 'package:reach_me/features/home/presentation/views/status/widgets/posting_type.dart';

import '../../core/services/media_service.dart';
import '../../core/services/moment/controller.dart';
import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/count_down_timer.dart';
import '../../core/utils/dimensions.dart';
import '../../core/utils/file_utils.dart';
import '../home/presentation/views/status/create.status.dart';
import '../home/presentation/views/status/widgets/create_posting.dart';
import 'momentControlRoom/moment_recording_control_room.dart';
import 'moment_posting.dart';
import 'moment_posting_timer.dart';

class UserPosting extends StatefulHookWidget {
  final int initialIndex;
  const UserPosting({
    Key? key,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<UserPosting> createState() => _UserPostingState();
}

final MomentController momentCtrl = Get.find();
CarouselController sliderController = CarouselController();

final CountDownController timeController = CountDownController();
final MomentVideoControl momentVideoControl = MomentVideoControl();
int index = 0;

class _UserPostingState extends State<UserPosting> with WidgetsBindingObserver {
  late final DeepArController _controller;
  String selectedTime = '15s';
  int time = 15;

  initializeCamera() {
    _controller = DeepArController();

    _controller
        .initialize(
          androidLicenseKey:
              "6e7cd1ebcba56dff5932332ac4d7fe04875670529ace3d6d0094fff59f7478db4fbd56b9bc668306",
          iosLicenseKey:
              "30e5dc9f3efcf7aa4dca4c35690ed20deaf3f2d6c4573019f5cd65a08b8c07c4e2647ab0d1c30182",
          resolution: Resolution.high,
        )
        .then((value) => setState(() {}));
    super.initState();
  }

  @override
  void initState() {
    super.initState();
    initializeCamera();
    setState(() {
      index = widget.initialIndex;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (!_controller.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      _controller.destroy();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    ///
    /// POSTING TYPES
    ///
    List<Widget> postings = [
      CreatePosting(
        controller: _controller,
        context: context,
      ),
      MomentPosting(
          controller: _controller, slidingController: sliderController),
      LiveScreen(
        controller: _controller,
        slidingController: sliderController,
      ),
    ];
    return Obx(() {
      bool isRecording = momentCtrl.isRecording.value;
      return WillPopScope(
        onWillPop: () async {
          _controller.destroy();
          return true;
        },
        child: Scaffold(
            backgroundColor: const Color(0xFF001824),
            body: SizedBox(
                height: size.height,
                width: size.width,
                child: Column(children: [
                  Stack(children: [
                    CarouselSlider(
                        carouselController: sliderController,
                        items: postings
                            .map((posting) => Builder(
                                  builder: (BuildContext context) {
                                    return posting;
                                  },
                                ))
                            .toList(),
                        options: CarouselOptions(
                          initialPage: widget.initialIndex,
                          height: getScreenHeight(700),
                          viewportFraction: 1,
                          enableInfiniteScroll: false,
                          autoPlayCurve: Curves.easeInToLinear,
                          enlargeCenterPage: true,
                          onPageChanged: (val, _) {
                            setState(() {
                              index = val;
                            });
                          },
                          scrollDirection: Axis.horizontal,
                        )),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color(0xff7e8587).withOpacity(0.5),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(8),
                            )),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PosingType(
                                      label: 'Status',
                                      isSelected: index == 0,
                                      onClick: () {
                                        sliderController.jumpToPage(0);
                                      },
                                    ),
                                    const SizedBox(width: 20),
                                    PosingType(
                                      label: 'Streak',
                                      isSelected: index == 1,
                                      onClick: () {
                                        sliderController.jumpToPage(1);
                                      },
                                    ),
                                    const SizedBox(width: 20),
                                    PosingType(
                                      label: 'Live',
                                      isSelected: index == 2,
                                      onClick: () {
                                        sliderController.jumpToPage(2);
                                      },
                                    ),
                                  ]),
                              const SizedBox(height: 2),
                            ]),
                      ),
                    ),
                    index != 2
                        ? Visibility(
                            visible: index == 1,
                            child: Positioned(
                              bottom: 70,
                              right: 0,
                              left: 0,
                              child:
                                  // controller!.value.isRecordingVideo
                                  isRecording
                                      ? CountDownTimer(
                                          time: time,
                                          timeController: timeController,
                                          onFinish: () {
                                            stopRecording(context);
                                          },
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                              MomentPostingTimer(
                                                time: '3m',
                                                isSelected:
                                                    selectedTime == '3m',
                                                onClick: () {
                                                  setState(() {
                                                    selectedTime = '3m';
                                                    time = 3 * 60;
                                                  });
                                                },
                                              ),
                                              const SizedBox(width: 5),
                                              MomentPostingTimer(
                                                time: '60s',
                                                isSelected:
                                                    selectedTime == '60s',
                                                onClick: () {
                                                  setState(() {
                                                    selectedTime = '60s';
                                                    time = 60;
                                                  });
                                                },
                                              ),
                                              const SizedBox(width: 5),
                                              MomentPostingTimer(
                                                time: '15s',
                                                isSelected:
                                                    selectedTime == '15s',
                                                onClick: () {
                                                  setState(() {
                                                    selectedTime = '15s';
                                                    time = 15;
                                                  });
                                                },
                                              )
                                            ]),
                            ),
                          )
                        : Container()
                  ]),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: index != 1,
                          child: MomentCameraBtn(
                            svgUrl: 'assets/svgs/check-gallery.svg',
                            onClick: () async {
                              final res = await MediaService()
                                  .pickFromGallery(context: context);
                              if (res != null) {
                                final status = await RouteNavigators.route(
                                    context,
                                    BuildMediaPreview(
                                      path: res.first.path,
                                      isVideo:
                                          FileUtils.isVideo(res.first.file),
                                    ));
                                if (status == null) return;
                                RouteNavigators.pop(context, status);
                              }
                            },
                          ),
                        ),
                        Visibility(
                          visible: isRecording,
                          child: MomentCameraBtn(
                            svgUrl: 'assets/svgs/reverse.svg',
                            padding: 8,
                            onClick: () async {},
                          ),
                        ),
                        SizedBox(width: isRecording ? getScreenWidth(26) : 0),
                        SizedBox(width: getScreenWidth(30)),
                        InkWell(
                          onTap: index == 0
                              ? () async {
                                  await _controller.takeScreenshot().then(
                                        (value) => RouteNavigators.route(
                                          context,
                                          BuildMediaPreview(
                                            path: value.path,
                                            isVideo: false,
                                          ),
                                        ),
                                      );
                                }
                              : index == 1
                                  ? () async {
                                      if (isRecording) {
                                        await stopRecording(context);
                                        setState(() {});
                                        // _startVideoPlayer();
                                      } else {
                                        print('..........stopped recording');
                                        await momentVideoControl
                                            .startVideoRecording(
                                          videoController: _controller,
                                        );
                                        setState(() {});
                                      }
                                    }
                                  : () async {
                                      globals.chatBloc!.add(
                                          InitiateLiveStreamEvent(
                                              startedAt: '12/31/2022'));
                                      print(
                                          "org ${globals.streamLive!.channelName}");
                                      print("org ${globals.streamLive!.token}");
                                      RouteNavigators.route(
                                          context,
                                          const HostPost(
                                            isHost: true,
                                          ));
                                      // globals.chatBloc!.add(JoinStreamEvent(channelName: globals.streamLive!.channelName));
                                      // RouteNavigators.route(context, const HostPost(isHost: true,));
                                    },
                          child: Container(
                            height: 80,
                            width: 80,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              color: isRecording
                                  ? Colors.red
                                  : Colors.black.withOpacity(0.5),
                            ),
                            child: Container(
                              height: 70,
                              width: 70,
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: index == 0
                                  ? SvgPicture.asset(
                                      'assets/svgs/Camera.svg',
                                      color: AppColors.black,
                                    )
                                  : index == 1
                                      ? isRecording
                                          ? const Icon(
                                              Icons.stop,
                                              color: Colors.red,
                                            )
                                          : Image.asset(
                                              'assets/images/play-btn.png',
                                              fit: BoxFit.contain,
                                            )
                                      : SvgPicture.asset(
                                          'assets/svgs/fluent_live-24-regular.svg',
                                          color: AppColors.black,
                                        ),
                            ),
                          ),
                        ),
                        SizedBox(width: getScreenWidth(30)),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Visibility(
                            child: MomentCameraBtn(
                              svgUrl: 'assets/svgs/flip-camera.svg',
                              onClick: () async {
                                _controller.flipCamera();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Visibility(
                            visible: isRecording,
                            child: Container(
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
                            ),
                          ),
                        ]),
                      ])
                ]))
            // : Container(),
            ),
      );
    });
  }

  Future<void> stopRecording(BuildContext context) async {
    print('..........is recording');
    File? videoFile = await momentVideoControl.stopVideoRecording(
      videoController: _controller,
    );
    momentCtrl.endTime(time);

    int currentUnix = DateTime.now().millisecondsSinceEpoch;

    final directory = await getApplicationDocumentsDirectory();
    String fileFormat = videoFile!.path.split('.').last;

    File _videoFile = await videoFile.copy(
      '${directory.path}/$currentUnix.$fileFormat',
    );
    momentVideoControl.startVideoPlayer(context, videoFile: _videoFile);
    print('videoFile.....: $_videoFile');
    // _startVideoPlayer();
  }
}

class MomentCameraBtn extends StatelessWidget {
  final String svgUrl;
  final double? padding;
  final Function()? onClick;
  const MomentCameraBtn({
    Key? key,
    required this.svgUrl,
    this.onClick,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 46,
        width: 46,
        padding: EdgeInsets.all(padding ?? 0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: SvgPicture.asset(
          svgUrl,
          height: 16.58,
          width: 16.58,
        ),
      ),
    );
  }
}
