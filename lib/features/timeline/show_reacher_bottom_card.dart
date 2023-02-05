import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:reach_me/features/timeline/models/post_feed.dart';
import 'package:reach_me/features/timeline/timeline_control_room.dart';
import 'package:reach_me/features/timeline/timeline_feed.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/components/bottom_sheet_list_tile.dart';
import '../../core/components/snackbar.dart';
import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/app_globals.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/dimensions.dart';
import '../home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import '../home/presentation/bloc/user-bloc/user_bloc.dart';
import '../home/presentation/views/post_reach.dart';
import '../home/presentation/views/repost_reach.dart';

Future showReacherTimeLineCardBottomSheet(BuildContext context,
    {required TimeLineModel timeLineModel, void Function()? downloadPost, required String type}) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      Post? postFeedModel = timeLineModel.getPostFeed.post;
      return BlocConsumer<SocialServiceBloc, SocialServiceState>(
        bloc: globals.socialServiceBloc,
        listener: (context, state) {
          if (state is GetPostSuccess) {
            RouteNavigators.pop(context);
            RouteNavigators.route(context, EditReach(post: state.data!));
          }
          if (state is GetPostError) {
            RouteNavigators.pop(context);
            Snackbars.error(context, message: state.error);
          }
          if (state is SavePostSuccess) {
            RouteNavigators.pop(context);
            Snackbars.success(context, message: 'Post saved successfully');
          }
          if (state is SavePostError) {
            RouteNavigators.pop(context);
            Snackbars.error(context, message: state.error);
          }
          if (state is DeleteSavedPostSuccess) {
            RouteNavigators.pop(context);
            Snackbars.success(context, message: 'Post removed successfully');
          }
          if (state is DeleteSavedPostError) {
            RouteNavigators.pop(context);
            Snackbars.error(context, message: state.error);
          }
        },
        builder: (context, state) {
          bool _isLoading = state is GetPostLoading;
          return BlocConsumer<UserBloc, UserState>(
            bloc: globals.userBloc,
            listener: (context, state) {
              if (state is UserLoaded) {
                Snackbars.success(context,
                    message: "Reached user successfully");
                RouteNavigators.pop(context);
              }
              if (state is UserError) {
                RouteNavigators.pop(context);
                RouteNavigators.pop(context);
                Snackbars.error(context, message: state.error);
              }
              if (state is StarUserSuccess) {
                RouteNavigators.pop(context);
                Snackbars.success(context,
                    message: 'User starred successfully!');
              }
            },
            builder: (context, state) {
              return Container(
                  decoration: const BoxDecoration(
                    color: AppColors.greyShade7,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: ListView(shrinkWrap: true, children: [
                    Center(
                      child: Container(
                          height: getScreenHeight(4),
                          width: getScreenWidth(58),
                          decoration: BoxDecoration(
                              color: AppColors.greyShade4,
                              borderRadius: BorderRadius.circular(40))),
                    ).paddingOnly(top: 23),
                    SizedBox(height: getScreenHeight(20)),
                    if (postFeedModel!.postOwnerProfile!.authId !=
                        globals.userId)
                      Column(
                        children: [
                          KebabBottomTextButton(
                              label: 'Share post',
                              onPressed: () {
                                RouteNavigators.pop(context);
                                Share.share(
                                    'Have fun viewing this: ${postFeedModel.postSlug!}');
                              }),
                          KebabBottomTextButton(
                              label: 'Quote post',
                              onPressed: () {
                                RouteNavigators.pop(context);
                                RouteNavigators.route(
                                    context,
                                    RepostReach(
                                      postFeedModel:
                                          timeLineFeedStore.getPostModel(
                                              timeLineModel: timeLineModel),
                                    ));
                              }),
                          KebabBottomTextButton(
                              label: 'Save post',
                              onPressed: () {
                                globals.socialServiceBloc!.add(SavePostEvent(
                                    postId: postFeedModel.postId));
                              }),
                          KebabBottomTextButton(
                              label: 'Download Reach Card',
                              onPressed: downloadPost),
                          // KebabBottomTextButton(
                          //   label: 'Report',
                          //   onPressed: () {
                          //     RouteNavigators.pop(context);
                          //     RouteNavigators.route(context,
                          //         RepostReach(postFeedModel: timeLineFeedStore.getPostModel(timeLineModel: timeLineModel)));
                          //   },
                          // ),
                          KebabBottomTextButton(
                            label: 'Reach user',
                            onPressed: () {
                              globals.showLoader(context);
                              globals.userBloc!.add(ReachUserEvent(
                                  userIdToReach:
                                      postFeedModel.postOwnerProfile!.authId));
                            },
                          ),
                          KebabBottomTextButton(
                            label: 'Star user',
                            onPressed: () {
                              globals.showLoader(context);
                              globals.userBloc!.add(StarUserEvent(
                                  userIdToStar:
                                      postFeedModel.postOwnerProfile!.authId));
                            },
                          ),
                          KebabBottomTextButton(
                            label: 'Copy link',
                            onPressed: () {
                              RouteNavigators.pop(context);
                              Clipboard.setData(
                                  ClipboardData(text: postFeedModel.postSlug!));
                              Snackbars.success(context,
                                  message: 'Link copied to clipboard');
                            },
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          KebabBottomTextButton(
                              label: 'Edit content',
                              isLoading: _isLoading,
                              onPressed: () {
                                globals.socialServiceBloc!.add(
                                    GetPostEvent(postId: postFeedModel.postId));
                              }),
                          KebabBottomTextButton(
                              label: 'Delete post',
                              onPressed: () {
                                globals.socialServiceBloc!.add(DeletePostEvent(
                                    postId: postFeedModel.postId));
                                RouteNavigators.pop(context);
                                timeLineFeedStore.removePost(
                                    context, timeLineModel.id,
                                    type: type,
                                    isDelete: true);
                              }),
                          KebabBottomTextButton(
                            label: 'Share Post',
                            onPressed: () {
                              RouteNavigators.pop(context);
                              Share.share(
                                  'Have fun viewing this: https://${postFeedModel.postSlug!}');
                            },
                          ),
                          KebabBottomTextButton(
                              label: 'Download Reach Card',
                              onPressed: downloadPost),
                          KebabBottomTextButton(
                            label: 'Copy link',
                            onPressed: () {
                              RouteNavigators.pop(context);
                              Clipboard.setData(
                                  ClipboardData(text: postFeedModel.postSlug!));
                              Snackbars.success(context,
                                  message: 'Link copied to clipboard');
                            },
                          ),
                        ],
                      ),
                    SizedBox(height: getScreenHeight(20)),
                  ]));
            },
          );
        },
      );
    },
  );
}
