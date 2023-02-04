import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_me/features/timeline/timeline_control_room.dart';

import '../../core/components/snackbar.dart';
import '../../core/services/navigation/navigation_service.dart';

class TimeLineController extends GetxController {
  RxList<CustomCounter> likeBox = <CustomCounter>[].obs;
  RxList<CustomCounter> likeBox2 = <CustomCounter>[].obs;
  RxList<CustomCounter> likeBox3 = <CustomCounter>[].obs;
  RxList<CustomCounter> likeUpBox = <CustomCounter>[].obs;
  RxList<CustomCounter> likeSavedBox = <CustomCounter>[].obs;
  RxList<CustomCounter> likeDownBox = <CustomCounter>[].obs;
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
      'save': likeSavedBox,
    };
    return mapper[type];
  }

  likePost({required String id, required String type}) {
    LikeModel likeModel = LikeModel(nLikes: 0, isLiked: false);
    CustomCounter actualModel =
        getExactBox(type).firstWhere((element) => element.id == id);
    int index = getExactBox(type).indexOf(actualModel);
    // int index2 = likeBox.indexWhere((element) => element.id == id);

    // likeBox.forEach((key, value) {
    //   if (key == id) {
    if (actualModel.data.isLiked) {
      likeModel.isLiked = false;
      likeModel.nLikes = actualModel.data.nLikes - 1;
    } else {
      likeModel.isLiked = true;
      likeModel.nLikes = actualModel.data.nLikes + 1;
    }

    getExactBox(type)[index] = CustomCounter(id: id, data: likeModel);
    // }
    //   likeBox[key] = likeModel;
    // });
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
}
