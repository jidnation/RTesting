import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reach_me/core/components/bottom_sheet_list_tile.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/account/presentation/views/saved_post.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/data/models/status.model.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';
import 'package:reach_me/features/home/presentation/views/post_reach.dart';

Future showProfileMenuBottomSheet(BuildContext context,
    {required User user, bool isStarring = false}) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.greyShade7,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Container(
                    height: 4,
                    width: 58,
                    decoration: BoxDecoration(
                        color: AppColors.greyShade4,
                        borderRadius: BorderRadius.circular(40))),
              ).paddingOnly(t: 23),
              const SizedBox(height: 20),
              if (user.id != globals.user!.id)
                Column(
                  children: [
                    KebabBottomTextButton(
                        label: isStarring ? 'Unstar Profile' : 'Star Profile',
                        onPressed: () {
                          if (!isStarring) {
                            globals.userBloc!
                                .add(StarUserEvent(userIdToStar: user.id));
                          } else {
                            globals.userBloc!.add(DelStarRelationshipEvent(
                                starIdToDelete: user.id));
                          }
                          RouteNavigators.pop(context);
                        }),
                    KebabBottomTextButton(
                        label: 'Share Profile', onPressed: () {}),
                    //KebabBottomTextButton(label: 'More', onPressed: () {}),
                  ],
                )
              else
                Column(
                  children: [
                    // KebabBottomTextButton(
                    //     label: 'Dictionary',
                    //     onPressed: () =>
                    //         RouteNavigators.route(context, const Dictionary())),
                    // KebabBottomTextButton(
                    //     label: 'Abbreviation',
                    //     onPressed: () => RouteNavigators.route(
                    //         context, const Abbreviation())),
                    // KebabBottomTextButton(
                    //     label: 'Starred Profiles',
                    //     onPressed: () {
                    //       RouteNavigators.route(
                    //           context, const StarredProfileScreen());
                    //     }),
                    // KebabBottomTextButton(
                    //     label: 'QR Code',
                    //     onPressed: () {
                    //       RouteNavigators.route(context, const QRCodeScreen());
                    //     }),
                    KebabBottomTextButton(
                        label: 'Saved Post',
                        onPressed: () {
                          RouteNavigators.route(
                              context, const SavedPostScreen());
                        }),
                    KebabBottomTextButton(
                        label: 'Share Profile',
                        onPressed: () {
                          RouteNavigators.pop(context);
                          Clipboard.setData(
                              ClipboardData(text: globals.user!.profileSlug));
                          Snackbars.success(context,
                              message: 'Profile link copied to clipboard!');
                        }),
                    // KebabBottomTextButton(label: 'More', onPressed: () {}),
                  ],
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      });
}

Future showKebabCommentBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
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
                    height: 4,
                    width: 58,
                    decoration: BoxDecoration(
                        color: AppColors.greyShade4,
                        borderRadius: BorderRadius.circular(40))),
              ).paddingOnly(t: 23),
              const SizedBox(height: 20),
              KebabBottomTextButton(label: 'Delete comment', onPressed: () {}),
              KebabBottomTextButton(label: 'Share', onPressed: () {}),
              const SizedBox(height: 20),
            ]));
      });
}

Future showReacherCardBottomSheet(BuildContext context,
    {required PostFeedModel postFeedModel}) async {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
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
                ).paddingOnly(t: 23),
                SizedBox(height: getScreenHeight(20)),
                if (postFeedModel.postOwnerId != postFeedModel.feedOwnerId)
                  Column(
                    children: [
                      KebabBottomTextButton(
                          label: 'Share post', onPressed: () {}),
                      KebabBottomTextButton(
                          label: 'Save post',
                          onPressed: () {
                            globals.socialServiceBloc!.add(
                                SavePostEvent(postId: postFeedModel.postId));
                          }),
                      KebabBottomTextButton(
                        label: 'Report',
                        onPressed: () {
                          RouteNavigators.pop(context);
                        },
                      ),
                      KebabBottomTextButton(
                        label: 'Reach user',
                        onPressed: () {
                          RouteNavigators.pop(context);
                        },
                      ),
                      KebabBottomTextButton(
                        label: 'Star user',
                        onPressed: () {
                          RouteNavigators.pop(context);
                        },
                      ),
                      KebabBottomTextButton(
                        label: 'Copy link',
                        onPressed: () {
                          RouteNavigators.pop(context);
                          Clipboard.setData(ClipboardData(
                              text: postFeedModel.post!.postSlug!));
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
                            globals.socialServiceBloc!.add(
                                DeletePostEvent(postId: postFeedModel.postId));
                            RouteNavigators.pop(context);
                          }),
                      KebabBottomTextButton(
                        label: 'Share Post',
                        onPressed: () {
                          RouteNavigators.pop(context);
                          Clipboard.setData(ClipboardData(
                              text: postFeedModel.post!.postSlug!));
                          Snackbars.success(context,
                              message: 'Link copied to clipboard');
                        },
                      ),
                      KebabBottomTextButton(
                        label: 'Copy link',
                        onPressed: () {
                          RouteNavigators.pop(context);
                          Clipboard.setData(ClipboardData(
                              text: postFeedModel.post!.postSlug!));
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
}

Future showStoryBottomSheet(BuildContext context,
    {required StatusModel status}) async {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return BlocConsumer<SocialServiceBloc, SocialServiceState>(
        bloc: globals.socialServiceBloc,
        listener: (context, state) {},
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
                ).paddingOnly(t: 23),
                SizedBox(height: getScreenHeight(20)),
                Column(
                  children: [
                    KebabBottomTextButton(
                      label: 'Report',
                      onPressed: () {},
                      color: const Color(0xFFE50101),
                    ),
                    KebabBottomTextButton(label: 'Reach', onPressed: () {}),
                    KebabBottomTextButton(label: 'Star user', onPressed: () {}),
                    KebabBottomTextButton(label: 'Copy link', onPressed: () {}),
                    KebabBottomTextButton(label: 'Share', onPressed: () {}),
                    KebabBottomTextButton(label: 'Mute', onPressed: () {}),
                  ],
                ),
                SizedBox(height: getScreenHeight(20)),
              ]));
        },
      );
    },
  );
}

Future showUserStoryBottomSheet(BuildContext context,
    {required StatusFeedResponseModel status}) async {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return BlocConsumer<SocialServiceBloc, SocialServiceState>(
        bloc: globals.socialServiceBloc,
        listener: (context, state) {},
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
                ).paddingOnly(t: 23),
                SizedBox(height: getScreenHeight(20)),
                Column(
                  children: [
                    KebabBottomTextButton(
                      label: 'Report',
                      onPressed: () {},
                      color: const Color(0xFFE50101),
                    ),
                    KebabBottomTextButton(label: 'Reach', onPressed: () {}),
                    KebabBottomTextButton(label: 'Star user', onPressed: () {}),
                    KebabBottomTextButton(label: 'Copy link', onPressed: () {}),
                    KebabBottomTextButton(label: 'Share', onPressed: () {}),
                    KebabBottomTextButton(label: 'Mute', onPressed: () {}),
                  ],
                ),
                SizedBox(height: getScreenHeight(20)),
              ]));
        },
      );
    },
  );
}
