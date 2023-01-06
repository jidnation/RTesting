import 'package:flutter/material.dart';
import 'package:reach_me/features/timeline/query.dart';
import 'package:reach_me/features/timeline/timeline_feed.dart';
import 'package:uuid/uuid.dart';

import '../home/data/models/post_model.dart' as pt;
import 'models/post_feed.dart';

class TimeLineFeedStore extends ValueNotifier<List<TimeLineModel>> {
  //creating a singleton class
  TimeLineFeedStore._sharedInstance() : super(<TimeLineModel>[]);
  static final TimeLineFeedStore _shared = TimeLineFeedStore._sharedInstance();

  factory TimeLineFeedStore() => _shared;

  final TimeLineQuery momentQuery = TimeLineQuery();

  int get length => value.length;
  final TimeLineQuery timeLineQuery = TimeLineQuery();

  bool _gettingPosts = false;
  bool get gettingPosts => _gettingPosts;

  initialize() async {
    _gettingPosts = true;
    List<GetPostFeed>? response = await timeLineQuery.getAllPostFeeds();
    if (response != null) {
      for (GetPostFeed postFeed in response) {
        Post post = postFeed.post!;
        value.add(TimeLineModel(
            getPostFeed: postFeed,
            nLikes: post.nLikes!,
            nComment: post.nComments!,
            isLiked: post.isLiked!,
            videoLink: post.videoMediaItem!));
      }
      postStore.initialize(value);
    }
    _gettingPosts = false;
    notifyListeners();
  }

  pt.PostFeedModel getPostModel({required TimeLineModel timeLineModel}) {
    ErProfile? postOwner = timeLineModel.getPostFeed.post?.postOwnerProfile;
    ErProfile? feedOwner = timeLineModel.getPostFeed.feedOwnerProfile;
    Post? postD = timeLineModel.getPostFeed.post;
    ErProfile? voterProfile = timeLineModel.getPostFeed.voterProfile;
    pt.PostFeedModel postFeedModel = pt.PostFeedModel(
      firstName: postOwner!.firstName,
      lastName: postOwner.lastName,
      username: postOwner.username,
      postId: postD!.postId,
      feedOwnerId: feedOwner!.authId,
      location: postOwner.location,
      profilePicture: postOwner.profilePicture,
      verified: postOwner.verified,
      post: pt.PostModel(
        authId: postD.authId,
        repostedPostOwnerId: postD.repostedPostOwnerId,
        repostedPostId: postD.repostedPostId,
        postRating: postD.postRating,
        createdAt: postD.createdAt,
        isVoted: postD.isVoted,
        isLiked: postD.isLiked,
        isRepost: postD.isRepost,
        videoMediaItem: postD.videoMediaItem,
        audioMediaItem: postD.audioMediaItem,
        commentOption: postD.commentOption,
        content: postD.content,
        edited: postD.edited,
        hashTags: postD.hashTags,
        imageMediaItems: postD.imageMediaItems,
        location: postD.location,
        mentionList: postD.mentionList,
        nComments: postD.nComments,
        nDownvotes: postD.nDownvotes,
        nUpvotes: postD.nUpvotes,
        nLikes: postD.nLikes,
        postSlug: postD.postSlug,
        postOwnerProfile: pt.PostProfileModel(
            authId: postD.postOwnerProfile!.authId,
            firstName: postD.postOwnerProfile!.firstName,
            lastName: postD.postOwnerProfile!.lastName,
            username: postD.postOwnerProfile!.username,
            location: postD.postOwnerProfile!.location,
            profilePicture: postD.postOwnerProfile!.profilePicture,
            verified: postD.postOwnerProfile!.verified,
            profileSlug: postD.postOwnerProfile!.profileSlug),
      ),
      reachingRelationship: timeLineModel.getPostFeed.reachingRelationship,
      createdAt: timeLineModel.getPostFeed.createdAt,
      updatedAt: timeLineModel.getPostFeed.updatedAt,
      // voterProfile: pt.PostProfileModel(
      //     authId: voterProfile!.authId,
      //     firstName: voterProfile.firstName,
      //     lastName: voterProfile.lastName,
      //     username: voterProfile.username,
      //     location: voterProfile.location,
      //     profilePicture: voterProfile.profilePicture,
      //     verified: voterProfile.verified,
      //     profileSlug: voterProfile.profileSlug),
    );
    return postFeedModel;
  }
}

class TimeLineModel {
  final GetPostFeed getPostFeed;
  int nLikes;
  bool isLiked;
  String videoLink;
  int nComment;
  final String id;
  TimeLineModel(
      {required this.getPostFeed,
      required this.nLikes,
      required this.videoLink,
      required this.nComment,
      required this.isLiked})
      : id = const Uuid().v4();
}
