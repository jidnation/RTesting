import 'dart:io';
import 'package:audio_waveforms/src/controllers/player_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reach_me/core/services/moment/querys.dart';
import 'package:reach_me/features/moment/momentControlRoom/models/comment_reply.dart';

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

  RxMap<String, List<GetMomentCommentReply>> repliesBox =
      <String, List<GetMomentCommentReply>>{}.obs;

  Future<List<GetMomentCommentReply>> fetchReplies(
      {required String commentId, required String streakId}) async {
    print("We are called to fetch >>>>>>>>>>>>>>>>>>>>>>>>>>");
    if (repliesBox.isNotEmpty) {
      if (repliesBox.keys.contains(commentId)) {
        return repliesBox[commentId] ?? [];
      } else {
        List<GetMomentCommentReply>? response = await MomentQuery()
            .getStreakCommentReplies(momentId: streakId, commentId: commentId);
        if (response != null) {
          repliesBox.addAll({commentId: response});
        }
        return response ?? [];
      }
    } else {
      List<GetMomentCommentReply>? response = await MomentQuery()
          .getStreakCommentReplies(momentId: streakId, commentId: commentId);
      if (response != null) {
        repliesBox.addAll({commentId: response});
      }
      return response ?? [];
    }
  }
}
