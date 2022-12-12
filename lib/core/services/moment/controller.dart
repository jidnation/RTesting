import 'dart:io';

import 'package:get/get.dart';

import '../media_service.dart';

class MomentController extends GetxController {
  final RxString audioUrl = ''.obs;
  final RxString audioFilePath = ''.obs;
  // final RxString videoFilePath = ''.obs;
  // final RxString noAudioVideoFilePath = ''.obs;
  // final RxString videoUrl = ''.obs;
  final RxInt endTime = 0.obs;

  getAudioUrl() async {
    if (audioFilePath.isNotEmpty) {
      // noAudioVideoFilePath(
      //     await MediaService().removeAudio(filePath: videoFilePath.value));
      File cutFile = await MediaService().audioCutter(
        audioPath: audioFilePath.value,
        endTime: endTime.value,
      );
      print('..... converting.......');
      audioUrl(await MediaService().urlConverter(filePath: cutFile.path));
      // videoUrl(await MediaService()
      //     .urlConverter(filePath: noAudioVideoFilePath.value));
      print('..... converting done.......$audioUrl');
    }
  }

  clearPostingData() {
    audioUrl('');
    audioFilePath('');
    endTime(0);
  }
}
