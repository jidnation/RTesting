import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/utils/dialog_box.dart';
import 'package:reach_me/features/timeline/timeline_control_room.dart';
import 'dart:ui' as ui;
import '../../core/components/snackbar.dart';
import '../../core/services/moment/querys.dart';
import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/custom_text.dart';
import '../../core/utils/dimensions.dart';
import '../moment/moment_feed.dart';

class TimeLineController extends GetxController {
  RxList<CustomCounter> likeBox = <CustomCounter>[].obs;
  RxList<CustomCounter> likeBox2 = <CustomCounter>[].obs;
  RxList<CustomCounter> likeBox3 = <CustomCounter>[].obs;
  RxList<CustomCounter> likeUpBox = <CustomCounter>[].obs;
  RxList<CustomCounter> likeSavedBox = <CustomCounter>[].obs;
  RxList<CustomCounter> likeDownBox = <CustomCounter>[].obs;
  RxList<CustomCounter> likeCommentBox = <CustomCounter>[].obs;
  RxBool isScrolling = false.obs;
  RxBool currentStatus = false.obs;
  RxString currentId = "".obs;

  RxList<CustomCounter> getExactBox(String type) {
    Map<String, dynamic> mapper = {
      'profile': likeBox2,
      'post': likeBox,
      'likes': likeBox3,
      'upvote': likeUpBox,
      'downvote': likeDownBox,
      'comment': likeCommentBox,
      'save': likeSavedBox,
    };
    return mapper[type];
  }

  likePost(
      {required String id,
      required String type,
      String? postId,
      String? isLikes}) async {
    LikeModel likeModel = LikeModel(nLikes: 0, isLiked: false);
    CustomCounter actualModel =
        getExactBox(type).firstWhere((element) => element.id == id);
    int index = getExactBox(type).indexOf(actualModel);

    if (actualModel.data.isLiked) {
      likeModel.isLiked = false;
      likeModel.nLikes = actualModel.data.nLikes - 1;
      if (postId != null) {
        await MomentQuery().unlikeCommentPost(commentId: id, likeId: isLikes!);
      }
    } else {
      likeModel.isLiked = true;
      likeModel.nLikes = actualModel.data.nLikes + 1;
      if (postId != null) {
        await MomentQuery().likePostComment(commentId: id, postId: postId);
      }
    }
    getExactBox(type)[index] = CustomCounter(id: id, data: likeModel);
    // }
    //   likeBox[key] = likeModel;
    // });
    // }
  }

  LikeModel getLikeValues({required String id, required String type}) {
    late LikeModel likeValue;
    for (CustomCounter customCounter in getExactBox(type)) {
      if (customCounter.id == id) {
        likeValue = customCounter.data;
        return likeValue;
      }
    }
    return LikeModel(nLikes: 0, isLiked: false);
  }

  Future<String> saveImage(BuildContext context, Uint8List? bytes) async {
    await [Permission.storage].request();
    String time = DateTime.now().microsecondsSinceEpoch.toString();
    final name = 'screenshot_${time}_reachme';
    final result = await ImageGallerySaver.saveImage(bytes!, name: name);
    debugPrint("Result ${result['filePath']}");
    Snackbars.success(context, message: 'Image saved to Gallery');
    RouteNavigators.pop(context);
    return result['filePath'];
  }

  void takeScreenShot(context, GlobalKey<State<StatefulWidget>> src) async {
    RenderRepaintBoundary boundary = src.currentContext!.findRenderObject()
        as RenderRepaintBoundary; // the key provided
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    debugPrint("Byte Data: $byteData");
    await saveImage(context, byteData!.buffer.asUint8List());
  }

  replyComment({String? postId, String? commentId}) async {
    String userInput = '';
    CustomDialog.openDialogBox(
        height: 250,
        barrierD: false,
        width: SizeConfig.screenWidth * 0.9,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText(
                text: 'Enter your comment:',
                size: 15,
                weight: FontWeight.w500,
              ),
              const SizedBox(height: 15),
              TextFormField(
                maxLines: 5,
                onChanged: (val) {
                  userInput = val;
                },
                decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey.withOpacity(0.3),
                        ))),
              ),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                    ),
                    child: const CustomText(
                      text: 'cancel',
                      weight: FontWeight.w600,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    var response = await MomentQuery().replyPostComment(
                      postId: postId!,
                      commentId: commentId,
                      content: userInput,
                    );
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green,
                    ),
                    child: const CustomText(
                      text: 'Send',
                      weight: FontWeight.w600,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ])
              // Container(
              //   height: 50,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     borde
              //   ),
              // )
            ]));
  }
}