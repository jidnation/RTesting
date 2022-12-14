import 'package:flutter/material.dart';

import '../../core/services/moment/querys.dart';
import 'models/get_moment_feed.dart';

class MomentFeedStore extends ValueNotifier<List<GetMomentFeed>> {
  //creating a singleton class
  MomentFeedStore._sharedInstance() : super(<GetMomentFeed>[]);
  static final MomentFeedStore _shared = MomentFeedStore._sharedInstance();

  factory MomentFeedStore() => _shared;

  final MomentQuery momentQuery = MomentQuery();

  int get momentCount => value.length;

  bool _gettingMoments = false;
  bool get gettingMoments => _gettingMoments;

  initialize() async {
    _gettingMoments = true;
    MomentFeedModel? response =
        await momentQuery.getAllFeeds(pageLimit: 10, pageNumber: 1);
    response != null ? value = response.getMomentFeed! : null;
    print('................. IT IS DONE..................... $value....');
    _gettingMoments = false;
    notifyListeners();
  }
}
