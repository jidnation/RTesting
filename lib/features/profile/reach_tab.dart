import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../core/components/empty_state.dart';
import '../timeline/timeline_action-box.dart';
import '../timeline/timeline_box.dart';
import '../timeline/timeline_control_room.dart';
import '../timeline/timeline_feed.dart';

class ReachTab extends StatefulWidget {
  const ReachTab({
    Key? key,
  }) : super(key: key);

  @override
  State<ReachTab> createState() => _ReachTabState();
}

late ScrollController _controller;

class _ReachTabState extends State<ReachTab> {
  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    _controller.offset > 100
        ? timeLineController.isScrolling(true)
        : timeLineController.isScrolling(false);
  }

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    return ValueListenableBuilder(
        valueListenable: TimeLineFeedStore(),
        builder: (context, List<TimeLineModel> value, child) {
          List<TimeLineModel> data = timeLineFeedStore.myPosts;
          return Expanded(
            child: SmartRefresher(
              physics: const BouncingScrollPhysics(),
              onRefresh: () {
                timeLineFeedStore.fetchMyPost(
                  isRefresh: true,
                  refreshController: _refreshController,
                  // isRefresh: true,
                );
              },
              controller: _refreshController,
              child: data.isEmpty
                  ? ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: const [
                          EmptyTabWidget(
                            title: "Reaches you’ve made",
                            subtitle:
                                "Find all posts or contributions you’ve made here ",
                          )
                        ])
                  : ListView.builder(
                      shrinkWrap: true,
                      controller: _controller,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        TimeLineModel post = data[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Stack(children: [
                            // TimeLineBox(
                            //   timeLineModel: post,
                            // ),
                            Positioned(
                                bottom: 10,
                                left: 30,
                                right: 30,
                                child: TimeLineBoxActionRow(
                                  timeLineId: post.id,
                                  type: 'profile',
                                  post: post.getPostFeed.post!,
                                )),
                          ]),
                        );
                      },
                      itemCount: data.length,
                    ),
            ),
          );
        });
  }
}
