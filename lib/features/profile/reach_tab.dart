import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../timeline/timeline_action-box.dart';
import '../timeline/timeline_box.dart';
import '../timeline/timeline_control_room.dart';
import '../timeline/timeline_feed.dart';

class ReachTab extends StatelessWidget {
  const ReachTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
    RefreshController(initialRefresh: false);
    return ValueListenableBuilder(
        valueListenable: TimeLineFeedStore(),
        builder: (context, List<TimeLineModel> value, child) {
          List<TimeLineModel> data = timeLineFeedStore.myPosts;
          return Expanded(
            child: NotificationListener<ScrollNotification>(
              // onNotification: (scrollNotification) {
              //   if (scrollNotification is ScrollStartNotification) {
              //     timeLineController.isScrolling(true);
              //   }
              //   return false;
              // },
              child: SmartRefresher(
                physics: const BouncingScrollPhysics(),
                onRefresh: () {
                  timeLineFeedStore.fetchMyPost(
                    isRefresh: true,
                    refreshController:
                    _refreshController,
                    // isRefresh: true,
                  );
                  // await Future.delayed(const Duration(seconds: 10));
                  // _refreshController.refreshCompleted();
                },
                controller: _refreshController,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index){
                    TimeLineModel post = data[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child:
                      index == 0 ?
                      Stack(children: [
                        VisibilityDetector(
                          key: Key('my-widget-key3'),
                          onVisibilityChanged: (visibilityInfo) {
                            var visiblePercentage =
                                visibilityInfo.visibleFraction * 100;
                            print(":::::::::::::::::::: $visiblePercentage");
                            visiblePercentage > 50 ? timeLineController.isScrolling(false) : timeLineController.isScrolling(true);

                          },
                          child: TimeLineBox(
                            timeLineModel: post,
                          ),
                        ),
                        Positioned(
                            bottom: 10,
                            left: 30,
                            right: 30,
                            child:
                            TimeLineBoxActionRow(
                              timeLineId: post.id,
                              type: 'profile',
                              post: post
                                  .getPostFeed.post!,
                            )),
                      ]) : Stack(children: [
                        TimeLineBox(
                          timeLineModel: post,
                        ),
                        Positioned(
                            bottom: 10,
                            left: 30,
                            right: 30,
                            child:
                            TimeLineBoxActionRow(
                              timeLineId: post.id,
                              type: 'profile',
                              post: post
                                  .getPostFeed.post!,
                            )),
                      ]),
                    );
                  },
                  itemCount: data.length,
                ),
              ),
            ),
          );

        });
  }
}