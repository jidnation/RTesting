import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../core/components/empty_state.dart';
import '../timeline/timeline_action-box.dart';
import '../timeline/timeline_box.dart';
import '../timeline/timeline_control_room.dart';
import '../timeline/timeline_feed.dart';

class LikedTab extends StatefulWidget {
  const LikedTab({
    Key? key,
  }) : super(key: key);

  @override
  State<LikedTab> createState() => _LikedTabState();
}

late ScrollController _controller;

class _LikedTabState extends State<LikedTab> {
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
          List<TimeLineModel> data = timeLineFeedStore.myLikedPosts;
          return Expanded(
            child: SmartRefresher(
              physics: const BouncingScrollPhysics(),
              onRefresh: () {
                timeLineFeedStore.fetchMyLikedPosts(
                  isRefresh: true,
                  refreshController: _refreshController,
                );
              },
              controller: _refreshController,
              child: data.isEmpty
                  ? ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: const [
                        EmptyTabWidget(
                          title: "Likes you made",
                          subtitle:
                              "Find post you liked and your post that was liked",
                        )
                      ],
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      controller: _controller,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        GlobalKey<State<StatefulWidget>> src = GlobalKey();
                        TimeLineModel post = data[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: RepaintBoundary(
                            key: src,
                            child: Stack(children: [
                              TimeLineBox(
                                timeLineModel: post,
                                takeScreenShot: () {
                                  timeLineController.takeScreenShot(
                                      context, src);
                                },
                              ),
                              Positioned(
                                  bottom: 10,
                                  left: 30,
                                  right: 30,
                                  child: TimeLineBoxActionRow(
                                    timeLineId: post.id,
                                    type: 'likes',
                                    post: post.getPostFeed.post!,
                                  )),
                            ]),
                          ),
                        );
                      },
                      itemCount: data.length,
                    ),
            ),
          );
        });
  }
}
