import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_me/core/utils/dialog_box.dart';
import 'package:reach_me/features/moment/user_posting.dart';
import 'package:reach_me/features/moment/video_previewer.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/dimensions.dart';
import '../../../../../../core/utils/loader.dart';

class MomentVideoControl {
  VideoPlayerController? videoController;

  Future<bool> startVideoRecording(
      {required CameraController? videoController}) async {
    if (videoController!.value.isRecordingVideo) {
      // A recording has already started, do nothing.
      return true;
    }
    try {
      await videoController.startVideoRecording();
      return true;
      // setState(() {
      //   _isRecordingInProgress = true;
      //   print(_isRecordingInProgress);
      // });
    } on CameraException catch (e) {
      print('Error starting to record video: $e');
      return false;
    }
  }

  Future<XFile?> stopVideoRecording({
    required CameraController? videoController,
  }) async {
    if (!videoController!.value.isRecordingVideo) {
      return null;
    }
    try {
      XFile file = await videoController.stopVideoRecording();
      // setState(() {
      //   _isRecordingInProgress = false;
      //   print(_isRecordingInProgress);
      // });
      return file;
    } on CameraException catch (e) {
      print('Error stopping video recording: $e');
      return null;
    }
  }

  Future<void> pauseVideoRecording({
    required CameraController? videoController,
  }) async {
    if (!videoController!.value.isRecordingVideo) {
      // Video recording is not in progress
      return;
    }
    try {
      await videoController.pauseVideoRecording();
    } on CameraException catch (e) {
      print('Error pausing video recording: $e');
    }
  }

  Future<void> resumeVideoRecording({
    required CameraController? videoController,
  }) async {
    if (!videoController!.value.isRecordingVideo) {
      // No video recording was in progress
      return;
    }
    try {
      await videoController.resumeVideoRecording();
    } on CameraException catch (e) {
      print('Error resuming video recording: $e');
    }
  }

  Future<void> startVideoPlayer(BuildContext context,
      {required File? videoFile}) async {
    if (videoFile != null) {
      if (momentCtrl.audioFilePath.value.isNotEmpty) {
        CustomDialog.openDialogBox(
            height: SizeConfig.screenHeight * 0.9,
            width: SizeConfig.screenWidth,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  RLoader(
                    'Processing Video',
                    textStyle: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                  CustomText(
                    text: 'Please wait....',
                    color: AppColors.primaryColor,
                    weight: FontWeight.w500,
                    size: 13,
                  )
                ]));

        String timeLimit = '00:00:';
        int time = momentCtrl.endTime.value;
        String videoPath = videoFile.path;
        String audioPath = momentCtrl.audioFilePath.value;
        String outputPath = '/storage/emulated/0/Download/viewer.mp4';
        if (await Permission.storage.request().isGranted) {
          if (time.toInt() < 10) {
            timeLimit = timeLimit + '0' + time.toString();
          } else if (time.toInt() >= 10 && time.toInt() < 60) {
            timeLimit = timeLimit + time.toString();
          } else if (time.toInt() >= 60) {
            int min = time.toInt() ~/ 60;
            int sec = time - (min * 60);
            if (sec.toInt() < 10) {
              timeLimit = '00:' '0$min:' '0' + sec.toString();
            } else {
              timeLimit = '00:' '0$min:' + sec.toString();
            }
          }
          print(
              "::::::::::::::::::::::::::::::::::::::::::::::: the time:  $timeLimit");
          String commandToExecute =
              '-r 15 -f mp4 -i $videoPath -f mp3 -i $audioPath -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -t $timeLimit -y $outputPath';
          print(":::::::::::::::::::::: MERGING STARTED :::::::::::::::");
          File(outputPath).delete();
          // await FFmpegKit.executeAsync(commandToExecute, (session) async {
          //   final ReturnCode? returnCode = await session.getReturnCode();
          //   if (ReturnCode.isSuccess(returnCode)) {
          //     print(":::::::::::::::::::::: MERGING SUCCESS :::::::::::::::");
          //     String file = await MediaService()
          //         .compressMomentVideo(filePath: outputPath);
          //     momentCtrl.mergedVideoPath(file);
          //     videoController = VideoPlayerController.file(File(file));
          //     await videoController!.initialize().then((_) {
          //       RouteNavigators.routeReplace(
          //         context,
          //         VideoPreviewer(
          //           videoFile: File(outputPath),
          //           videoController: videoController!,
          //         ),
          //       );
          //     });
          //     // SUCCESS
          //   } else if (ReturnCode.isCancel(returnCode)) {
          //     // CANCEL
          //   } else {
          //     print(":::::::::::::::::::::: MERGING FAIL :::::::::::::::");

          //     // ERROR
          //   }
          // });
        } else if (await Permission.storage.isPermanentlyDenied) {
          openAppSettings();
        }
      } else {
        videoController = VideoPlayerController.file(videoFile);
        await videoController!.initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized,
          // even before the play button has been pressed.
          // setState(() {});
          RouteNavigators.route(
            context,
            VideoPreviewer(
              videoFile: videoFile,
              videoController: videoController!,
            ),
          );
        });
      }
    }
  }
}
