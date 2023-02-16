import 'dart:io';
import 'package:audio_waveforms/src/controllers/player_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/moment/moment_feed.dart';
import '../media_service.dart';

class MomentController extends GetxController {
  final RxString audioUrl = ''.obs;
  final Rx<PlatformFile> audioFile = PlatformFile(name: "", size: 0).obs;
  final RxString audioFilePath = ''.obs;
  final RxString caption = ''.obs;
  final RxBool playSound = false.obs;
  final RxBool isRecording = false.obs;
  final RxString mergedVideoPath = ''.obs;
  final Rx<GlobalKey<ScaffoldState>?> userBar = GlobalKey<ScaffoldState>().obs;
  final Rx<PlayerController> previewerAudioController = PlayerController().obs;
  final RxInt endTime = 0.obs;
  final RxInt momentCounter = 0.obs;

  getAudioUrl() async {
    if (audioFilePath.isNotEmpty) {
      File cutFile = await MediaService().audioCutter(
        audioPath: audioFilePath.value,
        endTime: endTime.value,
      );
      print('..... converting.......');
      audioUrl(await momentFeedStore.uploadMediaFile(file: cutFile));
      print('..... converting done.......$audioUrl');
    }
  }

  clearPostingData() {
    audioUrl('');
    caption('');
    audioFilePath('');
    endTime(0);
  }
}
