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
  final RxString audioName = ''.obs;
  final RxString caption = ''.obs;
  final RxBool playSound = false.obs;
  final RxBool isRecording = false.obs;
  final RxString mergedVideoPath = ''.obs;
  final Rx<PageController> streakPageController = PageController().obs;
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
      {required String commentId,
      required String streakId,
      bool? isUpdate}) async {
    print(
        "We are called to fetch >>>>>>>>>>> $commentId >>>>>>>>>$streakId >>>>>>");
    if (repliesBox.isNotEmpty) {
      print(":::::::::::::::::::::::::::::::::::::::::::::: 0");
      if (repliesBox.keys.contains(commentId)) {
        print(":::::::::::::::::::::::::::::::::::::::::::::: 1");
        if (isUpdate ?? false) {
          print(":::::::::::::::::::::::::::::::::::::::::::::: 2");

          List<GetMomentCommentReply>? response = await MomentQuery()
              .getStreakCommentReplies(
                  momentId: streakId, commentId: commentId);
          if (response != null) {
            print(":::::::::::::::::::::::::::::::::::::::::::::: 3");

            repliesBox[commentId] = response;
          }
          print(":::::::::::::::::::::::::::::::::::::::::::::: 4");

          return response ?? [];
        } else {
          print(":::::::::::::::::::::::::::::::::::::::::::::: 5");

          return repliesBox[commentId] ?? [];
        }
      } else {
        print(":::::::::::::::::::::::::::::::::::::::::::::: 6");

        List<GetMomentCommentReply>? response = await MomentQuery()
            .getStreakCommentReplies(momentId: streakId, commentId: commentId);
        if (response != null) {
          print(":::::::::::::::::::::::::::::::::::::::::::::: 7");

          repliesBox.addAll({commentId: response});
        }
        print(":::::::::::::::::::::::::::::::::::::::::::::: 8");

        return response ?? [];
      }
    } else {
      print(":::::::::::::::::::::::::::::::::::::::::::::: 9");

      List<GetMomentCommentReply>? response = await MomentQuery()
          .getStreakCommentReplies(momentId: streakId, commentId: commentId);
      if (response != null) {
        print(":::::::::::::::::::::::::::::::::::::::::::::: 10");

        repliesBox.addAll({commentId: response});
      }
      print(":::::::::::::::::::::::::::::::::::::::::::::: 11");

      return response ?? [];
    }
  }

  deleteReply(
      {required String replyId,
      required String momentId,
      required String id,
      required String commentId}) async {
    // repliesBox.forEach((key, value) {
    //   if (key == commentId) {
    //     for (GetMomentCommentReply element in value) {
    //       if (element.replyId == replyId) {
    //         value.remove(element);
    //         return;
    //       }
    //     }
    //   }
    // });
    Get.back();
    await MomentQuery().deleteMomentCommentReply(
      commentId: commentId,
      replyId: replyId,
    );
    fetchReplies(commentId: commentId, streakId: momentId, isUpdate: true);
    momentFeedStore.updateMomentComments(id: id);
  }
}
