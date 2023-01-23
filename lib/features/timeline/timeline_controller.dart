import 'package:get/get.dart';
import 'package:reach_me/features/timeline/timeline_control_room.dart';

class TimeLineController extends GetxController {
  RxList<CustomCounter> likeBox = <CustomCounter>[].obs;

  likePost({required String id}) {
    LikeModel likeModel = LikeModel(nLikes: 0, isLiked: false);
    CustomCounter actualModel =
        likeBox.firstWhere((element) => element.id == id);
    int index = likeBox.indexOf(actualModel);
    int index2 = likeBox.indexWhere((element) => element.id == id);

    print("::::::::::: index 1::: $index  :::::::::: index2 :::; $index2");
    // likeBox.forEach((key, value) {
    //   if (key == id) {
    if (actualModel.data.isLiked) {
      likeModel.isLiked = false;
      likeModel.nLikes = actualModel.data.nLikes - 1;
    } else {
      likeModel.isLiked = true;
      likeModel.nLikes = actualModel.data.nLikes + 1;
    }
    likeBox[index] = CustomCounter(id: id, data: likeModel);
    // }
    //   likeBox[key] = likeModel;
    // });
  }

  LikeModel getLikeValues({required String id}) {
    late LikeModel likeValue;
    for (CustomCounter customCounter in likeBox) {
      if (customCounter.id == id) {
        likeValue = customCounter.data;
        return likeValue;
      }
    }
    print("::::::::::>>>><<<< still returning empty}");
    return LikeModel(nLikes: 0, isLiked: false);
  }

  //
  // if (likeBox.isNotEmpty) {
  //   likeValue = likeBox[id] ?? LikeModel(nLikes: 0, isLiked: false);
  //   return likeValue;
  // } else {
  //   return LikeModel(nLikes: 0, isLiked: false);
  // }
  // }

  // add({required Post post, required String id}) {
  //   if (likeBox.isNotEmpty) {
  //     if (likeBox[id] != null) {
  //       likeBox.update(
  //           id,
  //           (value) => LikeModel(
  //               nLikes: post.nLikes ?? 0, isLiked: post.isLiked ?? false));
  //     } else {
  //       likeBox.addAll({
  //         id: LikeModel(
  //             nLikes: post.nLikes ?? 0, isLiked: post.isLiked ?? false)
  //       });
  //     }
  //   } else {
  //     likeBox({
  //       id: LikeModel(nLikes: post.nLikes ?? 0, isLiked: post.isLiked ?? false)
  //     });
  //   }
  // }
}
