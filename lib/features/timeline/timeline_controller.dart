import 'package:get/get.dart';
import 'package:reach_me/features/timeline/timeline_control_room.dart';

class TimeLineController extends GetxController {
  RxList<CustomCounter> likeBox = <CustomCounter>[].obs;
  RxList<CustomCounter> likeBox2 = <CustomCounter>[].obs;
  RxList<CustomCounter> likeBox3 = <CustomCounter>[].obs;
  RxList<CustomCounter> likeUpBox = <CustomCounter>[].obs;
  RxList<CustomCounter> likeSavedBox = <CustomCounter>[].obs;
  RxList<CustomCounter> likeDownBox = <CustomCounter>[].obs;
  RxBool isScrolling = false.obs;

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
    CustomCounter actualModel = getExactBox(type).firstWhere((element) => element.id == id);
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
}
