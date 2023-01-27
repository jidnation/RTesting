import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:file_picker/src/platform_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:reach_me/features/moment/streak_audio_preview_player.dart';
import 'package:reach_me/features/moment/user_posting.dart';

import '../../core/components/snackbar.dart';
import '../../core/services/media_service.dart';
import '../../core/services/moment/controller.dart';
import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/custom_text.dart';
import '../../core/utils/dimensions.dart';
import 'moment_actions.dart';
import 'moment_count_down_timer.dart';

class MomentPosting extends StatefulWidget {
  final CameraController? controller;
  final CarouselController slidingController;

  const MomentPosting({
    Key? key,
    required this.controller,
    required this.slidingController,
  }) : super(key: key);

  @override
  State<MomentPosting> createState() => _MomentPostingState();
}

int countDownTime = 0;
bool showTimer = false;
bool playSound = false;

class _MomentPostingState extends State<MomentPosting> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    widget.controller!.setFlashMode(FlashMode.auto);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(() {
      PlatformFile soundFile = momentCtrl.audioFile.value;
      return Column(children: [
        Expanded(
          child: Container(
            width: size.width,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            )),
            // height: size.height * 0.8,
            child: CameraPreview(
              widget.controller!,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(children: [
                  const SizedBox(height: 40),
                  Positioned(
                    top: 15,
                    right: 0,
                    left: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              widget.slidingController.jumpToPage(0);
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
                          playSound
                              ? SizedBox(
                                  height: 30,
                                  width: 200,
                                  child: AudioPreviewer(
                                      audioPath: soundFile.path!))
                              : Row(children: [
                                  InkWell(
                                    onTap: () async {
                                      print('.....picking audio file');
                                      PlatformFile? audioFile =
                                          await MediaService().getAudioFiles();
                                      if (audioFile != null) {
                                        Snackbars.success(
                                          context,
                                          message:
                                              "Audio file successfully added",
                                        );
                                        momentCtrl
                                            .audioFilePath(audioFile.path);
                                        momentCtrl.audioFile(audioFile);
                                        print('..... file picked: $audioFile');
                                      }
                                    },
                                    child: Container(
                                      height: 30,
                                      constraints: BoxConstraints(
                                        maxWidth: soundFile.name.isNotEmpty
                                            ? 180
                                            : 120,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      // width: getScreenWidth(126),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.black.withOpacity(0.4),
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svgs/music-note.svg',
                                              height: 20,
                                              width: 20,
                                            ),
                                            soundFile.name.isNotEmpty
                                                ? Expanded(
                                                    // height: 20,
                                                    // width: 130,
                                                    child: Marquee(
                                                      text: soundFile.name,
                                                      style: const TextStyle(
                                                        fontSize: 12.44,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                      pauseAfterRound:
                                                          const Duration(
                                                              seconds: 2),
                                                    ),
                                                  )
                                                : const CustomText(
                                                    text: 'Add Sound',
                                                    size: 12.44,
                                                    weight: FontWeight.w700,
                                                    color: Colors.white,
                                                  )
                                          ]),
                                    ),
                                  ),
                                  Visibility(
                                    visible: soundFile.name.isNotEmpty,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          playSound = true;
                                        });
                                      },
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ]),
                          InkWell(
                            onTap: () async {
                              if (widget.controller!.value.flashMode ==
                                  FlashMode.auto) {
                                widget.controller!
                                    .setFlashMode(FlashMode.torch);
                              } else {
                                widget.controller!.setFlashMode(FlashMode.auto);
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: widget.controller!.value.flashMode ==
                                        FlashMode.auto
                                    ? Colors.black.withOpacity(0.4)
                                    : Colors.white,
                              ),
                              child: SvgPicture.asset(
                                'assets/svgs/flash-icon.svg',
                                height: 10,
                                color: widget.controller!.value.flashMode ==
                                        FlashMode.auto
                                    ? Colors.white
                                    : Colors.black,
                                width: 10,
                                // fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Center(
                    child: Stack(children: [
                      SizedBox(
                        height: 250,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 50,
                            child: Column(
                                // mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // const MomentActions(
                                  //   label: 'Speed',
                                  //   svgUrl: 'assets/svgs/speeding.svg',
                                  // ),
                                  // const SizedBox(height: 20),
                                  const MomentActions(
                                    label: 'Filters',
                                    svgUrl: 'assets/svgs/filter-n.svg',
                                  ),
                                  const SizedBox(height: 20),
                                  const MomentActions(
                                    label: 'Beautify',
                                    svgUrl: 'assets/svgs/beautify-n.svg',
                                  ),
                                  const SizedBox(height: 20),
                                  MomentActions(
                                    label: 'Timer',
                                    svgUrl: 'assets/svgs/timer-n.svg',
                                    onClick: () {
                                      setState(() {
                                        showTimer = !showTimer;
                                      });
                                    },
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      showTimer
                          ? Positioned(
                              bottom: 60,
                              right: 38,
                              child: Container(
                                height: 25,
                                width: 120,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white,
                                ),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              countDownTime = 5;
                                              showTimer = false;
                                            });
                                            momentCtrl.momentCounter(1);
                                          },
                                          child: const CustomText(
                                            text: '5s',
                                            weight: FontWeight.w500,
                                            size: 14,
                                          )),
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              countDownTime = 10;
                                              showTimer = false;
                                            });
                                            momentCtrl.momentCounter(1);
                                          },
                                          child: const CustomText(
                                            text: '10s',
                                            weight: FontWeight.w500,
                                            size: 14,
                                          )),
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              countDownTime = 20;
                                              showTimer = false;
                                            });
                                            momentCtrl.momentCounter(1);
                                          },
                                          child: const CustomText(
                                            text: '20s',
                                            weight: FontWeight.w500,
                                            size: 14,
                                          )),
                                    ]),
                              ))
                          : const SizedBox.shrink(),
                    ]),
                  ),
                  GetX<MomentController>(
                    builder: (mc) {
                      return mc.momentCounter.value != 0
                          ? Center(
                              child: CountDownTimer(
                              from: countDownTime,
                              vController: widget.controller!,
                            ))
                          : const SizedBox.shrink();
                    },
                  ),
                ]),
              ),
            ),
          ),
        ),
      ]);
    });
  }
}

