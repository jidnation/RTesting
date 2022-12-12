import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/features/home/presentation/views/status/widgets/video_previewer.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../core/services/navigation/navigation_service.dart';

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

      // await videoController!.setLooping(true);
      // await videoController!.play();
      // ClipRRect(
      //   borderRadius: BorderRadius.circular(8.0),
      //   child: AspectRatio(
      //     aspectRatio: videoController!.value.aspectRatio,
      //     child: VideoPlayer(videoController!),
      //   ),
      // )
    }
  }
}
