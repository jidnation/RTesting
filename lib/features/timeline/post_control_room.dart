// import 'package:flutter/material.dart';
// import 'package:reach_me/features/timeline/models/post_feed.dart';
// import 'package:reach_me/features/timeline/query.dart';
// import 'package:reach_me/features/timeline/timeline_control_room.dart';
// import 'package:reach_me/features/timeline/timeline_feed.dart';
//
// import '../../core/components/snackbar.dart';
//
// class PostStore extends ValueNotifier<List<CustomPostModel>> {
//   //creating a singleton class
//   PostStore._sharedInstance() : super(<CustomPostModel>[]);
//   static final PostStore _shared = PostStore._sharedInstance();
//
//   factory PostStore() => _shared;
//
//   int get length => value.length;
//
//   final TimeLineQuery timeLineQuery = TimeLineQuery();
//
//   initialize(List<TimeLineModel> timelinePosts) {
//     List<CustomPostModel> latest = <CustomPostModel>[];
//     length > 0 ? value.clear() : null;
//     for (TimeLineModel postFeed in timelinePosts) {
//       Post post = postFeed.getPostFeed.post!;
//       latest.add(CustomPostModel(postFeed.id, post: post));
//     }
//     value = latest;
//     notifyListeners();
//   }
//
//
//
//   // updatePostList(String id, {required Post post}) {
//   //   List<CustomPostModel> currentData = value;
//   //   currentData.insert(0, CustomPostModel(id, post: post));
//   //   notifyListeners();
//   // }
//
//   // updatePostActions(List<TimeLineModel> posts) {
//   //   value.clear();
//   //   for (TimeLineModel postFeed in posts) {
//   //     Post post = postFeed.getPostFeed.post!;
//   //     value.add(CustomPostModel(postFeed.id, post: post));
//   //   }
//   //   notifyListeners();
//   // }
//
// }
//
// // class CustomPostModel {
// //   final Post post;
// //   final String id;
// //
// //   CustomPostModel(this.id, {required this.post});
// // }
