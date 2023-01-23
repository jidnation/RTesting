import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reach_me/features/home/data/models/status.model.dart';
import 'package:reach_me/features/home/presentation/views/status/widgets/status_bubble.dart';
import 'package:reach_me/features/timeline/suggestion_widget.dart';
import 'package:reach_me/features/timeline/timeline_action-box.dart';
import 'package:reach_me/features/timeline/timeline_box.dart';
import 'package:reach_me/features/timeline/timeline_control_room.dart';
import 'package:reach_me/features/timeline/timeline_post_reach.dart';
import 'package:reach_me/features/timeline/timeline_user_story.dart';

import '../../core/components/profile_picture.dart';
import '../../core/components/rm_spinner.dart';
import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/app_globals.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/dimensions.dart';
import '../chat/presentation/views/chats_list_screen.dart';
import '../home/presentation/bloc/user-bloc/user_bloc.dart';
import '../home/presentation/views/status/view.status.dart';
import '../moment/user_posting.dart';

class TimeLineFeed extends StatefulWidget {
  static const String id = "timeline_screen";
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const TimeLineFeed({Key? key, this.scaffoldKey}) : super(key: key);

  @override
  State<TimeLineFeed> createState() => _TimeLineFeedState();
}

final TimeLineFeedStore timeLineFeedStore = TimeLineFeedStore();

