import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/features/account/presentation/views/account.dart';
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
import 'models/profile_comment_model.dart';

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

  List<StatusFeedResponseModel> _userStatus = List.empty(growable: true);
  List<StatusFeedResponseModel> get userStatus => _userStatus;

  List<StatusFeedResponseModel> _mutedStatus = <StatusFeedResponseModel>[];
  List<StatusFeedResponseModel> get mutedStatus => _mutedStatus;

  bool _gettingPosts = false;
  bool get gettingPosts => _gettingPosts;

  bool _gettingSuggestedUser = false;
  bool get gettingSuggestedUser => _gettingSuggestedUser;

  bool _isPosting = false;
  bool get isPosting => _isPosting;

  List<CustomUser> _suggestedUsers = <CustomUser>[];
  List<CustomUser> get suggestedUser => _suggestedUsers;

  initialize(
      {bool? isTextEditing,
      bool? isPosting,
      bool? isUpvoting,
      bool? isQuoting,
      bool? isRefresh,
      bool? isRefreshing,
      RefreshController? refreshController}) async {
    if (value.isEmpty || (isRefreshing ?? false)) {
      if ((isPosting ?? false) ||
          (isTextEditing ?? false) ||
          (isQuoting ?? false)) {
        // Get.to(() => const TimeLineFeed());
        Get.back();
        _isPosting = true;
      } else {
        ((isUpvoting ?? false) || (isRefresh ?? false))
            ? _isPosting = true
            : _gettingPosts = true;
        // (noReload ?? false) ? _isPosting = true : _gettingPosts = true;
      }
      notifyListeners();
      List<GetPostFeed>? response = await timeLineQuery.getAllPostFeeds();
      List<CustomCounter> likeBoxInfo = [];
      if (response != null) {
        length > 0 ? value.clear() : null;
        if (isTextEditing ?? false) {
          Get.snackbar(
            '',
            '',
            titleText: const SizedBox.shrink(),
            messageText: CustomText(
              text: 'You have successfully edit your post',
              color: const Color(0xFF1C8B43),
              size: getScreenHeight(16),
            ),
            borderWidth: 0.5,
            icon: SvgPicture.asset(
              'assets/svgs/like.svg',
              color: const Color(0xFF1C8B43),
            ),
            backgroundColor: const Color(0xFFE0FFDD),
            borderColor: const Color(0xFF1C8B43),
            borderRadius: 16,
            duration: const Duration(milliseconds: 1500),
          );
        }
        if (isQuoting ?? false) {
          Get.snackbar(
            '',
            '',
            titleText: const SizedBox.shrink(),
            messageText: CustomText(
              text: 'Reach has been quoted on your timeline',
              color: const Color(0xFF1C8B43),
              size: getScreenHeight(16),
            ),
            borderWidth: 0.5,
            icon: SvgPicture.asset(
              'assets/svgs/like.svg',
              color: const Color(0xFF1C8B43),
            ),
            backgroundColor: const Color(0xFFE0FFDD),
            borderColor: const Color(0xFF1C8B43),
            borderRadius: 16,
            duration: const Duration(milliseconds: 1500),
          );
        }
        if (isPosting ?? false) {
          Get.snackbar(
            '',
            '',
            titleText: const SizedBox.shrink(),
            messageText: CustomText(
              text: 'Your reach has been Posted.',
              color: const Color(0xFF1C8B43),
              size: getScreenHeight(16),
            ),
            borderWidth: 0.5,
            icon: SvgPicture.asset(
              'assets/svgs/like.svg',
              color: const Color(0xFF1C8B43),
            ),
            backgroundColor: const Color(0xFFE0FFDD),
            borderColor: const Color(0xFF1C8B43),
            borderRadius: 16,
            duration: const Duration(milliseconds: 1500),
          );
        }
        if (response.isEmpty) {
          getSuggestedUsers();
        }
        for (GetPostFeed postFeed in response) {
          Post post = postFeed.post!;
          _availablePostIds.add(post.postId!);
          value.add(TimeLineModel(
            getPostFeed: postFeed,
            isShowing: post.isVoted!.toLowerCase().trim() != 'downvote' &&
                post.postOwnerProfile != null,
          ));
        }
        if (value.isNotEmpty) {
          for (TimeLineModel element in value) {
            likeBoxInfo.add(CustomCounter(
                id: element.id,
                data: LikeModel(
                  nLikes: element.getPostFeed.post?.nLikes ?? 0,
                  isLiked: element.getPostFeed.post?.isLiked ?? false,
                )));
          }
        }
        timeLineController.likeBox(likeBoxInfo);
        _isPosting = false;
        _gettingPosts = false;
        notifyListeners();
      }
      await getUserStatus();
      await getMyStatus();

      if (isRefresh ?? false) {
        refreshController!.refreshCompleted();
      }
    }
  }

  likePost(String id, {required String type}) async {
    if (type == 'comment') {
    }

    //////////////////////////
    else {
      List<TimeLineModel> currentData = getExactValue(type);
      TimeLineModel actualModel =
          currentData.firstWhere((element) => element.id == id);
      Post post = actualModel.getPostFeed.post!;

      ////////////////////
      if (type == 'likes') {
        currentData.remove(actualModel);
        notifyListeners();
      }

      if (!post.isLiked!) {
        actualModel.getPostFeed.post?.isLiked = true;
        actualModel.getPostFeed.post?.nLikes = post.nLikes! + 1;
        notifyListeners();
        //////
        bool response = await timeLineQuery.likePost(postId: post.postId!);
        if (response) {
          fetchAll(
            isFirst: true,
            isLike: type == 'likes',
            isPost: type == 'profile',
            isUpVoted: type == 'Upvote',
            isDownVoted: type == 'Downvote',
            isSaved: type == 'saved',
          );
        }
      } else {
        actualModel.getPostFeed.post?.isLiked = false;
        actualModel.getPostFeed.post?.nLikes = post.nLikes! - 1;
        notifyListeners();
        bool response = await timeLineQuery.unlikePost(postId: post.postId!);
        if (response) {
          fetchAll(
            isFirst: true,
            isLike: type == 'likes',
            isPost: type == 'profile',
            isUpVoted: type == 'Upvote',
            isDownVoted: type == 'Downvote',
            isSaved: type == 'saved',
          );
        }
      }
    }
  }

  votePost(BuildContext context,
      {required String id,
      required String voteType,
      required String type}) async {
    List<TimeLineModel> currentData = getExactValue(type);
    TimeLineModel actualModel =
        currentData.firstWhere((element) => element.id == id);
    Post post = actualModel.getPostFeed.post!;

    ////downvote
    if (voteType.toLowerCase() == 'downvote') {
      bool? res = await getReachRelationship(
          usersId: post.postOwnerProfile!.authId!, type: 'reacher');

      if (res != null && res) {
        bool response = await timeLineQuery.votePost(
          postId: post.postId!,
          voteType: voteType,
        );

        if (response) {
          type == 'post'
              ? timeLineFeedStore.removePost(context, id, type: type)
              : null;
          actualModel.getPostFeed.post?.isVoted = 'Downvote';
          actualModel.getPostFeed.post!.nDownvotes =
              actualModel.getPostFeed.post!.nDownvotes! + 1;
          notifyListeners();
          initialize(isRefreshing: true);
          fetchAll(isFirst: true);
          Snackbars.success(
            context,
            message: 'You have successfully shouted down this post.',
            milliseconds: 1300,
          );
        } else {
          Get.snackbar(
            '',
            '',
            titleText: const SizedBox.shrink(),
            messageText: CustomText(
              text: 'Unshoutout this post to be able to Shoutdown',
              color: Colors.white,
              size: getScreenHeight(16),
            ),
            borderWidth: 0.5,
            icon: Icon(
              Icons.not_interested_rounded,
              color: Colors.white,
              size: getScreenHeight(24),
            ),
            backgroundColor: const Color(0xFFD83333),
            borderColor: const Color(0xFFD83333).withOpacity(0.7),
            borderRadius: 16,
            duration: const Duration(milliseconds: 1500),
          );
        }
      } else {
        Snackbars.error(
          context,
          message: 'Operation failed, This user is not reaching you.',
          milliseconds: 1300,
        );
      }
    }

    ////upvote
    else {
      if (!(post.isVoted.toString().toLowerCase() == 'upvote')) {
        actualModel.getPostFeed.post?.isVoted = 'Upvote';
        actualModel.getPostFeed.post!.nUpvotes =
            actualModel.getPostFeed.post!.nUpvotes! + 1;
        notifyListeners();

        bool response = await timeLineQuery.votePost(
          postId: post.postId!,
          voteType: voteType,
        );
        if (response) {
          initialize(isUpvoting: true, isRefreshing: true);
          fetchAll(isFirst: true);
          Get.snackbar(
            '',
            '',
            titleText: const SizedBox.shrink(),
            messageText: CustomText(
              text:
                  'You have successfully shouted ${voteType.toLowerCase() == 'upvote' ? 'out' : 'down'} this post.',
              color: const Color(0xFF1C8B43),
              size: getScreenHeight(16),
            ),
            borderWidth: 0.5,
            icon: SvgPicture.asset(
              'assets/svgs/like.svg',
              color: const Color(0xFF1C8B43),
            ),
            backgroundColor: const Color(0xFFE0FFDD),
            borderColor: const Color(0xFF1C8B43),
            borderRadius: 16,
            duration: const Duration(milliseconds: 1500),
          );
        }
      } else {
        deleteVotedPost(postId: post.postId!, id: id, type: type);
      }
      if (voteType.toLowerCase() == 'downvote') {
        timeLineFeedStore.removePost(context, id, type: type);
      }
    }
  }

  Future<bool?> getReachRelationship(
      {required String usersId, required String type}) async {
    bool? response = await timeLineQuery.getReachingRelationship(
      userId: usersId,
      type: type,
    );
    return response;
  }

  pt.PostFeedModel? getPostModel({required TimeLineModel timeLineModel}) {
    ErProfile? postOwner = timeLineModel.getPostFeed.post?.postOwnerProfile;
    ErProfile? feedOwner = timeLineModel.getPostFeed.feedOwnerProfile;
    Post? postD = timeLineModel.getPostFeed.post;
    ErProfile? voterProfile = timeLineModel.getPostFeed.voterProfile;
    pt.PostFeedModel? postFeedModel = postOwner != null
        ? pt.PostFeedModel(
            firstName: postOwner.firstName,
            lastName: postOwner.lastName,
            username: postOwner.username,
            postId: postD!.postId,
            feedOwnerId: feedOwner?.authId,
            location: postOwner.location,
            postOwnerId: postOwner.authId,
            profilePicture: postOwner.profilePicture,
            verified: postOwner.verified,
            post: pt.PostModel(
              repostedPost: timeLineModel.getPostFeed.post!.repostedPost != null
                  ? pt.PostModel(
                      authId: postD.repostedPost?.authId,
                      repostedPostOwnerId:
                          postD.repostedPost?.repostedPostOwnerId,
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
                      postOwnerProfile: postD.repostedPost!.postOwnerProfile !=
                              null
                          ? pt.PostProfileModel(
                              authId:
                                  postD.repostedPost!.postOwnerProfile!.authId,
                              firstName: postD
                                  .repostedPost!.postOwnerProfile!.firstName,
                              lastName: postD
                                  .repostedPost!.postOwnerProfile!.lastName,
                              username: postD
                                  .repostedPost!.postOwnerProfile!.username,
                              location: postD
                                  .repostedPost!.postOwnerProfile!.location,
                              profilePicture: postD.repostedPost!
                                  .postOwnerProfile!.profilePicture,
                              verified: postD
                                  .repostedPost!.postOwnerProfile!.verified,
                              profileSlug: postD
                                  .repostedPost!.postOwnerProfile!.profileSlug)
                          : null,
                    )
                  : null,
              postId: timeLineModel.getPostFeed.post!.postId,
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
              postOwnerProfile: postD.postOwnerProfile != null
                  ? pt.PostProfileModel(
                      authId: postD.postOwnerProfile!.authId,
                      firstName: postD.postOwnerProfile!.firstName,
                      lastName: postD.postOwnerProfile!.lastName,
                      username: postD.postOwnerProfile!.username,
                      location: postD.postOwnerProfile!.location,
                      profilePicture: postD.postOwnerProfile!.profilePicture,
                      verified: postD.postOwnerProfile!.verified,
                      profileSlug: postD.postOwnerProfile!.profileSlug)
                  : null,
              repostedPostOwnerProfile: postD.repostedPostOwnerProfile != null
                  ? pt.PostProfileModel(
                      authId: postD.repostedPostOwnerProfile!.authId,
                      firstName: postD.repostedPostOwnerProfile!.firstName,
                      lastName: postD.repostedPostOwnerProfile!.lastName,
                      username: postD.repostedPostOwnerProfile!.username,
                      location: postD.repostedPostOwnerProfile!.location,
                      profilePicture:
                          postD.repostedPostOwnerProfile!.profilePicture,
                      verified: postD.repostedPostOwnerProfile!.verified,
                      profileSlug: postD.repostedPostOwnerProfile!.profileSlug)
                  : null,
            ),
            reachingRelationship:
                timeLineModel.getPostFeed.reachingRelationship,
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
          )
        : null;
    return postFeedModel;
  }

  List<TimeLineModel> getExactValue(String type) {
    Map<String, dynamic> mapper = {
      'profile': _myPosts,
      'post': value,
      'likes': _myLikedPosts,
      'upvote': _myUpVotedPosts,
      'downvote': _myDownVotedPosts,
      'save': _mySavedPosts,
    };

    return mapper[type];
  }

  removePost(BuildContext context, String id,
      {bool? isDelete, required String type}) {
    List<TimeLineModel> currentPosts = getExactValue(type);
    type == 'post'
        ? currentPosts.removeWhere((element) => element.id == id)
        : null;
    if (isDelete ?? false) {
      Snackbars.success(
        context,
        message: 'You have successfully delete this post.',
        milliseconds: 1300,
      );
    }
    notifyListeners();
  }

  pt.PostFeedModel? getPostModelById(String timeLineId,
      {required String type}) {
    List<TimeLineModel> currentPosts = getExactValue(type);
    TimeLineModel actualModel =
        currentPosts.firstWhere((element) => element.id == timeLineId);
    return getPostModel(timeLineModel: actualModel);
  }

  getMyStatus() async {
    Either<String, List<StatusModel>>? response =
        await timeLineQuery.getAllStatus(pageLimit: 50, pageNumber: 1);
    if (response!.isRight()) {
      response.forEach((r) {
        r.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
        _myStatus = r;
      });
      notifyListeners();
    }
  }

  addNewStatus(StatusModel status) {
    _myStatus = [
      ..._myStatus,
      status,
    ];
    notifyListeners();
  }

  muteStatus(int index) {
    final _status = _userStatus[index];
    for (int i = 0; i < _status.status!.length; i++) {
      _status.status![i].status!.isMuted = true;
    }
    _mutedStatus = [..._mutedStatus, _status];
    _userStatus = [..._userStatus]..removeAt(index);
    notifyListeners();
  }

  unMuteStatus(int index) {
    final _status = _mutedStatus[index];
    for (int i = 0; i < _status.status!.length; i++) {
      _status.status![i].status!.isMuted = false;
    }
    _userStatus = [..._userStatus, _status];
    _mutedStatus = [..._mutedStatus]..removeAt(index);
    notifyListeners();
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
    _mutedStatus = [];
    for (StatusFeedResponseModel actualStatus in _userStatus) {
      if (actualStatus.isMuted ??
          false ||
              (actualStatus.status ?? [])
                  .where((e) => e.status?.isMuted ?? false)
                  .isNotEmpty) {
        _mutedStatus.add(actualStatus);
        _userStatus.remove(actualStatus);
      }

      // List<StatusFeedModel> statusList = actualStatus.status!;
      // for (StatusFeedModel status in statusList) {
      //   if (status.isMuted ?? false) {
      //     _mutedStatus.add(actualStatus);
      //     _userStatus.remove(actualStatus);
      //   }
      //   break;
      // }
      // _mutedStatus.toSet();
    }
    notifyListeners();
  }

  TimeLineModel getModel(String id) {
    List<TimeLineModel> currentData = value;
    return currentData.firstWhere((element) => element.id == id);
  }

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
      initialize(isRefreshing: true);
      Snackbars.success(context, message: 'Your reach has been posted');
      Get.close(2);
    }
  }

  messageUser(BuildContext context,
      {required String id, String? quoteData, bool? isStreak}) async {
    Either<String, User> response =
        await UserRepository().getUserProfile(email: id);
    User? userInfo;
    if (response.isRight()) {
      response.forEach((r) {
        userInfo = r;
      });
      if (userInfo != null) {
        RouteNavigators.route(
            context,
            MsgChatInterface(
              isStreak: isStreak,
              recipientUser: userInfo,
              quotedData: quoteData,
            ));
      }
    }
  }

  getUserByUsername(BuildContext context, {required String username}) async {
    Either<String, UserList> response =
        await UserRepository().getUserProfileByUsername(username: username);
    UserList? userInformation;
    User? userInfo;
    debugPrint("User info 1: ${userInformation?.user.first.username}");
    if (response.isRight()) {
      response.map(
        (r) => userInformation = r,
      );
      userInfo = userInformation?.user.first;
      debugPrint("User info: ${userInfo?.username}");
      RouteNavigators.route(
          context,
          RecipientAccountProfile(
            recipientCoverImageUrl: userInfo?.coverPicture,
            recipientEmail: userInfo?.email,
            recipientId: userInfo?.id,
            recipientImageUrl: userInfo?.profilePicture,
          ));
    }
  }

  Future<bool> usersReaching() async {
    Either<String, bool> response = await UserRepository().getReachRelationship(
        userId: globals.userId!, type: ReachRelationshipType.reacher);

    bool isReaching = false;
    if (response.isRight()) {
      response.map((r) => isReaching = r);
      return isReaching;
    } else {
      return false;
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
      initialize(isTextEditing: true, isRefreshing: true);
    }
  }

  shoutDown(BuildContext context,
      {required String postId, required String authId}) async {
    bool? res = await getReachRelationship(usersId: authId, type: 'reacher');
    if (res != null && res) {
      bool response = await timeLineQuery.votePost(
        postId: postId,
        voteType: 'Downvote',
      );
      if (response) {
        timeLineFeedStore.initialize(isUpvoting: true, isRefreshing: true);
        Snackbars.success(
          context,
          message: 'You have successfully shouted down this post.',
          milliseconds: 1300,
        );
        Get.back();
      }
    } else {
      Snackbars.error(
        context,
        message: 'Operation failed, This user is not reaching you.',
        milliseconds: 1300,
      );
    }
  }

  getSuggestedUsers() async {
    _gettingSuggestedUser = true;
    Either<String, List<User>> response =
        await SocialServiceRepository().suggestUser();
    if (response.isRight()) {
      response.forEach((userList) {
        print(
            "<<<<<<<<<<<>>>>>>>>>>>>>>>> ::::::::: ${userList.first.reaching}");
        for (var element in userList) {
          print(">>>>>>>>>>>>>>>>>>>>${element.reaching?.reacherId}");
        }
        for (User user in userList) {
          _suggestedUsers.add(CustomUser(user: user));
        }
        return;
      });
      _gettingSuggestedUser = false;
      notifyListeners();
    }
  }

  deleteSuggestedUser({required String id}) {
    List<CustomUser> currentSuggestedUser = _suggestedUsers;
    currentSuggestedUser.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  reachUser({required String id}) async {
    List<CustomUser> currentSuggestedUser = _suggestedUsers;
    CustomUser actualUser =
        currentSuggestedUser.firstWhere((element) => element.id == id);
    bool isReaching = actualUser.user.reaching?.reachingId != null;
    if (isReaching) {
      actualUser.user.reaching?.reachingId = null;
      actualUser.user.nReachers = actualUser.user.nReachers ?? 0 - 1;
      notifyListeners();
      final response = await UserRepository()
          .deleteReachRelationship(userId: actualUser.user.id!);
      if (response.isRight()) {
        // updateSuggestedList();
      }
    } else {
      actualUser.user.reaching?.reachingId = 'reaching';
      actualUser.user.nReachers = actualUser.user.nReachers ?? 0 + 1;
      notifyListeners();
      Either<String, dynamic> response =
          await UserRepository().reachUser(userId: actualUser.user.id!);
      if (response.isRight()) {
        // updateSuggestedList();
      }
    }
  }

  updateSuggestedList() async {
    Either<String, List<User>> response =
        await SocialServiceRepository().suggestUser();
    if (response.isRight()) {
      _suggestedUsers.clear();
      response.forEach((userList) {
        for (User user in userList) {
          _suggestedUsers.add(CustomUser(user: user));
        }
        return;
      });
    }
    notifyListeners();
  }

  deleteVotedPost(
      {required String postId,
      required String id,
      required String type}) async {
    List<TimeLineModel> currentPosts = getExactValue(type);

    if (type == 'upvote' || type == 'post') {
      currentPosts.removeWhere((element) => element.id == id);
      notifyListeners();
    }
    bool response = await timeLineQuery.deleteVotedPost(postId: postId);
    if (response) {
      fetchAll(isFirst: true);
      initialize(isUpvoting: true, isRefreshing: true);
      Get.snackbar(
        '',
        '',
        titleText: const SizedBox.shrink(),
        messageText: CustomText(
          text: 'You have successfully unShouted your shouted post.',
          color: const Color(0xFF1C8B43),
          size: getScreenHeight(16),
        ),
        borderWidth: 0.5,
        icon: SvgPicture.asset(
          'assets/svgs/like.svg',
          color: const Color(0xFF1C8B43),
        ),
        backgroundColor: const Color(0xFFE0FFDD),
        borderColor: const Color(0xFF1C8B43),
        borderRadius: 16,
        duration: const Duration(milliseconds: 1500),
      );
    }
  }

  /////////////////////////////////////////////////////////////////
  ///
  /// Profile page Data
  ///
  List<TimeLineModel> _myPosts = <TimeLineModel>[];
  List<TimeLineModel> get myPosts => _myPosts;

  List<TimeLineModel> _myQuotedPosts = <TimeLineModel>[];
  List<TimeLineModel> get myQuotedPosts => _myQuotedPosts;

  List<TimeLineModel> _myLikedPosts = <TimeLineModel>[];
  List<TimeLineModel> get myLikedPosts => _myLikedPosts;

  List<TimeLineModel> _myUpVotedPosts = <TimeLineModel>[];
  List<TimeLineModel> get myUpVotedPosts => _myUpVotedPosts;

  List<TimeLineModel> _myDownVotedPosts = <TimeLineModel>[];
  List<TimeLineModel> get myDownVotedPosts => _myDownVotedPosts;

  List<TimeLineModel> _mySavedPosts = <TimeLineModel>[];
  List<TimeLineModel> get mySavedPosts => _mySavedPosts;

  List<GetPersonalComment> _myPersonalComments = <GetPersonalComment>[];
  List<GetPersonalComment> get myPersonalComments => _myPersonalComments;

  fetchAll(
      {String? userId,
      bool? isFirst,
      bool? isLike,
      bool? isPost,
      bool? isSaved,
      bool? isUpVoted,
      bool? isDownVoted}) {
    print("::::::::::::::::: <<<< ::: isLike ::: $isLike");
    !(isPost ?? false)
        ? fetchMyPost(isRefresh: isFirst ?? false, userId: userId)
        : null;
    !(isLike ?? false)
        ? fetchMyLikedPosts(isRefresh: isFirst ?? false, userId: userId)
        : null;
    !(isSaved ?? false) ? fetchMySavedPosts(isRefresh: isFirst ?? false) : null;
    fetchMyComments(isRefresh: isFirst ?? false, userId: userId);
    !(isUpVoted ?? false)
        ? fetchMyVotedPosts(
            isRefresh: isFirst ?? false, type: 'Upvote', userId: userId)
        : null;
    !(isDownVoted ?? false)
        ? fetchMyVotedPosts(
            isRefresh: isFirst ?? false, type: 'Downvote', userId: userId)
        : null;
  }

  fetchMyPost(
      {int? pageNumber,
      int? pageLimit,
      String? userId,
      required bool isRefresh,
      RefreshController? refreshController}) async {
    if (_myPosts.isEmpty || isRefresh) {
      List<Post>? response = await timeLineQuery.getAllPosts(
          authIdToGet: userId ?? globals.userId);
      if (response != null) {
        _myPosts = [];
        for (Post post in response) {
          _myPosts.add(TimeLineModel(
              getPostFeed: GetPostFeed(post: post), isShowing: true));
        }
        getQuotedPost();
      }
      List<CustomCounter> likeBoxInfo = [];
      if (_myPosts.isNotEmpty) {
        timeLineController.likeBox2([]);
        for (TimeLineModel element in _myPosts) {
          likeBoxInfo.add(CustomCounter(
              id: element.id,
              data: LikeModel(
                nLikes: element.getPostFeed.post?.nLikes ?? 0,
                isLiked: element.getPostFeed.post?.isLiked ?? false,
              )));
        }
        timeLineController.likeBox2(likeBoxInfo);
        if (refreshController != null) {
          refreshController.refreshCompleted();
        }
      }
      notifyListeners();
    }
  }

  getQuotedPost() {
    _myQuotedPosts = [];
    if (_myPosts.isNotEmpty) {
      for (TimeLineModel timeLineModel in _myPosts) {
        if (timeLineModel.getPostFeed.post!.repostedPost != null) {
          _myQuotedPosts.add(timeLineModel);
        }
      }
    }
    notifyListeners();
  }

  fetchMyLikedPosts(
      {int? pageNumber,
      int? pageLimit,
      String? userId,
      required bool isRefresh,
      RefreshController? refreshController}) async {
    print("::::::::::::>>>>>>>>>>>>> am called");
    if (_myLikedPosts.isEmpty || isRefresh) {
      print("::::::::::::>>>>>>>>>>>>>1 am called ${globals.userId}");
      List<GetPostFeed>? response = await timeLineQuery.getLikedPosts(
          authIdToGet: userId ?? globals.userId);
      if (response != null) {
        _myLikedPosts = [];
        for (GetPostFeed postFeed in response) {
          Post post = postFeed.post!;
          _availablePostIds.add(post.postId!);
          _myLikedPosts.add(TimeLineModel(
            getPostFeed: postFeed,
            isShowing: true,
          ));
        }
      }
      List<CustomCounter> likeBoxInfo = [];
      if (_myLikedPosts.isNotEmpty) {
        timeLineController.likeBox3([]);
        for (TimeLineModel element in _myLikedPosts) {
          likeBoxInfo.add(CustomCounter(
              id: element.id,
              data: LikeModel(
                nLikes: element.getPostFeed.post?.nLikes ?? 0,
                isLiked: element.getPostFeed.post?.isLiked ?? false,
              )));
        }
        timeLineController.likeBox3(likeBoxInfo);
      }
      if (refreshController != null) {
        refreshController.refreshCompleted();
      }
      notifyListeners();
    }
  }

  fetchMyComments(
      {int? pageNumber,
      int? pageLimit,
      String? userId,
      required bool isRefresh,
      RefreshController? refreshController}) async {
    if (_myLikedPosts.isEmpty || isRefresh) {
      List<GetPersonalComment>? response = await timeLineQuery.getAllComments(
          authIdToGet: userId ?? globals.userId!);
      if (response != null) {
        _myPersonalComments = [];
        for (GetPersonalComment commentFeed in response) {
          _myPersonalComments.add(commentFeed);
        }
      }
      List<CustomCounter> likeBoxInfo = [];
      if (_myPersonalComments.isNotEmpty) {
        timeLineController.likeCommentBox([]);
        for (GetPersonalComment element in _myPersonalComments) {
          likeBoxInfo.add(CustomCounter(
              id: element.commentId!,
              data: LikeModel(
                nLikes: element.nLikes ?? 0,
                isLiked: element.isLiked != "false",
              )));
        }
        timeLineController.likeCommentBox(likeBoxInfo);
      }
      if (refreshController != null) {
        refreshController.refreshCompleted();
      }
      notifyListeners();
    }
  }

  ErProfile getPostModelMiniProfile(
      {required CommentOwnerProfile? tPostOwnerInfo}) {
    return ErProfile(
        firstName: tPostOwnerInfo?.firstName,
        lastName: tPostOwnerInfo?.lastName,
        username: tPostOwnerInfo?.username,
        profilePicture: tPostOwnerInfo?.profilePicture,
        profileSlug: tPostOwnerInfo?.profilePicture,
        verified: tPostOwnerInfo?.verified,
        location: tPostOwnerInfo?.location,
        bio: tPostOwnerInfo?.bio,
        authId: tPostOwnerInfo?.authId);
  }

  fetchMySavedPosts(
      {int? pageNumber,
      int? pageLimit,
      required bool isRefresh,
      RefreshController? refreshController}) async {
    if (_mySavedPosts.isEmpty || isRefresh) {
      List<GetAllSavedPost>? response = await timeLineQuery.getAllSavedPosts();
      if (response != null) {
        _mySavedPosts = [];
        for (GetAllSavedPost savedPost in response) {
          Post post = savedPost.post!;
          _availablePostIds.add(post.postId!);
          _mySavedPosts.add(TimeLineModel(
            getPostFeed: GetPostFeed(
                post: savedPost.post,
                updatedAt: savedPost.updatedAt,
                createdAt: savedPost.createdAt),
            isShowing: true,
          ));
        }
      }
      List<CustomCounter> likeBoxInfo = [];
      if (_mySavedPosts.isNotEmpty) {
        timeLineController.likeSavedBox([]);
        for (TimeLineModel element in _mySavedPosts) {
          likeBoxInfo.add(CustomCounter(
              id: element.id,
              data: LikeModel(
                nLikes: element.getPostFeed.post?.nLikes ?? 0,
                isLiked: element.getPostFeed.post?.isLiked ?? false,
              )));
        }
        timeLineController.likeSavedBox(likeBoxInfo);
      }
      if (refreshController != null) {
        refreshController.refreshCompleted();
      }
      notifyListeners();
    }
  }

  fetchMyVotedPosts(
      {int? pageNumber,
      int? pageLimit,
      String? userId,
      required bool isRefresh,
      RefreshController? refreshController,
      required String type}) async {
    List<TimeLineModel> data = [];
    if ((type.toLowerCase() == 'upvote'
            ? _myUpVotedPosts.isEmpty
            : _myDownVotedPosts.isEmpty) ||
        isRefresh) {
      print("::::::::::: am in here boss 0");
      List<GetPostFeed>? response = await timeLineQuery.getVotedPosts(
          authIdToGet: userId ?? globals.userId, votingType: type);
      if (response != null) {
        type.toLowerCase() == 'upvote'
            ? _myUpVotedPosts = []
            : _myDownVotedPosts = [];
        type.toLowerCase() == 'upvote'
            ? timeLineController.likeUpBox([])
            : timeLineController.likeDownBox([]);
        for (GetPostFeed postFeed in response) {
          Post post = postFeed.post!;
          _availablePostIds.add(post.postId!);
          data.add(TimeLineModel(
            getPostFeed: postFeed,
            isShowing: true,
          ));
        }
        type.toLowerCase() == 'upvote'
            ? _myUpVotedPosts = data
            : _myDownVotedPosts = data;
      }
      List<CustomCounter> likeBoxInfo = [];
      if (type.toLowerCase() == 'upvote'
          ? _myUpVotedPosts.isNotEmpty
          : _myDownVotedPosts.isNotEmpty) {
        for (TimeLineModel element in type.toLowerCase() == 'upvote'
            ? _myUpVotedPosts
            : _myDownVotedPosts) {
          likeBoxInfo.add(CustomCounter(
              id: element.id,
              data: LikeModel(
                nLikes: element.getPostFeed.post?.nLikes ?? 0,
                isLiked: element.getPostFeed.post?.isLiked ?? false,
              )));
        }
        type.toLowerCase() == 'upvote'
            ? timeLineController.likeUpBox(likeBoxInfo)
            : timeLineController.likeDownBox(likeBoxInfo);
      }
      if (refreshController != null) {
        refreshController.refreshCompleted();
      }
      notifyListeners();
    }
  }

  fetchMorePosts({required int index}) async {
    List<GetPostFeed>? response =
        await timeLineQuery.getAllPostFeeds(pageNumber: index, pageLimit: 10);
    List<CustomCounter> likeBoxInfo = [];
    if (response != null) {
      for (GetPostFeed postFeed in response) {
        Post post = postFeed.post!;
        _availablePostIds.add(post.postId!);
        value.add(TimeLineModel(
          getPostFeed: postFeed,
          isShowing: post.isVoted!.toLowerCase().trim() != 'downvote' &&
              post.postOwnerProfile != null,
        ));
      }
      if (value.isNotEmpty) {
        for (TimeLineModel element in value) {
          likeBoxInfo.add(CustomCounter(
              id: element.id,
              data: LikeModel(
                nLikes: element.getPostFeed.post?.nLikes ?? 0,
                isLiked: element.getPostFeed.post?.isLiked ?? false,
              )));
        }
      }
      timeLineController.likeBox(likeBoxInfo);
      notifyListeners();
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

class CustomUser {
  final User user;
  final String id;

  CustomUser({required this.user}) : id = const Uuid().v4();
}

//
class LikeModel {
  int nLikes;
  bool isLiked;

  LikeModel({required this.nLikes, required this.isLiked});
}

//
class CustomCounter {
  final String id;
  LikeModel data;

  CustomCounter({required this.id, required this.data});
}
