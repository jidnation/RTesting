import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:uuid/uuid.dart';

import '../../core/components/snackbar.dart';
import '../../core/services/moment/querys.dart';
import 'models/get_comments_model.dart';
import 'models/get_moment_feed.dart';
import 'moment_cacher.dart';

class MomentFeedStore extends ValueNotifier<List<MomentModel>> {
  //creating a singleton class
  MomentFeedStore._sharedInstance() : super(<MomentModel>[]);
  static final MomentFeedStore _shared = MomentFeedStore._sharedInstance();

  factory MomentFeedStore() => _shared;

  final MomentQuery momentQuery = MomentQuery();

  int get momentCount => value.length;

  bool _gettingMoments = false;
  bool get gettingMoments => _gettingMoments;

  bool _postingUserComment = false;
  bool get postingUserComment => _postingUserComment;

  bool _gettingUserComment = false;
  bool get gettingUserComment => _gettingUserComment;

  int _currentSaveIndex = 0;
  int get currentSaveIndex => _currentSaveIndex;

  List<CustomMomentCommentModel> _momentComments = <CustomMomentCommentModel>[];
  List<CustomMomentCommentModel> get momentComments => _momentComments;

  final VideoControllerService _videoControllerService =
      CachedVideoControllerService(DefaultCacheManager());
  VideoControllerService get videoControllerService => _videoControllerService;

  //the combined Moment List
  // List<GetMomentFeed> _combinedMomentList = <GetMomentFeed>[];
  // List<GetMomentFeed> get combinedMomentList => _combinedMomentList;

  initialize() async {
    _gettingMoments = true;
    MomentFeedModel? response =
        await momentQuery.getAllFeeds(pageLimit: 30, pageNumber: 1);
    if (response != null) {
      List<GetMomentFeed> data = response.getMomentFeed!;
      for (GetMomentFeed momentFeed in data) {
        value.add(MomentModel(
          videoUrl: momentFeed.moment!.videoMediaItem!,
          isLiked: momentFeed.moment!.isLiked!,
          nLikes: momentFeed.moment!.nLikes!,
          soundUrl: momentFeed.moment!.sound,
          momentOwnerId: momentFeed.moment!.momentOwnerProfile!.authId!,
          momentOwnerUserName: momentFeed.moment!.momentOwnerProfile!.username!,
          feedOwnerUserName: momentFeed.feedOwnerProfile!.username!,
          reachingUser: momentFeed.reachingRelationship!,
          profilePicture:
              momentFeed.moment!.momentOwnerProfile!.profilePicture ?? "",
          nComment: momentFeed.moment!.nComments!,
          momentId: momentFeed.moment!.momentId!,
          caption: momentFeed.moment!.caption!,
          momentCreatedTime: momentFeed.createdAt.toString(),
        ));
      }
    }
    // _combinedMomentList = value;
    print('................. IT IS DONE..................... $value..   ..');
    print(
        '................. IT IS DONE2........n ${value.first.momentId}........');
    _gettingMoments = false;
    cacheValues();
    notifyListeners();
  }

  String getCountValue({required int value}) {
    String stringValue = value.toString();
    late String toReturn;
    if (stringValue.length >= 3 && stringValue.length < 7) {
      toReturn = stringValue.replaceRange(stringValue.length - 3, null, 'k');
    } else {
      toReturn = stringValue;
    }
    return toReturn;
  }

  cacheValues() async {
    late int count;
    if (momentCount != 0) {
      if (momentCount > 5) {
        count = 0;
        for (MomentModel momentFeed in value) {
          print('....caching started......>>>>>>>>>>>:::::::::::::::::::>>>>>');
          await videoControllerService
              .getControllerForVideo(momentFeed.videoUrl);
          ++count;
          if (count > 5) {
            _currentSaveIndex = 5;
            return;
          }
        }
      } else {
        for (MomentModel momentFeed in value) {
          await videoControllerService
              .getControllerForVideo(momentFeed.videoUrl);
          _currentSaveIndex = momentCount;
        }
      }
    }
    notifyListeners();
  }

  cacheNextFive(int currentCount) async {
    late int counter;
    int to = currentCount + 5;
    if (momentCount > currentCount) {
      counter = 0;
      for (MomentModel momentFeed in value) {
        ++counter;
        if (counter > currentCount) {
          await videoControllerService
              .getControllerForVideo(momentFeed.videoUrl);
          if (counter == to) {
            _currentSaveIndex = to;
            return;
          } else if (momentCount < to &&
              (counter + currentCount == momentCount)) {
            _currentSaveIndex = counter + currentCount;
            return;
          }
        }
      }
    }
    notifyListeners();
  }

  likingMoment({required String momentId, required String id}) async {
    List<MomentModel> currentList = value;
    late bool response;
    for (MomentModel momentModel in currentList) {
      if (momentModel.id == id) {
        if (momentModel.isLiked) {
          momentModel.isLiked = false;
          momentModel.nLikes -= 1;
          response = await momentQuery.unlikeMoment(momentId: momentId);
        } else {
          momentModel.isLiked = true;
          momentModel.nLikes += 1;
          response = await momentQuery.likeMoment(momentId: momentId);
        }
      }
    }
    print('isLiked>>>>>>>>>>>>>>>>>>>>>>>>>>> called :::::: $momentId');

    print('isLiked>>>>>>>>>>>>>>>>>>>>>>>>>>> called2 :::::: $response');
    if (response) {
      getMoment(momentId: momentId, id: id);
    }
    notifyListeners();
  }

