import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../core/components/empty_state.dart';
import '../timeline/timeline_action-box.dart';
import '../timeline/timeline_box.dart';
import '../timeline/timeline_control_room.dart';
import '../timeline/timeline_feed.dart';

class DownVotedTab extends StatefulWidget {
  const DownVotedTab({
    Key? key,
  }) : super(key: key);

  @override
  State<DownVotedTab> createState() => _DownVotedTabState();
}

late ScrollController _controller;

class _DownVotedTabState extends State<DownVotedTab> {
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
          List<TimeLineModel> data = timeLineFeedStore.myDownVotedPosts;
          return Expanded(
            child: NotificationListener<ScrollNotification>(
              child: SmartRefresher(
                physics: const BouncingScrollPhysics(),
                onRefresh: () {
                  timeLineFeedStore.fetchMyVotedPosts(
                    isRefresh: true,
                    type: 'Downvote',
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
                                title:
                                    "Posts you've shouted down and your posts that has been shouted down",
                                subtitle:
                                    "See posts you've shouted down and your post that has been shouted down")
                          ])
                    : ListView.builder(
                        shrinkWrap: true,
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
                                  takeScreenShot: () => timeLineController
                                      .takeScreenShot(context, src),
                                ),
                                Positioned(
                                    bottom: 10,
                                    left: 30,
                                    right: 30,
                                    child: TimeLineBoxActionRow(
                                      timeLineId: post.id,
                                      type: 'downvote',
                                      post: post.getPostFeed.post!,
                                    )),
                              ]),
                            ),
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
