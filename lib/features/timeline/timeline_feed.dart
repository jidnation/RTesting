import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:reach_me/features/timeline/post_control_room.dart';
import 'package:reach_me/features/timeline/timeline_action-box.dart';
import 'package:reach_me/features/timeline/timeline_box.dart';
import 'package:reach_me/features/timeline/timeline_control_room.dart';

import '../../core/components/empty_state.dart';
import '../../core/components/profile_picture.dart';
import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/app_globals.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/dimensions.dart';
import '../chat/presentation/views/chats_list_screen.dart';
import '../home/presentation/bloc/user-bloc/user_bloc.dart';
import '../home/presentation/views/post_reach.dart';

class TimeLineFeed extends StatefulWidget {
  static const String id = "timeline_screen";
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const TimeLineFeed({Key? key, this.scaffoldKey}) : super(key: key);

  @override
  State<TimeLineFeed> createState() => _TimeLineFeedState();
}

final TimeLineFeedStore timeLineFeedStore = TimeLineFeedStore();
final PostStore postStore = PostStore();

class _TimeLineFeedState extends State<TimeLineFeed> {
  @override
  void initState() {
    super.initState();
    globals.userBloc!.add(GetUserProfileEvent(email: globals.userId!));
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: SafeArea(
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
                    RouteNavigators.route(context, const PostReach()),
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
              child: Column(children: [
                // Visibility(
                //   visible: _posts.value.isNotEmpty,
                //   child: Container(
                //     color: AppColors.white,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.stretch,
                //       children: [
                //         SizedBox(
                //           height: getScreenHeight(105),
                //           child: SingleChildScrollView(
                //             scrollDirection: Axis.horizontal,
                //             physics: const BouncingScrollPhysics(),
                //             child: SizedBox(
                //               child: Row(
                //                 children: [
                //                   UserStory(
                //                     size: size,
                //                     image: globals.user!.profilePicture ?? '',
                //                     isMe: true,
                //                     isLive: false,
                //                     hasWatched: false,
                //                     username: 'Add Status',
                //                     isMeOnTap: () async {
                //                       var cameras = await availableCameras();
                //                       RouteNavigators.route(
                //                           context,
                //                           UserPosting(
                //                             phoneCameras: cameras,
                //                             initialIndex: 0,
                //                           ));
                //                       return;
                //                     },
                //                   ),
                //                   if (_myStatus.value.isEmpty)
                //                     const SizedBox.shrink()
                //                   else
                //                     UserStory(
                //                       size: size,
                //                       image: globals.user!.profilePicture ?? '',
                //                       isMe: false,
                //                       isLive: false,
                //                       hasWatched: false,
                //                       username: 'Your status',
                //                       onTap: () {
                //                         RouteNavigators.route(context,
                //                             ViewMyStatus(status: _myStatus.value));
                //                       },
                //                     ),
                //                   ...List.generate(
                //                     _userStatus.value.length,
                //                     (index) => UserStory(
                //                       size: size,
                //                       isMe: false,
                //                       isLive: false,
                //                       hasWatched: false,
                //                       image: _userStatus.value[index].status![0]
                //                           .statusOwnerProfile!.profilePicture,
                //                       username: _userStatus
                //                           .value[index]
                //                           .status![index]
                //                           .statusOwnerProfile!
                //                           .username!,
                //                       onTap: () async {
                //                         // RouteNavigators
                //                         //     .route(
                //                         //   context,
                //                         //   ViewUserStatus(
                //                         //       status: _userStatus
                //                         //           .value[
                //                         //               index]
                //                         //           .status!),
                //                         // );
                //                         final res = await Navigator.push(
                //                             context,
                //                             MaterialPageRoute(
                //                                 builder: (c) => ViewUserStatus(
                //                                     isMuted: false,
                //                                     status: _userStatus
                //                                         .value[index].status!)));
                //                         if (res == null) return;
                //                         if (res is MuteResult) {
                //                           _mutedStatus.value = [
                //                             ..._mutedStatus.value,
                //                             _userStatus.value[index]
                //                           ];
                //                           _userStatus.value = [..._userStatus.value]
                //                             ..removeAt(index);
                //                         }
                //                       },
                //                     ),
                //                   ),
                //                   // ..._userStatus.value.map(
                //                   //   (e) =>
                //                   // ),
                //                 ],
                //               ),
                //             ).paddingOnly(left: 11),
                //           ),
                //         ),
                //         SizedBox(height: getScreenHeight(5)),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),
                ValueListenableBuilder(
                    valueListenable: TimeLineFeedStore(),
                    builder: (context, List<TimeLineModel> value, child) {
                      print('from the timeLine room.........??? $value }');
                      final List<TimeLineModel> timeLinePosts = value;
                      return timeLineFeedStore.gettingPosts
                          ? const Expanded(
                              child: SingleChildScrollView(
                                child: SkeletonLoadingWidget(),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemBuilder: (context, index) {
                                TimeLineModel post = timeLinePosts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Stack(children: [
                                    TimeLineBox(
                                      timeLineModel: post,
                                    ),
                                    Positioned(
                                        bottom: 10,
                                        left: 30,
                                        right: 30,
                                        child: ValueListenableBuilder(
                                            valueListenable: PostStore(),
                                            builder: (context,
                                                List<CustomPostModel> value,
                                                child) {
                                              print(
                                                  'from the timeLine room.........??? $value }');
                                              final List<CustomPostModel>
                                                  posts = value;
                                              return TimeLineBoxActionRow(
                                                timeLineId: post.id,
                                                posts: posts,
                                              );
                                            })),
                                  ]),
                                );
                              },
                              itemCount: timeLineFeedStore.length,
                            ));
                    }),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
