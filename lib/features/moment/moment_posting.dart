import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:file_picker/src/platform_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

class MomentPosting extends StatefulHookWidget {
  final DeepArController? controller;
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
int filterIndex = 0;
String normalPath = 'assets/effects/normal.deepar';
List<String> filters = [
  "normal.deepar",
  "blur_filter.deepar",
  "elephant_filter.deepar",
  "hope_filter.deepar",
  "humanoid_filter.deepar",
  "fire_filter.deepar",
  "pixel_hearts_filter.deepar",
  "galaxy_filter.deepar",
  "split_filter.deepar"
];
List<String> beus = [
  "normal.deepar",
  "burning_beu.deepar",
  "devil_horn_beu.deepar",
  "emotion_beu.deepar",
  "snail_beu.deepar",
  "viking_helmet_beu.deepar",
  "vendetta_beu.deepar",
  "stallone_beu.deepar",
  "Ping_Pong_beu.deepar",
  "makeup_beu.deepar",
  "flower_face_beu.deepar"
];

class _MomentPostingState extends State<MomentPosting> {
  final CarouselController? _carouselController = CarouselController();
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    ValueNotifier<String> type = useState('');
    return Obx(() {
      PlatformFile soundFile = momentCtrl.audioFile.value;
      bool playSound = momentCtrl.playSound.value;
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
            child: Stack(children: [
              Transform.scale(
                scale: (1 / widget.controller!.aspectRatio) / deviceRatio,
                child: DeepArPreview(
                  widget.controller!,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
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
                                widget.controller!.destroy();
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
                                            await MediaService()
                                                .getAudioFiles();
                                        if (audioFile != null) {
                                          Snackbars.success(
                                            context,
                                            message:
                                                "Audio file successfully added",
                                          );
                                          momentCtrl
                                              .audioFilePath(audioFile.path);
                                          momentCtrl.audioName(audioFile.name);
                                          momentCtrl.audioFile(audioFile);
                                          print(
                                              '..... file picked name>>: ${audioFile.name}');
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
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
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
                                          momentCtrl.playSound(true);
                                        },
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ]),
                            InkWell(
                              onTap: () async {
                                await widget.controller!.toggleFlash();
                                setState(() {});
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: !widget.controller!.flashState
                                      ? Colors.black.withOpacity(0.4)
                                      : Colors.white,
                                ),
                                child: SvgPicture.asset(
                                  'assets/svgs/flash-icon.svg',
                                  height: 10,
                                  color: !widget.controller!.flashState
                                      ? Colors.white
                                      : Colors.black,
                                  width: 10,
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
                                    MomentActions(
                                      label: 'Filters',
                                      svgUrl: 'assets/svgs/filter-n.svg',
                                      onClick: () {
                                        if (type.value == 'filter') {
                                          _carouselController!.jumpToPage(0);
                                          type.value = '';
                                        } else {
                                          type.value = 'filter';
                                          _carouselController!.animateToPage(0);
                                          widget.controller!
                                              .switchEffect(normalPath);
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    MomentActions(
                                      label: 'Beautify',
                                      svgUrl: 'assets/svgs/beautify-n.svg',
                                      onClick: () {
                                        if (type.value == 'beautify') {
                                          _carouselController!.jumpToPage(0);
                                          type.value = '';
                                        } else {
                                          type.value = 'beautify';
                                          _carouselController!.animateToPage(0);
                                          widget.controller!
                                              .switchEffect(normalPath);
                                        }
                                      },
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
              Visibility(
                visible: type.value == 'filter' || type.value == 'beautify',
                child: Positioned(
                    top: 0,
                    bottom: 0,
                    left: 10,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            // height: 0,
                            child: CarouselSlider(
                              carouselController: _carouselController,
                              options: CarouselOptions(
                                viewportFraction: 0.7,
                                height: 60,
                                padEnds: false,
                                enlargeCenterPage: true,
                                onPageChanged: (index, _) {
                                  // widget.controller!.switchEffect(
                                  // 'assets/effects/normal.deepar');
                                  widget.controller!.switchEffect(
                                      "assets/effects/${type.value == 'filter' ? filters[index] : beus[index]}");
                                },
                                enableInfiniteScroll: false,
                                scrollDirection: Axis.vertical,
                              ),
                              items: List<Widget>.generate(
                                  type.value == 'filter'
                                      ? filters.length
                                      : beus.length,
                                  (index) => FilterBox(
                                        imageUrl:
                                            "assets/images/${(type.value == 'filter' ? filters[index] : beus[index]).replaceFirst('.deepar', 'p.jpg')}",
                                      )),
                            ),
                          )
                        ])),
              ),
            ]),
          ),
        ),
      ]);
    });
  }
}

class FilterBox extends StatelessWidget {
  final String imageUrl;
  final Function()? onClick;
  const FilterBox({
    super.key,
    required this.imageUrl,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onClick,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage(imageUrl), fit: BoxFit.contain)),
          ),
        ),
      ],
    );
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
