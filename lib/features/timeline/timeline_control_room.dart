import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/features/timeline/query.dart';
import 'package:reach_me/features/timeline/timeline_feed.dart';
import 'package:uuid/uuid.dart';

import '../../core/components/snackbar.dart';
import '../../core/services/api/api_client.dart';
import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/app_globals.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/custom_text.dart';
import '../../core/utils/dialog_box.dart';
import '../../core/utils/dimensions.dart';
import '../../core/utils/file_utils.dart';
import '../../core/utils/loader.dart';
import '../chat/presentation/views/msg_chat_interface.dart';
import '../home/data/models/post_model.dart' as pt;
import '../home/data/models/status.model.dart';
import '../home/data/repositories/social_service_repository.dart';
import '../home/data/repositories/user_repository.dart';
import '../home/presentation/views/post_reach.dart';
import 'models/post_feed.dart';

class TimeLineFeedStore extends ValueNotifier<List<TimeLineModel>> {
  //creating a singleton class
  TimeLineFeedStore._sharedInstance() : super(<TimeLineModel>[]);
  static final TimeLineFeedStore _shared = TimeLineFeedStore._sharedInstance();

  factory TimeLineFeedStore() => _shared;

  final TimeLineQuery momentQuery = TimeLineQuery();

  int get length => value.length;
  final TimeLineQuery timeLineQuery = TimeLineQuery();

  final List<String> _availablePostIds = [];

  List<StatusModel> _myStatus = <StatusModel>[];
  List<StatusModel> get myStatus => _myStatus;

  List<StatusFeedResponseModel> _userStatus = <StatusFeedResponseModel>[];
  List<StatusFeedResponseModel> get userStatus => _userStatus;

  List<StatusFeedResponseModel> _mutedStatus = <StatusFeedResponseModel>[];
  List<StatusFeedResponseModel> get mutedStatus => _mutedStatus;

  bool _gettingPosts = false;
  bool get gettingPosts => _gettingPosts;

