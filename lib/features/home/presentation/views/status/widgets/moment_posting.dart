import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/dimensions.dart';
import 'status_widgets.dart';

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

String selectedTime = '15s';

class _MomentPostingState extends State<MomentPosting> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    widget.controller!.setFlashMode(FlashMode.off);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                        Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: getScreenWidth(126),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/music-note.svg',
                                  height: 20,
                                  width: 20,
                                ),
                                const CustomText(
                                  text: 'Add Sound',
                                  size: 12.44,
                                  weight: FontWeight.w700,
                                  color: Colors.white,
                                )
                              ]),
                        ),
                        InkWell(
                          onTap: () async {
                            if (widget.controller!.value.flashMode ==
                                FlashMode.off) {
                              widget.controller!.setFlashMode(FlashMode.always);
                              print(
                                  '...............${widget.controller!.value.flashMode}');
                            } else {
                              widget.controller!.setFlashMode(FlashMode.off);
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: widget.controller!.value.flashMode ==
                                      FlashMode.off
                                  ? Colors.black.withOpacity(0.4)
                                  : Colors.white,
                            ),
                            child: SvgPicture.asset(
                              'assets/svgs/flash-icon.svg',
                              height: 10,
                              color: widget.controller!.value.flashMode ==
                                      FlashMode.off
                                  ? Colors.white
                                  : Colors.black,
                              width: 10,
                              // fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ]),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        MomentActions(
                          label: 'Speed',
                          svgUrl: 'assets/svgs/speeding.svg',
                        ),
                        SizedBox(height: 20),
                        MomentActions(
                          label: 'Filters',
                          svgUrl: 'assets/svgs/filter-n.svg',
                        ),
                        SizedBox(height: 20),
                        MomentActions(
                          label: 'Beautify',
                          svgUrl: 'assets/svgs/beautify-n.svg',
                        ),
                        SizedBox(height: 20),
                        MomentActions(
                          label: 'Timer',
                          svgUrl: 'assets/svgs/timer-n.svg',
                        ),
                      ]),
                ),
                Positioned(
                    bottom: 70,
                    right: 0,
                    left: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MomentPostingTimer(
                            time: '3m',
                            isSelected: selectedTime == '3m',
                            onClick: () {
                              setState(() {
                                selectedTime = '3m';
                              });
                            },
                          ),
                          const SizedBox(width: 5),
                          MomentPostingTimer(
                            time: '60s',
                            isSelected: selectedTime == '60s',
                            onClick: () {
                              setState(() {
                                selectedTime = '60s';
                              });
                            },
                          ),
                          const SizedBox(width: 5),
                          MomentPostingTimer(
                            time: '15s',
                            isSelected: selectedTime == '15s',
                            onClick: () {
                              setState(() {
                                selectedTime = '15s';
                              });
                            },
                          )
                        ]))
              ]),
            ),
          ),
        ),
      ),
    ]);
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