  likingMomentComment({required String momentId, required String id}) async {
    List<CustomMomentCommentModel> currentCommentList = momentComments;
    CustomMomentCommentModel commentModel =
        currentCommentList.firstWhere((element) => element.id == id);
    late bool response;
    if (commentModel.getMomentComment.isLiked!) {
      // momentModel.isLiked = false;
      // momentModel.nLikes -= 1;
      // response = await momentQuery.unlikeMomentComment(momentId: momentId, likeId: commentModel.getMomentComment);
    } else {
      // momentModel.isLiked = true;
      // momentModel.nLikes += 1;
      response = await momentQuery.likeMomentComment(
          momentId: momentId,
          commentId: commentModel.getMomentComment.commentId!);
    }
    print('isLiked>>>>>>>>>>>>>>>>>>>>>>>>>>> called :::::: $momentId');

    print('isLiked>>>>>>>>>>>>>>>>>>>>>>>>>>> called2 :::::: $response');
    if (response) {
      getMomentComment(id: id);
    }
    notifyListeners();
  }

  //updating only the consider moment
  getMoment({required String momentId, required String id}) async {
    print('getting moment called::::::: $value');
    List<MomentModel> currentList = value;
    Moment? response = await momentQuery.getMoment(momentId: momentId);

    if (response != null) {
      for (MomentModel momentFeed in currentList) {
        if (momentFeed.id == id) {
          momentFeed.nLikes = response.nLikes!;
          momentFeed.nComment = response.nComments!;
          momentFeed.isLiked = response.isLiked!;
          return;
        }
      }
    }
    notifyListeners();
  }

  getMomentComment({required String id}) async {
    // print('getting moment called::::::: $value');
    List<CustomMomentCommentModel> currentCommentList = momentComments;
    CustomMomentCommentModel commentModel =
        currentCommentList.firstWhere((element) => element.id == id);

    var response = await momentQuery.getMomentComment(
        commentId: commentModel.getMomentComment.commentId!);

    if (response != null) {
      // for (MomentModel momentFeed in currentList) {
      //   if (momentFeed.id == id) {
      //     momentFeed.nLikes = response.nLikes!;
      //     momentFeed.nComment = response.nComments!;
      //     momentFeed.isLiked = response.isLiked!;
      //     return;
      //   }
    }
    notifyListeners();
  }

  reachUser({required String toReachId, required String id}) async {
    var response = await momentQuery.reachUser(reachingId: '');
    print('from the reaching end this is us>>>>>>>>>>>>> $response');
  }

//  Commenting on user moment
  Future<bool> commentOnMoment(BuildContext context,
      {required String id,
      String? userComment,
      List<String>? images,
      String? audioUrl,
      String? videoUrl}) async {
    _postingUserComment = true;
    MomentModel momentModel = value.firstWhere((element) => element.id == id);

    bool response = await momentQuery.createMomentComment(
        momentId: momentModel.momentId,
        momentOwnerId: momentModel.momentOwnerId,
        userComment: userComment,
        images: images,
        audioUrl: audioUrl,
        videoUrl: videoUrl);
    if (response) {
      Snackbars.success(
        context,
        message: 'Moment successfully created',
        milliseconds: 1300,
      );
    } else {
      Snackbars.error(
        context,
        message: 'Unable to post your comment, Try again Later.',
        milliseconds: 1300,
      );
    }
    _postingUserComment = false;
    notifyListeners();
    return response;
  }

  getMomentComments(
      {required String momentId, int? pageLimit, int? pageNumber}) async {
    _gettingUserComment = true;
    List<GetMomentComment>? response =
        await momentQuery.getMomentComments(momentId: momentId);
    if (response != null) {
      _momentComments.clear();
      for (GetMomentComment element in response) {
        _momentComments.add(CustomMomentCommentModel(element));
      }
    }
    _gettingUserComment = false;
    notifyListeners();
  }
}

class MomentModel {
  final String id;
  final String videoUrl;
  final String? soundUrl;
  final String momentCreatedTime;
  bool reachingUser;
  int nLikes;
  int nComment;
  bool isLiked;
  final String momentId;
  final String profilePicture;
  final String momentOwnerId;
  final String momentOwnerUserName;
  final String feedOwnerUserName;
  final String caption;

  MomentModel(
      {required this.videoUrl,
      this.soundUrl,
      required this.reachingUser,
      required this.momentCreatedTime,
      required this.isLiked,
      required this.momentOwnerId,
      required this.momentOwnerUserName,
      required this.feedOwnerUserName,
      required this.nLikes,
      required this.nComment,
      required this.momentId,
      required this.profilePicture,
      required this.caption})
      : id = const Uuid().v4();
}

class CustomMomentCommentModel {
  final GetMomentComment getMomentComment;
  final String id;

  CustomMomentCommentModel(this.getMomentComment) : id = const Uuid().v4();
}