  initialize() async {
    _gettingPosts = true;
    List<GetPostFeed>? response = await timeLineQuery.getAllPostFeeds();
    if (response != null) {
      for (GetPostFeed postFeed in response) {
        Post post = postFeed.post!;
        _availablePostIds.add(post.postId!);
        value.add(TimeLineModel(
          getPostFeed: postFeed,
          isShowing: post.isVoted!.toLowerCase().trim() != 'downvote',
        ));
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
      postOwnerId: postOwner.authId,
      profilePicture: postOwner.profilePicture,
      verified: postOwner.verified,
      post: pt.PostModel(
        repostedPost: timeLineModel.getPostFeed.post!.repostedPost != null
            ? pt.PostModel(
                authId: postD.repostedPost?.authId,
                repostedPostOwnerId: postD.repostedPost?.repostedPostOwnerId,
                repostedPostId: postD.repostedPost?.repostedPostId,
                postRating: postD.repostedPost?.postRating,
                createdAt: postD.repostedPost?.createdAt,
                isVoted: postD.repostedPost?.isVoted,
                isLiked: postD.repostedPost?.isLiked,
                isRepost: postD.repostedPost?.isRepost,
                videoMediaItem: postD.repostedPost?.videoMediaItem,
                audioMediaItem: postD.repostedPost?.audioMediaItem,
                commentOption: postD.repostedPost?.commentOption,
                content: postD.repostedPost?.content,
                edited: postD.repostedPost?.edited,
                hashTags: postD.repostedPost?.hashTags,
                imageMediaItems: postD.repostedPost?.imageMediaItems,
                location: postD.repostedPost?.location,
                mentionList: postD.repostedPost?.mentionList,
                nComments: postD.repostedPost?.nComments,
                nDownvotes: postD.repostedPost?.nDownvotes,
                nUpvotes: postD.repostedPost?.nUpvotes,
                nLikes: postD.repostedPost?.nLikes,
                postSlug: postD.repostedPost?.postSlug,
                postOwnerProfile: postD.repostedPost!.postOwnerProfile != null
                    ? pt.PostProfileModel(
                        authId: postD.repostedPost!.postOwnerProfile!.authId,
                        firstName:
                            postD.repostedPost!.postOwnerProfile!.firstName,
                        lastName:
                            postD.repostedPost!.postOwnerProfile!.lastName,
                        username:
                            postD.repostedPost!.postOwnerProfile!.username,
                        location:
                            postD.repostedPost!.postOwnerProfile!.location,
                        profilePicture: postD
                            .repostedPost!.postOwnerProfile!.profilePicture,
                        verified:
                            postD.repostedPost!.postOwnerProfile!.verified,
                        profileSlug:
                            postD.repostedPost!.postOwnerProfile!.profileSlug)
                    : null,
              )
            : null,
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
        repostedPostOwnerProfile: postD.repostedPostOwnerProfile != null
            ? pt.PostProfileModel(
                authId: postD.repostedPostOwnerProfile!.authId,
                firstName: postD.repostedPostOwnerProfile!.firstName,
                lastName: postD.repostedPostOwnerProfile!.lastName,
                username: postD.repostedPostOwnerProfile!.username,
                location: postD.repostedPostOwnerProfile!.location,
                profilePicture: postD.repostedPostOwnerProfile!.profilePicture,
                verified: postD.repostedPostOwnerProfile!.verified,
                profileSlug: postD.repostedPostOwnerProfile!.profileSlug)
            : null,
      ),
      reachingRelationship: timeLineModel.getPostFeed.reachingRelationship,
      createdAt: timeLineModel.getPostFeed.createdAt,
      updatedAt: timeLineModel.getPostFeed.updatedAt,
      voterProfile: voterProfile != null
          ? pt.PostProfileModel(
              authId: voterProfile.authId,
              firstName: voterProfile.firstName,
              lastName: voterProfile.lastName,
              username: voterProfile.username,
              location: voterProfile.location,
              profilePicture: voterProfile.profilePicture,
              verified: voterProfile.verified,
              profileSlug: voterProfile.profileSlug)
          : null,
    );
    return postFeedModel;
  }

  removePost(BuildContext context, String id, {bool? isDelete}) {
    List<TimeLineModel> currentPosts = value;
    currentPosts.removeWhere((element) => element.id == id);
    if (isDelete ?? false) {
      Snackbars.success(
        context,
        message: 'You have successfully delete this post.',
        milliseconds: 1300,
      );
    }
    notifyListeners();
  }

  // updateTimeLine() async {
  //   List<GetPostFeed>? response = await timeLineQuery.getAllPostFeeds();
  //   if (response != null) {
  //     for (GetPostFeed postFeed in response) {
  //       Post post = postFeed.post!;
  //       if (!_availablePostIds.contains(post.postId)) {
  //         value.insert(
  //             0,
  //             TimeLineModel(
  //               getPostFeed: postFeed,
  //               isShowing: post.isVoted!.toLowerCase().trim() != 'downvote',
  //             ));
  //         postStore.updatePostList(value[0].id, post: post);
  //       }
  //     }
  //   }
  //   notifyListeners();
  // }

  pt.PostFeedModel getPostModelById(String timeLineId) {
    List<TimeLineModel> currentPosts = value;
    TimeLineModel actualModel =
        currentPosts.firstWhere((element) => element.id == timeLineId);
    return getPostModel(timeLineModel: actualModel);
  }

  getMyStatus() async {
    Either<String, List<StatusModel>>? response =
        await timeLineQuery.getAllStatus(pageLimit: 50, pageNumber: 1);
    if (response!.isRight()) {
      response.forEach((r) {
        _myStatus = r;
      });
      notifyListeners();
    }
  }

  getUserStatus() async {
    Either<String, List<StatusFeedResponseModel>>? response =
        await SocialServiceRepository()
            .getStatusFeed(pageLimit: 50, pageNumber: 1);
    if (response.isRight()) {
      response.forEach((r) {
        _userStatus = r;
        print("::::::::: am here boss :::::ddddddd::  $_userStatus");
      });
      getMutedStatus();
      notifyListeners();
    }
  }

  getMutedStatus() {
    for (StatusFeedResponseModel actualStatus in _userStatus) {
      List<StatusFeedModel> statusList = actualStatus.status!;
      for (StatusFeedModel status in statusList) {
        if (status.status?.isMuted ?? false) {
          _mutedStatus.add(actualStatus);
          _userStatus.remove(actualStatus);
        }
        break;
      }
      _mutedStatus.toSet();
    }
    notifyListeners();
  }

  TimeLineModel getModel(String id) {
    List<TimeLineModel> currentData = value;
    return currentData.firstWhere((element) => element.id == id);
  }

  refreshFeed(RefreshController refreshController) async {
    List<GetPostFeed>? posts = await timeLineQuery.getAllPostFeeds();
    getUserStatus();
    getMyStatus();
    if (posts != null) {
      value.clear();
      for (GetPostFeed element in posts) {
        value.add(TimeLineModel(
          getPostFeed: element,
          isShowing: element.post!.isVoted!.toLowerCase().trim() != 'downvote',
        ));
      }
      postStore.updatePostActions(value);
      refreshController.refreshCompleted();
    }
    notifyListeners();
  }

  refreshFeed2(BuildContext context, {bool? isTextEditing}) async {
    List<GetPostFeed>? posts = await timeLineQuery.getAllPostFeeds();
    getUserStatus();
    getMyStatus();
    if (posts != null) {
      value.clear();
      for (GetPostFeed element in posts) {
        value.add(TimeLineModel(
          getPostFeed: element,
          isShowing: element.post!.isVoted!.toLowerCase().trim() != 'downvote',
        ));
      }
      postStore.updatePostActions(value);
      if (isTextEditing ?? false) {
        Snackbars.success(
          context,
          message: 'You have successfully edit your post',
          milliseconds: 1500,
        );
      }
    }
    notifyListeners();
  }

  ///
  /// for post reach page
  ///
  /// {"status":"success","message":"done","data":{"key":"9b6e0b5e-9f82-4377-a47d-f7fb2bcee899.jpg","signedUrl":"https://reachme-09128734.s3.eu-west-2.amazonaws.com/9b6e0b5e-9f82-4377-a47d-f7fb2bcee899.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA3DPQXB5JOXEIZCG3%2F20230107%2Feu-west-2%2Fs3%2Faws4_request&X-Amz-Date=20230107T165816Z&X-Amz-Expires=300&X-Amz-Signature=e1ef146688a91e0f9126d72fc028441b1a4441a046d7463600a113f8ab63dee9&X-Amz-SignedHeaders=host","link":"https://reachme-09128734.s3.eu-west-2.amazonaws.com/9b6e0b5e-9f82-4377-a47d-f7fb2bcee899.jpg"}}
  createMediaPost(BuildContext context,
      {required List<UploadFileDto> mediaList}) async {
    CustomDialog.openDialogBox(
        height: SizeConfig.screenHeight * 0.9,
        width: SizeConfig.screenWidth,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              RLoader(
                'Posting reach',
                textStyle: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              CustomText(
                text: 'Please wait....',
                color: AppColors.primaryColor,
                weight: FontWeight.w500,
                size: 13,
              )
            ]));
    List<String> imageUrlList = [];
    String videoUrl = '';
    String audioUrl = '';

    for (UploadFileDto element in mediaList) {
      var response = await ApiClient().getSignedURL(element.file);
      if (response['status'] == 'success') {
        String link = response["data"]["link"];
        final uploadResponse = await UserRepository().uploadPhoto(
          url: response["data"]['signedUrl'],
          file: element.file,
        );
        if (uploadResponse.toString() == 'Right(Upload successful)') {
          if (FileUtils.fileType(link) == 'image') {
            imageUrlList.add(link);
          } else if (FileUtils.fileType(link) == 'audio') {
            audioUrl = link;
          } else {
            videoUrl = link;
          }
        }
      }
      print(">>>>>>>>>> from media upload ::::: ${response["data"]["link"]}");
    }

    Either<String, pt.PostModel> response = await SocialServiceRepository()
        .createPost(
            imageMediaItems: imageUrlList.isNotEmpty ? imageUrlList : null,
            videoMediaItem: videoUrl.isNotEmpty ? videoUrl : null,
            audioMediaItem: audioUrl.isNotEmpty ? audioUrl : null,
            commentOption: globals.postCommentOption,
            content: globals.postContent,
            location: globals.location,
            mentionList: globals.mentionList,
            postRating: globals.postRating);
    if (response.isRight()) {
      refreshFeed2(context);
      Snackbars.success(context, message: 'Your reach has been posted');
      Get.close(2);
    }
  }

  // Snackbars.success(context,
  // message: 'Your reach has been posted');

  messageUer(BuildContext context, {required String email}) async {
    Either<String, User> response =
        await UserRepository().getUserProfile(email: email);
    User? userInfo;
    if (response.isRight()) {
      response.forEach((r) {
        userInfo = r;
      });
      if (userInfo != null) {
        RouteNavigators.route(
            context, MsgChatInterface(recipientUser: userInfo));
      }
    }
  }

  editPost(BuildContext context,
      {required String content, required String postId}) async {
    final Either<String, pt.PostModel> response =
        await SocialServiceRepository().editContent(
      content: content,
      postId: postId,
    );
    if (response.isRight()) {
      refreshFeed2(context, isTextEditing: true);
      Get.back();
    }
  }
}

class TimeLineModel {
  final GetPostFeed getPostFeed;
  bool isShowing;
  final String id;
  TimeLineModel({required this.getPostFeed, required this.isShowing})
      : id = const Uuid().v4();
}
