import 'package:flutter/material.dart';
import 'package:reach_me/features/timeline/models/post_feed.dart';
import 'package:reach_me/features/timeline/query.dart';
import 'package:reach_me/features/timeline/timeline_control_room.dart';
import 'package:reach_me/features/timeline/timeline_feed.dart';

import '../../core/components/snackbar.dart';

class PostStore extends ValueNotifier<List<CustomPostModel>> {
  //creating a singleton class
  PostStore._sharedInstance() : super(<CustomPostModel>[]);
  static final PostStore _shared = PostStore._sharedInstance();

  factory PostStore() => _shared;

  final TimeLineQuery timeLineQuery = TimeLineQuery();

  initialize(List<TimeLineModel> timelinePosts) {
    for (TimeLineModel postFeed in timelinePosts) {
      Post post = postFeed.getPostFeed.post!;
      value.add(CustomPostModel(postFeed.id, post: post));
    }
    notifyListeners();
  }

  likePost(String id) async {
    List<CustomPostModel> currentData = value;
    CustomPostModel actualModel =
        currentData.firstWhere((element) => element.id == id);
    String postID = actualModel.post.postId!;
    if (!actualModel.post.isLiked!) {
      actualModel.post.isLiked = true;
      actualModel.post.nLikes = actualModel.post.nLikes! + 1;
      notifyListeners();
      bool response = await timeLineQuery.likePost(postId: postID);
      if (response) {
        updateTimeLine(id);
      }
    } else {
      actualModel.post.isLiked = false;
      actualModel.post.nLikes = actualModel.post.nLikes! - 1;
      notifyListeners();
      bool response =
          await timeLineQuery.unlikePost(postId: actualModel.post.postId!);
      if (response) {
        updateTimeLine(id);
      }
    }
  }

  votePost(BuildContext context,
      {required String id, required String voteType}) async {
    List<CustomPostModel> currentData = value;
    CustomPostModel actualModel =
        currentData.firstWhere((element) => element.id == id);
    String postID = actualModel.post.postId!;

    if (voteType.toLowerCase() == 'downvote') {
      bool? res = await getReachRelationship(
          usersId: actualModel.post.postOwnerProfile!.authId!, type: 'reacher');
      // TimeLineModel timeLineModel = timeLineFeedStore.getModel(id);
      if (res != null && res) {
        bool response = await timeLineQuery.votePost(
          postId: postID,
          voteType: voteType,
        );
        if (response) {
          timeLineFeedStore.refreshFeed2(context);
          voteType.toLowerCase() == 'upvote'
              ? Snackbars.success(
                  context,
                  message: 'You have successfully shouted up this post.',
                  milliseconds: 1300,
                )
              : Snackbars.success(
                  context,
                  message: 'You have successfully shouted down this post.',
                  milliseconds: 1300,
                );
        }
        if (voteType.toLowerCase() == 'downvote') {
          timeLineFeedStore.removePost(context, id);
        }
      } else {
        Snackbars.error(
          context,
          message: 'Operation failed, This user is not reaching you.',
          milliseconds: 1300,
        );
      }
    } else {
      bool response = await timeLineQuery.votePost(
        postId: postID,
        voteType: voteType,
      );
      if (response) {
        timeLineFeedStore.refreshFeed2(context);
        Snackbars.success(
          context,
          message:
              'You have successfully shouted ${voteType.toLowerCase() == 'upvote' ? 'up' : 'down'} this post.',
          milliseconds: 1300,
        );
      }
      if (voteType.toLowerCase() == 'downvote') {
        timeLineFeedStore.removePost(context, id);
      }
    }
  }

  updateTimeLine(String id) async {
    List<CustomPostModel> currentData = value;
    CustomPostModel actualModel =
        currentData.firstWhere((element) => element.id == id);
    String postID = actualModel.post.postId!;
    Post? response = await timeLineQuery.getPost(postId: postID);
    if (response != null) {
      actualModel.post.isLiked = response.isLiked!;
      actualModel.post.nLikes = response.nLikes!;
      actualModel.post.nUpvotes = response.nUpvotes!;
      actualModel.post.nDownvotes = response.nDownvotes!;
      actualModel.post.isVoted = response.isVoted!;
      actualModel.post.nComments = response.nComments!;
    }
    notifyListeners();
  }

  // updatePostList(String id, {required Post post}) {
  //   List<CustomPostModel> currentData = value;
  //   currentData.insert(0, CustomPostModel(id, post: post));
  //   notifyListeners();
  // }

  updatePostActions(List<TimeLineModel> posts) {
    value.clear();
    for (TimeLineModel postFeed in posts) {
      Post post = postFeed.getPostFeed.post!;
      value.add(CustomPostModel(postFeed.id, post: post));
    }
    notifyListeners();
  }

  Future<bool?> getReachRelationship(
      {required String usersId, required String type}) async {
    bool? response = await timeLineQuery.getReachingRelationship(
      userId: usersId,
      type: type,
    );
    return response;
  }
}

class CustomPostModel {
  final Post post;
  final String id;

  CustomPostModel(this.id, {required this.post});
}
