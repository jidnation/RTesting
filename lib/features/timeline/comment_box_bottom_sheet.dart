import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../core/components/bottom_sheet_list_tile.dart';
import '../../core/components/snackbar.dart';
import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/app_globals.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/dimensions.dart';
import '../home/data/models/comment_model.dart';
import '../home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import '../home/presentation/bloc/user-bloc/user_bloc.dart';
import '../home/presentation/views/post_reach.dart';
// import '../home/presentation/views/esentation/views/repost_reach.dart';

Future showCommentTimeLineCardBottomSheet(BuildContext context,
    {required CommentModel commentModel, void Function()? downloadPost}) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      // Post? postFeedModel = timeLineModel.getPostFeed.post;
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
          // if (state is DeleteSavedPostSuccess) {
          //   RouteNavigators.pop(context);
          //   Snackbars.success(context, message: 'Post removed successfully');
          // }
          // if (state is DeleteSavedPostError) {
          //   RouteNavigators.pop(context);
          //   Snackbars.error(context, message: state.error);
          // }
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
                // RouteNavigators.pop(context);
                Get.close(2);
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
                    // if (postFeedModel!.postOwnerProfile!.authId !=
                    //     globals.userId)
                    Column(children: [
                      // KebabBottomTextButton(
                      //     label: 'Quote Comment',
                      //     onPressed: () {
                      //       RouteNavigators.pop(context);
                      //       // RouteNavigators.route(
                      //       //     context,
                      //       //     RepostReach(
                      //       //       postFeedModel:
                      //       //           timeLineFeedStore.getPostModel(
                      //       //               timeLineModel: timeLineModel),
                      //       //     ));
                      //     }),
                      KebabBottomTextButton(
                          label: 'Download Reach Card',
                          onPressed: downloadPost),
                      Visibility(
                        visible: commentModel.authId != globals.userId,
                        child: KebabBottomTextButton(
                          label: 'Reach user',
                          onPressed: () {
                            globals.showLoader(context);
                            globals.userBloc!.add(
                              ReachUserEvent(
                                  userIdToReach: commentModel.authId),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: commentModel.authId != globals.userId,
                        child: KebabBottomTextButton(
                          label: 'Star user',
                          onPressed: () {
                            globals.showLoader(context);
                            globals.userBloc!.add(
                              StarUserEvent(userIdToStar: commentModel.authId),
                            );
                          },
                        ),
                      ),
                    ]),
                    SizedBox(height: getScreenHeight(20)),
                  ]));
            },
          );
        },
      );
    },
  );
}
