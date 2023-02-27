import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../core/components/empty_state.dart';
import '../timeline/models/profile_comment_model.dart';
import '../timeline/timeline_action-box.dart';
import '../timeline/timeline_box.dart';
import '../timeline/timeline_control_room.dart';
import '../timeline/timeline_feed.dart';
import 'comment_action_box.dart';
import 'comment_box.dart';

class CommentsTab extends StatefulWidget {
  final String? authId;
  const CommentsTab({
    Key? key,
    this.authId,
  }) : super(key: key);

  @override
  State<CommentsTab> createState() => _CommentsTabState();
}

late ScrollController _controller;

class _CommentsTabState extends State<CommentsTab> {
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
          List<GetPersonalComment> data = widget.authId != null
              ? timeLineFeedStore.myRPersonalComments
              : timeLineFeedStore.myPersonalComments;
          return SmartRefresher(
            physics: const BouncingScrollPhysics(),
            onRefresh: () {
              timeLineFeedStore.fetchMyComments(
                isRefresh: true,
                refreshController: _refreshController,
                userId: widget.authId,
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
                                'Comments you made on a post and comments made on your post',
                            subtitle:
                                'Here you will find all comments you’ve made on a post and also those made on your own posts')
                      ])
                : ListView.builder(
                    shrinkWrap: true,
                    controller: _controller,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      GlobalKey<State<StatefulWidget>> src = GlobalKey();
                      GetPersonalComment comment = data[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Stack(children: [
                          CommentBox(
                            takeScreenShot: () {
                              timeLineController.takeScreenShot(context, src);
                            },
                            getPersonalComment: comment,
                          ),
                          Positioned(
                              bottom: 10,
                              left: 30,
                              right: 30,
                              child:
                                  // Container()
                                  CommentBoxActionRow(
                                getPersonalComment: comment,
                                type: 'comment',
                              )),
                        ]),
                      );
                    },
                    itemCount: data.length,
                  ),
          );
        });
  }
}
