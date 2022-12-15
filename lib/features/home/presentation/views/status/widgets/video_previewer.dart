import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/features/home/presentation/views/status/widgets/user_posting.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../core/components/snackbar.dart';
import '../../../../../../core/models/file_result.dart';
import '../../../../../../core/services/media_service.dart';
import '../../../../../../core/services/moment/querys.dart';
import '../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/dimensions.dart';
import '../../../../../../core/utils/file_url_converter.dart';
import 'moment_actions.dart';
import 'moment_preview_editor.dart';

class VideoPreviewer extends StatefulHookWidget {
  final VideoPlayerController videoController;
  final File videoFile;
  const VideoPreviewer(
      {Key? key, required this.videoController, required this.videoFile})
      : super(key: key);

  @override
  State<VideoPreviewer> createState() => _VideoPreviewerState();
}

class _VideoPreviewerState extends State<VideoPreviewer> {
  @override
  void dispose() {
    widget.videoController.dispose();
    super.dispose();
  }

  bool isPlaying = false;
  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    TextEditingController textController = useTextEditingController();
    widget.videoController.addListener(() {
      if (widget.videoController.value.isPlaying) {
        setState(() {
          isPlaying = true;
        });
      } else {
        setState(() {
          isPlaying = false;
        });
      }
    });
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: AspectRatio(
              aspectRatio: widget.videoController.value.aspectRatio,
              child: Stack(children: [
                VideoPlayer(widget.videoController),
                Positioned(
                    top: size.height * 0.42,
                    right: size.width * 0.42,
                    child: InkWell(
                      onTap: () async {
                        isPlaying
                            ? widget.videoController.pause()
                            : widget.videoController.play();
                      },
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 50,
                      ),
                    )),
                Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              RouteNavigators.pop(context);
                            },
                            child: Container(
                              height: 46,
                              width: 46,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: SvgPicture.asset(
                                'assets/svgs/back.svg',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          CustomText(
                            text: 'Video Preview',
                            color: Colors.black.withOpacity(0.4),
                            size: 15,
                          ),
                          const SizedBox(),
                        ])),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          MomentActions(
                            label: 'Filters',
                            svgUrl: 'assets/svgs/filter-n.svg',
                          ),
                          SizedBox(height: 20),
                          MomentActions(
                            label: 'Voice over',
                            svgUrl: 'assets/svgs/mic.svg',
                          ),
                        ]),
                  ),
                ),
              ]),
            ),
          ),
          SizedBox(height: getScreenHeight(10)),
          Padding(
            padding: EdgeInsets.only(
              left: getScreenWidth(25),
              right: getScreenWidth(25),
              top: getScreenHeight(30),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    const MomentPreviewEditor(
                      label: 'Sticker',
                      icon: Icons.emoji_emotions_outlined,
                    ),
                    SizedBox(width: getScreenWidth(20)),
                    const MomentPreviewEditor(
                      label: 'Pen',
                      icon: Icons.edit,
                    ),
                    SizedBox(width: getScreenWidth(20)),
                    InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          Container(
                            height: 150,
                            padding: const EdgeInsets.only(
                              top: 10,
                              right: 15,
                              left: 15,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25),
                              ),
                            ),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.keyboard_double_arrow_down,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                  Row(children: [
                                    Expanded(
                                      child: CustomRoundTextField(
                                        hintText: 'Enter Caption',
                                        autoFocus: true,
                                        controller: textController,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        momentCtrl.caption(
                                            textController.text.trim());
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 30,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppColors.black,
                                        ),
                                        child: const CustomText(
                                          text: 'Add',
                                          color: Colors.white,
                                          weight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ]),
                                  const SizedBox(),
                                ]),
                          ),
                        );
                        // CustomBottomSheet.open(context,
                        //     child: Container(
                        //       height: 200,
                        //       padding: const EdgeInsets.only(
                        //         top: 10,
                        //         right: 15,
                        //         left: 15,
                        //       ),
                        //       decoration: const BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.vertical(
                        //           top: Radius.circular(25),
                        //         ),
                        //       ),
                        //       child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: const [
                        //             Icon(
                        //               Icons.keyboard_double_arrow_down,
                        //               color: Colors.grey,
                        //               size: 30,
                        //             ),
                        //             CustomRoundTextField(),
                        //             SizedBox(),
                        //           ]),
                        //     ));
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/text.png',
                              height: 25,
                              width: 25,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 3),
                            const CustomText(
                              text: 'Add Caption',
                              color: Colors.white,
                              weight: FontWeight.w600,
                              size: 9.44,
                            )
                          ]),
                    )
                  ]),
                  Visibility(
                    visible: !isUploading,
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          isUploading = true;
                        });
                        if (momentCtrl.audioFilePath.value.isNotEmpty) {
                          var noAudioFile = await MediaService()
                              .removeAudio(filePath: widget.videoFile.path);
                          FileResult fileResult = FileResult(path: noAudioFile);
                          FileResult vFile = await MediaService()
                              .compressVideo(file: fileResult);
                          String? videoUrl = await FileConverter()
                              .convertMe(filePath: vFile.path);
                          if (videoUrl != null) {
                            var res = await MomentQuery.postMoment(
                                videoMediaItem: videoUrl);
                            if (res) {
                              Snackbars.success(
                                context,
                                message: 'Moment successfully created',
                                milliseconds: 1300,
                              );
                              momentCtrl.clearPostingData();
                              RouteNavigators.pop(context);
                            } else {
                              Snackbars.error(
                                context,
                                message: 'Operation Failed, Try again.',
                                milliseconds: 1400,
                              );
                            }
                            setState(() {
                              isUploading = false;
                            });
                          }
                        }
                      },
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
                  ),
                  if (isUploading)
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        color: AppColors.primaryColor,
                      ),
                    )
                ]),
          ),
        ]),
      ),
    );
  }
}