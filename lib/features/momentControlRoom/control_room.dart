import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/moment/querys.dart';
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

  int _currentSaveIndex = 0;
  int get currentSaveIndex => _currentSaveIndex;

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
            nComment: momentFeed.moment!.nComments!,
            momentId: momentFeed.moment!.momentId!,
            caption: momentFeed.moment!.caption!));
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
          response = await MomentQuery.unlikeMoment(momentId: momentId);
        } else {
          momentModel.isLiked = true;
          momentModel.nLikes += 1;
          response = await MomentQuery.likeMoment(momentId: momentId);
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

  // unLikeMoment({required String momentId}) async {
  //   var response = await MomentQuery.unlikeMoment(momentId: momentId);
  //   if (response) {
  //     // getMoment(momentId: momentId);
  //   }
  // }

  //updating only the consider moment
  getMoment({required String momentId, required String id}) async {
    print('getting moment called::::::: $value');
    List<MomentModel> currentList = value;
    Moment? response = await MomentQuery.getMoment(momentId: momentId);

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
}

class MomentModel {
  final String id;
  final String videoUrl;
  final String? soundUrl;
  int nLikes;
  int nComment;
  bool isLiked;
  final String momentId;
  final String? profilePicture;
  final String caption;

  MomentModel(
      {required this.videoUrl,
      this.soundUrl,
      required this.isLiked,
      required this.nLikes,
      required this.nComment,
      required this.momentId,
      this.profilePicture,
      required this.caption})
      : id = Uuid().v4();
}
