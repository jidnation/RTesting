import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../core/services/moment/querys.dart';
import 'models/get_moment_feed.dart';
import 'moment_cacher.dart';

class MomentFeedStore extends ValueNotifier<List<GetMomentFeed>> {
  //creating a singleton class
  MomentFeedStore._sharedInstance() : super(<GetMomentFeed>[]);
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
  List<GetMomentFeed> _combinedMomentList = <GetMomentFeed>[];
  List<GetMomentFeed> get combinedMomentList => _combinedMomentList;

  initialize() async {
    _gettingMoments = true;
    MomentFeedModel? response =
        await momentQuery.getAllFeeds(pageLimit: 30, pageNumber: 1);
    response != null ? value = response.getMomentFeed! : null;
    _combinedMomentList = value;
    print('................. IT IS DONE..................... $value..   ..');
    print(
        '................. IT IS DONE2........n ${value.first.moment!.momentId}........');
    _gettingMoments = false;
    cacheValues();
    notifyListeners();
  }

  cacheValues() async {
    late int count;
    if (momentCount != 0) {
      if (momentCount > 5) {
        count = 0;
        for (GetMomentFeed momentFeed in combinedMomentList) {
          print('....caching started......>>>>>>>>>>>:::::::::::::::::::>>>>>');
          await videoControllerService
              .getControllerForVideo(momentFeed.moment!.videoMediaItem!);
          ++count;
          if (count > 5) {
            _currentSaveIndex = 5;
            return;
          }
        }
      } else {
        for (GetMomentFeed momentFeed in combinedMomentList) {
          await videoControllerService
              .getControllerForVideo(momentFeed.moment!.videoMediaItem!);
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
      for (GetMomentFeed momentFeed in combinedMomentList) {
        ++counter;
        if (counter > currentCount) {
          await videoControllerService
              .getControllerForVideo(momentFeed.moment!.videoMediaItem!);
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

  likeMoment({required String momentId}) async {
    var response = await MomentQuery.likeMoment(momentId: momentId);
    if (response) {
      getMoment(momentId: momentId);
    }
  }

  unLikeMoment({required String momentId}) async {
    var response = await MomentQuery.unlikeMoment(momentId: momentId);
    if (response) {
      getMoment(momentId: momentId);
    }
  }

  //updating only the consider moment
  getMoment({required String momentId}) async {
    List<GetMomentFeed> currentList = combinedMomentList;
    GetMomentFeed? response = await MomentQuery.getMoment(momentId: momentId);
    for (GetMomentFeed momentFeed in currentList) {
      if (momentFeed.moment!.momentId == momentId) {
        momentFeed = response!;
      }
    }
    notifyListeners();
  }
}