// Container(
//   width: MediaQuery.of(context).size.width,
//   decoration: const BoxDecoration(
//       borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
//   child: CameraPreview(
//     widget.controller!,
//     child: Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(children: [
//         const SizedBox(height: 40),
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           IconButton(
//             onPressed: () {
//               RouteNavigators.pop(context);
//             },
//             icon: Transform.scale(
//               scale: 1.8,
//               child: SvgPicture.asset(
//                 'assets/svgs/dc-cancel.svg',
//                 height: getScreenHeight(71),
//               ),
//             ),
//             padding: EdgeInsets.zero,
//             constraints: const BoxConstraints(),
//           ),
//           Container(
//             height: 30,
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             width: getScreenWidth(126),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(25),
//               color: Colors.black.withOpacity(0.4),
//             ),
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   SvgPicture.asset(
//                     'assets/svgs/music-note.svg',
//                     height: 20,
//                     width: 20,
//                   ),
//                   const CustomText(
//                     text: 'Add Sound',
//                     size: 12.44,
//                     weight: FontWeight.w700,
//                     color: Colors.white,
//                   )
//                 ]),
//           ),
//           InkWell(
//             onTap: () async {
//               if (widget.controller!.value.flashMode == FlashMode.off) {
//                 widget.controller!.setFlashMode(FlashMode.always);
//                 print(
//                     '...............${widget.controller!.value.flashMode}');
//               } else {
//                 widget.controller!.setFlashMode(FlashMode.off);
//               }
//             },
//             child: Container(
//               height: 46,
//               width: 46,
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//                 color: widget.controller!.value.flashMode == FlashMode.off
//                     ? Colors.black.withOpacity(0.4)
//                     : Colors.white,
//               ),
//               child: SvgPicture.asset(
//                 'assets/svgs/flash-icon.svg',
//                 height: 10,
//                 color: widget.controller!.value.flashMode == FlashMode.off
//                     ? Colors.white
//                     : Colors.black,
//                 width: 10,
//                 // fit: BoxFit.contain,
//               ),
//             ),
//           ),
//         ]),
//       ]),
//     ),
//   ),
// ),
// Expanded(
//   child: Container(
//     height: 200,
//     color: Colors.orange,
//     width: 300,
//   ),
// )