class _TimeLineFeedState extends State<TimeLineFeed>
    with AutomaticKeepAliveClientMixin<TimeLineFeed> {
  @override
  void initState() {
    super.initState();
    globals.userBloc!.add(GetUserProfileEvent(email: globals.userId!));
    timeLineFeedStore.getMyStatus();
    timeLineFeedStore.getUserStatus();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: ProgressHUD(
        child: Scaffold(
          backgroundColor: const Color(0xFFE3E5E7).withOpacity(0.3),
          appBar: AppBar(
            backgroundColor: AppColors.white,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness:
                  Platform.isAndroid ? Brightness.dark : Brightness.light,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarDividerColor: Colors.grey,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            shadowColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () => widget.scaffoldKey!.currentState!.openDrawer(),
              icon: SizedBox(
                height: 30,
                width: 30,
                child: ProfilePicture(
                  height: getScreenHeight(50),
                  width: getScreenWidth(50),
                ),
              ),
            ),
            titleSpacing: -10,
            leadingWidth: getScreenWidth(70),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/hd-icon.png',
                  fit: BoxFit.contain,
                  height: 25,
                ),
                Container(
                    padding: const EdgeInsets.all(2.0),
                    child: const Text(
                      'eachme',
                      style: TextStyle(
                          color: AppColors.primaryColor, fontSize: 20),
                    ))
              ],
            ),
            actions: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/svgs/edit.svg',
                  width: getScreenWidth(22),
                  height: getScreenHeight(22),
                ),
                onPressed: () =>
                    RouteNavigators.route(context, const TimeLinePostReach()),
                // RouteNavigators.route(context, const PostReach()),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/svgs/message.svg',
                  width: getScreenWidth(25),
                  height: getScreenHeight(25),
                ),
                onPressed: () => RouteNavigators.route(
                  context,
                  const ChatsListScreen(),
                ),
              ).paddingOnly(right: 16),
            ],
          ),
          body: GestureDetector(
            onHorizontalDragEnd: (dragEndDetails) {
              if (dragEndDetails.primaryVelocity! < 0) {
                // Swipe Right
              } else if (dragEndDetails.primaryVelocity! > 0) {
                // Swipe Left
                widget.scaffoldKey!.currentState!.openDrawer();
              }
            },
            child: SizedBox(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              child: ValueListenableBuilder(
                  valueListenable: TimeLineFeedStore(),
                  builder: (context, List<TimeLineModel> value, child) {
                    print('from the timeLine room.........??? $value }');
                    final List<StatusModel> _myStatus =
                        timeLineFeedStore.myStatus;
                    List<StatusFeedResponseModel> _userStatus =
                        timeLineFeedStore.userStatus;
                    List<StatusFeedResponseModel> _mutedStatus =
                        timeLineFeedStore.mutedStatus;
                    final List<TimeLineModel> timeLinePosts = value;
                    RefreshController _refreshController =
                        RefreshController(initialRefresh: false);

                    return timeLineFeedStore.gettingPosts
                        ? const SingleChildScrollView(
                            child: SkeletonLoadingWidget(),
                          )
                        : Column(children: [
                            timeLineFeedStore.isPosting
                                ? const LinearLoader()
                                : const Divider(
                                    thickness: 4,
                                    height: 0,
                                    color: AppColors.grey,
                                  ),
                            const SizedBox(height: 5),
                            Visibility(
                              visible: timeLineFeedStore.length > 0,
                              child: Container(
                                color: AppColors.white,
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 6),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(
                                        height: getScreenHeight(105),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              TimeLineUserStory(
                                                size:
                                                    MediaQuery.of(context).size,
                                                image: globals
                                                        .user!.profilePicture ??
                                                    '',
                                                isMe: true,
                                                isLive: false,
                                                hasWatched: false,
                                                username: 'Add Status',
                                                isMeOnTap: () async {
                                                  var cameras =
                                                      await availableCameras();
                                                  final res =
                                                      await RouteNavigators
                                                          .route(
                                                              context,
                                                              UserPosting(
                                                                phoneCameras:
                                                                    cameras,
                                                                initialIndex: 0,
                                                              ));
                                                  if (res == null) return;
                                                  timeLineFeedStore
                                                      .addNewStatus(
                                                          res as StatusModel);
                                                  return;
                                                },
                                              ),
                                              if (_myStatus.isEmpty)
                                                const SizedBox.shrink()
                                              else
                                                StatusBubble(
                                                  preview: _myStatus.last,
                                                  statusCount: _myStatus.length,
                                                  username: 'Your Status',
                                                  onTap: () {
                                                    RouteNavigators.route(
                                                        context,
                                                        ViewMyStatus(
                                                            status: _myStatus));
                                                  },
                                                ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              ListView.separated(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          SizedBox(
                                                            width: 16,
                                                          ),
                                                  itemBuilder: (context,
                                                          index) =>
                                                      StatusBubble(
                                                        statusCount:
                                                            _userStatus[index]
                                                                .status!
                                                                .length,
                                                        preview:
                                                            _userStatus[index]
                                                                .status!
                                                                .last
                                                                .status!,
                                                        isMe: false,
                                                        isLive: false,
                                                        username: _userStatus[
                                                                index]
                                                            .status![0]
                                                            .statusOwnerProfile!
                                                            .username!,
                                                        onTap: () async {
                                                          final res = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (c) => ViewUserStatus(
                                                                      isMuted:
                                                                          false,
                                                                      status: _userStatus[
                                                                              index]
                                                                          .status!)));
                                                          if (res == null)
                                                            return;
                                                          if (res
                                                              is MuteResult) {
                                                            timeLineFeedStore
                                                                .muteStatus(
                                                                    index);
                                                          }

                                                          // Navigator.push(
                                                          //     context,
                                                          //     MaterialPageRoute(
                                                          //         builder: (c) =>
                                                          //             const StoryPage()));
                                                        },
                                                      ),
                                                  itemCount:
                                                      _userStatus.length),
                                            ],
                                          ).paddingOnly(left: 11),
                                        ),
                                      ),
                                      SizedBox(height: getScreenHeight(5)),
                                    ]),
                              ),
                            ),
                            SizedBox(height: getScreenHeight(2)),
                            Visibility(
                              visible: timeLineFeedStore.length > 0 &&
                                  _mutedStatus.isNotEmpty,
                              child: Container(
                                color: AppColors.white,
                                child: ListTileTheme(
                                  dense: true,
                                  child: ExpansionTile(
                                    collapsedIconColor: AppColors.greyShade4,
                                    iconColor: AppColors.greyShade4,
                                    title: const Text(
                                      'Muted Statuses',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.greyShade3),
                                    ),
                                    childrenPadding: const EdgeInsets.fromLTRB(
                                        16, 0, 16, 16),
                                    tilePadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    children: [
                                      SizedBox(
                                        height: getScreenHeight(100),
                                        child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            separatorBuilder:
                                                (context, index) => SizedBox(
                                                      width: 16,
                                                    ),
                                            itemBuilder: (context, index) =>
                                                StatusBubble(
                                                  isMuted: true,
                                                  statusCount:
                                                      _mutedStatus[index]
                                                          .status!
                                                          .length,
                                                  preview: _mutedStatus[index]
                                                      .status!
                                                      .last
                                                      .status!,
                                                  isMe: false,
                                                  isLive: false,
                                                  username: _mutedStatus[index]
                                                      .status![0]
                                                      .statusOwnerProfile!
                                                      .username!,
                                                  onTap: () async {
                                                    final res = await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (c) =>
                                                                ViewUserStatus(
                                                                    isMuted:
                                                                        true,
                                                                    status: _mutedStatus[
                                                                            index]
                                                                        .status!)));
                                                    if (res == null) return;
                                                    if (res is MuteResult) {
                                                      timeLineFeedStore
                                                          .unMuteStatus(index);
                                                    }

                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (c) =>
                                                    //             const StoryPage()));
                                                  },
                                                ),
                                            itemCount: _mutedStatus.length),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: value.isEmpty
                                    ? const UserSuggestionWidget()
                                    // ? EmptyTimelineWidget(
                                    //     loading: timeLineFeedStore.gettingPosts)
                                    : SmartRefresher(
                                        physics: const BouncingScrollPhysics(),
                                        onRefresh: () {
                                          timeLineFeedStore.initialize(
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
                                          physics: const ScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          itemBuilder: (context, index) {
                                            TimeLineModel post =
                                                timeLinePosts[index];
                                            return Visibility(
                                              visible: post.isShowing,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 15),
                                                child: Stack(children: [
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
                                                        post: post
                                                            .getPostFeed.post!,
                                                      )),
                                                ]),
                                              ),
                                            );
                                          },
                                          itemCount: timeLineFeedStore.length,
                                        ))),
                          ]);
                    // );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
