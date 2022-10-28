import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reach_me/core/components/empty_state.dart';
import 'package:reach_me/core/components/refresher.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/database/secure_storage.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/core/utils/location.helper.dart';
import 'package:reach_me/features/account/presentation/views/account.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/features/auth/presentation/views/login_screen.dart';
import 'package:reach_me/features/chat/presentation/views/chats_list_screen.dart';
import 'package:reach_me/features/chat/presentation/views/msg_chat_interface.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/data/models/status.model.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';
import 'package:reach_me/features/home/presentation/views/post_reach.dart';
import 'package:reach_me/features/home/presentation/views/status/create.status.dart';
import 'package:reach_me/features/home/presentation/views/status/view.status.dart';
import 'package:reach_me/features/home/presentation/views/view_comments.dart';
import 'package:readmore/readmore.dart';
import 'package:screenshot/screenshot.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimelineScreen extends StatefulHookWidget {
  static const String id = "timeline_screen";
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const TimelineScreen({Key? key, this.scaffoldKey}) : super(key: key);

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with AutomaticKeepAliveClientMixin<TimelineScreen> {
  @override
  bool get wantKeepAlive => true;
  bool _firstLoad = true;
  int backPressCounter = 0;
  int backPressTotal = 2;

  @override
  void initState() {
    super.initState();
    globals.userBloc!.add(GetUserProfileEvent(email: globals.userId!));
    globals.socialServiceBloc!
        .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
    globals.socialServiceBloc!
        .add(GetAllStatusEvent(pageLimit: 50, pageNumber: 1));
    globals.socialServiceBloc!
        .add(GetStatusFeedEvent(pageLimit: 50, pageNumber: 1));
    LocationHelper.determineLocation().then((value) {
      if (value is LocationData) {
        globals.userBloc!.add(GetUserLocationEvent(
          lat: value.latitude.toString(),
          lng: value.longitude.toString(),
        ));
      }
    });
  }

  Set active = {};

  handleTap(index) {
    if (active.isNotEmpty) active.clear();
    setState(() {
      active.add(index);
    });
  }

  final _refreshController = RefreshController();

  Future<void> onRefresh() async {
    SocialServiceBloc();
    globals.socialServiceBloc!
        .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
    globals.socialServiceBloc!
        .add(GetAllStatusEvent(pageLimit: 50, pageNumber: 1));
    globals.socialServiceBloc!
        .add(GetStatusFeedEvent(pageLimit: 50, pageNumber: 1));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final reachDM = useState(false);
    final _posts = useState<List<PostFeedModel>>([]);
    final _myStatus = useState<List<StatusModel>>([]);
    final _userStatus = useState<List<StatusFeedModel>>([]);
    var size = MediaQuery.of(context).size;
    print(globals.token);
    return Scaffold(
      extendBodyBehindAppBar: true,
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
            icon: Helper.renderProfilePicture(globals.user!.profilePicture)),
        titleSpacing: 5,
        leadingWidth: getScreenWidth(70),
        title: Text(
          'Reachme',
          style: TextStyle(
            color: const Color(0xFF001824),
            fontSize: getScreenHeight(20),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/svgs/edit.svg',
              width: getScreenWidth(22),
              height: getScreenHeight(22),
            ),
            onPressed: () => RouteNavigators.route(context, const PostReach()),
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
          ).paddingOnly(r: 16),
        ],
      ),
      body: ProgressHUD(
        child: SafeArea(
          top: false,
          child: BlocConsumer<UserBloc, UserState>(
            bloc: globals.userBloc,
            listener: (context, state) {
              if (state is RecipientUserData) {
                reachDM.value = false;
                if (reachDM.value) {
                  RouteNavigators.route(
                      context, MsgChatInterface(recipientUser: state.user));
                }
              }
              if (state is UserError) {
                reachDM.value = false;
              }
            },
            builder: (context, state) {
              return BlocConsumer<SocialServiceBloc, SocialServiceState>(
                bloc: globals.socialServiceBloc,
                listener: (context, state) {
                  if (state is UploadMediaError) {
                    Snackbars.error(context,
                        message: 'Failed to upload media in post');
                  }

                  if (state is UploadMediaSuccess) {
                    globals.socialServiceBloc!.add(CreatePostEvent(
                      content: globals.postContent,
                      commentOption: globals.postCommentOption,
                      imageMediaItem: state.data as List<String>,
                      location: globals.location,
                    ));
                  }
                  if (state is CreatePostError) {
                    Snackbars.error(context, message: state.error);
                  }

                  if (state is CreatePostSuccess) {
                    globals.socialServiceBloc!
                        .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
                    Snackbars.success(context,
                        message: 'Your reach has been posted');
                  }

                  if (state is GetPostFeedError) {
                    Snackbars.error(context, message: state.error);
                    if (state.error.contains('session')) {
                      SecureStorage.deleteSecureData();
                      RouteNavigators.routeNoWayHome(
                          context, const LoginScreen());
                    }
                  }

                  if (state is GetAllStatusSuccess) {
                    _myStatus.value = state.status!;
                  }

                  if (state is GetStatusFeedSuccess) {
                    _userStatus.value = state.status!;
                  }

                  if (state is GetAllStatusError) {
                    Snackbars.error(context, message: state.error);
                  }

                  if (state is VotePostSuccess) {
                    globals.socialServiceBloc!
                        .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
                  }

                  if (state is GetPostFeedSuccess) {
                    _firstLoad = false;
                    _posts.value = (state.posts!);
                    _posts.value.sort((a, b) => b.post!.createdAt!
                        .toIso8601String()
                        .compareTo(a.post!.createdAt!.toIso8601String()));
                    _refreshController.refreshCompleted();
                  }

                  if (state is LikePostSuccess || state is UnlikePostSuccess) {
                    globals.socialServiceBloc!
                        .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
                  }

                  if (state is DeletePostSuccess) {
                    globals.socialServiceBloc!
                        .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
                    Snackbars.success(context,
                        message: 'Your reach has been deleted!');
                  }
                  if (state is DeletePostError) {
                    Snackbars.error(context, message: state.error);
                  }
                  if (state is EditContentSuccess) {
                    globals.socialServiceBloc!
                        .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
                    Snackbars.success(context,
                        message: 'Your reach has been edited!');
                  }
                  if (state is EditContentError) {
                    Snackbars.error(context, message: state.error);
                  }

                  if (state is CreateStatusError) {
                    Snackbars.error(context, message: state.error);
                  }

                  if (state is CreateStatusSuccess) {
                    globals.socialServiceBloc!
                        .add(GetAllStatusEvent(pageLimit: 50, pageNumber: 1));
                    Snackbars.success(context,
                        message: "Your status has been posted");
                  }
                },
                builder: (context, state) {
                  bool _isLoading = state is CreatePostLoading;
                  _isLoading = state is GetPostFeedLoading;
                  _isLoading = state is DeletePostLoading;
                  _isLoading = state is EditContentLoading;

                  bool _likingPost = state is LikePostLoading;
                  bool _unLikingPost = state is UnlikePostLoading;
                  // _likingPost = state is GetPostFeedLoading;

                  return GestureDetector(
                    onHorizontalDragEnd: (dragEndDetails) {
                      if (dragEndDetails.primaryVelocity! < 0) {
                        // Swipe Right

                      } else if (dragEndDetails.primaryVelocity! > 0) {
                        // Swipe Left
                        widget.scaffoldKey!.currentState!.openDrawer();
                      }
                    },
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          child: (_firstLoad)
                              ? const SkeletonLoadingWidget()
                              : SizedBox(
                                  child: Refresher(
                                    onRefresh: onRefresh,
                                    controller: _refreshController,
                                    child: ListView(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: false,
                                      children: [
                                        SizedBox(
                                            height: 0,
                                            child: Divider(
                                              color: const Color(0xFFE3E5E7)
                                                  .withOpacity(0.5),
                                            )),
                                        SizedBox(
                                            height: kToolbarHeight +
                                                getScreenHeight(22)), //30
                                        _isLoading
                                            ? const LinearLoader()
                                            : const SizedBox.shrink(),
                                        Container(
                                          color: AppColors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              SizedBox(
                                                height: getScreenHeight(105),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  child: SizedBox(
                                                    child: Row(
                                                      children: [
                                                        UserStory(
                                                          size: size,
                                                          image: globals.user!
                                                                  .profilePicture ??
                                                              '',
                                                          isMe: true,
                                                          isLive: false,
                                                          hasWatched: false,
                                                          username:
                                                              'Add Status',
                                                          isMeOnTap: () {
                                                            RouteNavigators.route(
                                                                context,
                                                                const CreateStatus());
                                                            return;
                                                          },
                                                        ),
                                                        if (_myStatus
                                                            .value.isEmpty)
                                                          const SizedBox
                                                              .shrink()
                                                        else
                                                          UserStory(
                                                            size: size,
                                                            image: globals.user!
                                                                    .profilePicture ??
                                                                '',
                                                            isMe: false,
                                                            isLive: false,
                                                            hasWatched: false,
                                                            username:
                                                                'Your status',
                                                            onTap: () {
                                                              RouteNavigators.route(
                                                                  context,
                                                                  ViewMyStatus(
                                                                      status: _myStatus
                                                                          .value));
                                                            },
                                                          ),
                                                        ...List.generate(
                                                          _userStatus
                                                              .value.length,
                                                          (index) => UserStory(
                                                            size: size,
                                                            isMe: false,
                                                            isLive: false,
                                                            hasWatched: false,
                                                            image: _userStatus
                                                                .value[index]
                                                                .status![0]
                                                                .statusCreatorModel!
                                                                .profilePicture,
                                                            username: _userStatus
                                                                .value[index]
                                                                .status![0]
                                                                .statusCreatorModel!
                                                                .username!,
                                                            onTap: () {
                                                              RouteNavigators
                                                                  .route(
                                                                context,
                                                                ViewUserStatus(
                                                                    status: _userStatus
                                                                        .value[
                                                                            index]
                                                                        .status!),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ).paddingOnly(l: 11),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: getScreenHeight(5)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: getScreenHeight(16)),
                                        SizedBox(
                                          child: _posts.value.isEmpty
                                              ? EmptyTimelineWidget(
                                                  loading: _isLoading)
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      _posts.value.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return PostFeedReacherCard(
                                                      likingPost: false,
                                                      postFeedModel:
                                                          _posts.value[index],
                                                      isLiked: _posts
                                                              .value[index]
                                                              .like!
                                                              .isNotEmpty
                                                          ? true
                                                          : false,
                                                      isVoted: _posts
                                                              .value[index]
                                                              .vote!
                                                              .isNotEmpty
                                                          ? true
                                                          : false,
                                                      voteType: _posts
                                                              .value[index]
                                                              .vote!
                                                              .isNotEmpty
                                                          ? _posts.value[index]
                                                              .vote![0].voteType
                                                          : null,
                                                      onMessage: () {
                                                        HapticFeedback
                                                            .mediumImpact();
                                                        reachDM.value = true;

                                                        handleTap(index);
                                                        if (active
                                                            .contains(index)) {
                                                          globals.userBloc!.add(
                                                              GetRecipientProfileEvent(
                                                                  email: _posts
                                                                      .value[
                                                                          index]
                                                                      .postOwnerId!));
                                                        }
                                                      },
                                                      onUpvote: () {
                                                        HapticFeedback
                                                            .mediumImpact();

                                                        handleTap(index);
                                                        if (active
                                                            .contains(index)) {
                                                          globals
                                                              .socialServiceBloc!
                                                              .add(
                                                                  VotePostEvent(
                                                            voteType: 'Upvote',
                                                            postId: _posts
                                                                .value[index]
                                                                .postId,
                                                          ));
                                                        }
                                                      },
                                                      onDownvote: () {
                                                        HapticFeedback
                                                            .mediumImpact();

                                                        handleTap(index);
                                                        if (active
                                                            .contains(index)) {
                                                          globals
                                                              .socialServiceBloc!
                                                              .add(
                                                                  VotePostEvent(
                                                            voteType:
                                                                'Downvote',
                                                            postId: _posts
                                                                .value[index]
                                                                .postId,
                                                          ));
                                                        }
                                                      },
                                                      onLike: () {
                                                        HapticFeedback
                                                            .mediumImpact();
                                                        handleTap(index);
                                                        if (active
                                                            .contains(index)) {
                                                          if (_posts
                                                              .value[index]
                                                              .like!
                                                              .isNotEmpty) {
                                                            globals
                                                                .socialServiceBloc!
                                                                .add(
                                                                    UnlikePostEvent(
                                                              postId: _posts
                                                                  .value[index]
                                                                  .postId,
                                                            ));
                                                          } else {
                                                            globals
                                                                .socialServiceBloc!
                                                                .add(
                                                              LikePostEvent(
                                                                  postId: _posts
                                                                      .value[
                                                                          index]
                                                                      .postId),
                                                            );
                                                          }
                                                        }
                                                      },
                                                    );
                                                  },
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        )
                      ],
                    ).paddingOnly(t: 10),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  userStoryModal(BuildContext context, List<StatusModel> status) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            Column(children: [
              ListTile(
                title: const Text('Create new story'),
                onTap: () {
                  RouteNavigators.pop(context);
                  RouteNavigators.route(context, const CreateStatus());
                },
              ),
              status.isEmpty
                  ? const SizedBox.shrink()
                  : ListTile(
                      title: const Text('View your story'),
                      onTap: () {
                        RouteNavigators.pop(context);
                        RouteNavigators.route(context,
                            ViewMyStatus(status: status.reversed.toList()));
                      },
                    ),
            ]).paddingSymmetric(v: 5),
          ],
        );
      },
    );
  }
}

class PostFeedReacherCard extends HookWidget {
  const PostFeedReacherCard({
    Key? key,
    required this.postFeedModel,
    required this.likingPost,
    this.onDownvote,
    this.onLike,
    this.onMessage,
    this.onUpvote,
    this.routeProfile,
    required this.isVoted,
    required this.voteType,
    required this.isLiked,
  }) : super(key: key);

  final PostFeedModel? postFeedModel;
  final bool likingPost;
  final Function()? onLike, onMessage, onUpvote, onDownvote, routeProfile;
  final bool isLiked, isVoted;
  final String? voteType;

  @override
  Widget build(BuildContext context) {
    final postDuration = timeago.format(postFeedModel!.post!.createdAt!);

    final ScreenshotController screenshotController = ScreenshotController();
    Future<String> saveImage(Uint8List? bytes) async {
      await [Permission.storage].request();
      String time = DateTime.now().microsecondsSinceEpoch.toString();
      final name = 'screenshot_${time}_reachme';
      final result = await ImageGallerySaver.saveImage(bytes!, name: name);
      debugPrint("Result ${result['filePath']}");
      Snackbars.success(context, message: 'Image saved to Gallery');
      return result['filePath'];
    }

    void takeScreenShotAndSave() async {
      final image = await screenshotController.capture();
      if (image == null) debugPrint("Image $image");

      await saveImage(image);
      // final directory = (await getApplicationDocumentsDirectory())
      //     .path; //from path_provide package
      // String fileName =
      //     "Screenshot_${DateTime.now().microsecondsSinceEpoch.toString()}_reach_me.png";
      // String path = directory;
      //
      // screenshotController.captureAndSave(path, fileName: fileName);
      //
      // debugPrint("ScreenShot taken");
      // debugPrint("Path: $path");
      // debugPrint("FileName: $fileName");
    }

    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        right: getScreenWidth(15),
        left: getScreenWidth(15),
        bottom: getScreenHeight(16),
      ),
      child: Screenshot(
        controller: screenshotController,
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      final progress = ProgressHUD.of(context);
                      progress?.showWithText('Viewing Reacher..');
                      Future.delayed(const Duration(seconds: 3), () {
                        globals.userBloc!.add(GetRecipientProfileEvent(
                            email: postFeedModel!.postOwnerId));
                        postFeedModel!.postOwnerId == globals.user!.id
                            ? RouteNavigators.route(
                                context, const AccountScreen())
                            : RouteNavigators.route(
                                context,
                                RecipientAccountProfile(
                                  recipientEmail: 'email',
                                  recipientImageUrl:
                                      postFeedModel!.profilePicture,
                                  recipientId: postFeedModel!.postOwnerId,
                                ));
                        progress?.dismiss();
                      });
                    },
                    child: Row(
                      children: [
                        Helper.renderProfilePicture(
                          postFeedModel!.profilePicture,
                          size: 33,
                        ).paddingOnly(l: 13, t: 10),
                        SizedBox(width: getScreenWidth(9)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '@${postFeedModel!.username!}',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(14),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor2,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                postFeedModel!.verified!
                                    ? SvgPicture.asset(
                                        'assets/svgs/verified.svg')
                                    : const SizedBox.shrink()
                              ],
                            ),
                            Row(
                              children: [
                                postFeedModel!.post!.location == null ||
                                        postFeedModel!.post!.location == 'NIL'
                                    ? const SizedBox.shrink()
                                    : Text(
                                        globals.user!.showLocation!
                                            ? postFeedModel!.post!.location!
                                            : '',
                                        // postFeedModel!.post!.location ??
                                        //     'Somewhere',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(10),
                                          fontFamily: 'Poppins',
                                          letterSpacing: 0.4,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.textColor2,
                                        ),
                                      ),
                                Text(
                                  postDuration,
                                  style: TextStyle(
                                    fontSize: getScreenHeight(10),
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.4,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textColor2,
                                  ),
                                ).paddingOnly(l: 6),
                              ],
                            )
                          ],
                        ).paddingOnly(t: 10),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  SvgPicture.asset('assets/svgs/starred.svg'),
                      SizedBox(width: getScreenWidth(9)),
                      IconButton(
                        onPressed: () async {
                          await showReacherCardBottomSheet(
                            context,
                            downloadPost: takeScreenShotAndSave,
                            postFeedModel: postFeedModel!,
                          );
                        },
                        iconSize: getScreenHeight(19),
                        padding: const EdgeInsets.all(0),
                        icon: SvgPicture.asset('assets/svgs/kebab card.svg'),
                      ),
                    ],
                  )
                ],
              ),
              postFeedModel!.post!.content == null
                  ? const SizedBox.shrink()
                  : Flexible(
                      child: ReadMoreText(
                        postFeedModel!.post!.edited!
                            ? "${postFeedModel!.post!.content ?? ''} (edited)"
                            : postFeedModel!.post!.content ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: getScreenHeight(14)),
                        trimLines: 3,
                        colorClickableText: const Color(0xff717F85),
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'See more',
                        trimExpandedText: 'See less',
                        moreStyle: TextStyle(
                            fontSize: getScreenHeight(14),
                            fontFamily: "Roboto",
                            color: const Color(0xff717F85)),
                      ).paddingSymmetric(h: 16, v: 10),
                    ),
              if (postFeedModel!.post!.imageMediaItems!.isNotEmpty)
                Helper.renderPostImages(postFeedModel!.post!, context)
                    .paddingOnly(r: 16, l: 16, b: 16, t: 10)
              else
                const SizedBox.shrink(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFFF5F5F5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CupertinoButton(
                            minSize: 0,
                            onPressed: onLike,
                            padding: EdgeInsets.zero,
                            child: isLiked
                                ? SvgPicture.asset(
                                    'assets/svgs/like-active.svg',
                                    height: getScreenHeight(20),
                                    width: getScreenWidth(20),
                                  )
                                : SvgPicture.asset(
                                    'assets/svgs/like.svg',
                                    height: getScreenHeight(20),
                                    width: getScreenWidth(20),
                                  ),
                          ),
                          SizedBox(width: getScreenWidth(4)),
                          FittedBox(
                            child: Text(
                              '${postFeedModel!.post!.nLikes}',
                              style: TextStyle(
                                fontSize: getScreenHeight(12),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor3,
                              ),
                            ),
                          ),
                          SizedBox(width: getScreenWidth(15)),
                          CupertinoButton(
                            minSize: 0,
                            onPressed: () {
                              RouteNavigators.route(context,
                                  ViewCommentsScreen(post: postFeedModel!));
                            },
                            padding: EdgeInsets.zero,
                            child: SvgPicture.asset(
                              'assets/svgs/comment.svg',
                              height: getScreenHeight(20),
                              width: getScreenWidth(20),
                            ),
                          ),
                          SizedBox(width: getScreenWidth(4)),
                          FittedBox(
                            child: Text(
                              '${postFeedModel!.post!.nComments}',
                              style: TextStyle(
                                fontSize: getScreenHeight(12),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor3,
                              ),
                            ),
                          ),
                          if (postFeedModel!.postOwnerId !=
                              postFeedModel!.feedOwnerId)
                            SizedBox(width: getScreenWidth(15)),
                          if (postFeedModel!.postOwnerId !=
                              postFeedModel!.feedOwnerId)
                            CupertinoButton(
                              minSize: 0,
                              onPressed: onMessage,
                              padding: const EdgeInsets.all(0),
                              child: SvgPicture.asset(
                                'assets/svgs/message.svg',
                                height: getScreenHeight(20),
                                width: getScreenWidth(20),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: getScreenWidth(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color(0xFFF5F5F5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CupertinoButton(
                                minSize: 0,
                                onPressed: onUpvote,
                                padding: EdgeInsets.zero,
                                child: isVoted && voteType == 'Upvote'
                                    ? SvgPicture.asset(
                                        'assets/svgs/shoutup-active.svg',
                                        height: getScreenHeight(20),
                                        width: getScreenWidth(20),
                                      )
                                    : SvgPicture.asset(
                                        'assets/svgs/shoutup.svg',
                                        height: getScreenHeight(20),
                                        width: getScreenWidth(20),
                                      ),
                              ),
                              Flexible(
                                  child: SizedBox(width: getScreenWidth(4))),
                              Flexible(
                                  child: SizedBox(width: getScreenWidth(4))),
                              CupertinoButton(
                                minSize: 0,
                                onPressed: onDownvote,
                                padding: EdgeInsets.zero,
                                child: isVoted && voteType == 'Downvote'
                                    ? SvgPicture.asset(
                                        'assets/svgs/shoutdown-active.svg',
                                        height: getScreenHeight(20),
                                        width: getScreenWidth(20),
                                      )
                                    : SvgPicture.asset(
                                        'assets/svgs/shoutdown.svg',
                                        height: getScreenHeight(20),
                                        width: getScreenWidth(20),
                                      ),
                              ),
                              Flexible(
                                  child: SizedBox(width: getScreenWidth(4))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ).paddingOnly(b: 15, r: 16, l: 16, t: 5),
            ],
          ),
        ),
      ),
    );
  }
}

// class PostFeedReacherCard extends HookWidget {
//   const PostFeedReacherCard({
//     Key? key,
//     required this.postFeedModel,
//     required this.likingPost,
//     this.onDownvote,
//     this.onLike,
//     this.onMessage,
//     this.onUpvote,
//     this.routeProfile,
//     required this.isVoted,
//     required this.voteType,
//     required this.isLiked,
//   }) : super(key: key);

//   final PostFeedModel? postFeedModel;
//   final bool likingPost;
//   final Function()? onLike, onMessage, onUpvote, onDownvote, routeProfile;
//   final bool isLiked, isVoted;
//   final String? voteType;

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Padding(
//       padding: EdgeInsets.only(
//         right: getScreenWidth(15),
//         left: getScreenWidth(15),
//         bottom: getScreenHeight(16),
//       ),
//       child: Container(
//         width: size.width,
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Material(
//           borderRadius: BorderRadius.circular(25),
//           color: AppColors.white,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CupertinoButton(
//                     borderRadius: BorderRadius.circular(25),
//                      minSize: 0,
//                       padding: EdgeInsets.zero,
//                     onPressed: (){
//                       final progress = ProgressHUD.of(context,);
//                       progress?.showWithText('Viewing Reacher..',);
//                       Future.delayed(const Duration(seconds: 3), () {
//                         globals.userBloc!.add(GetRecipientProfileEvent(email: postFeedModel!.postOwnerId));
//                         postFeedModel!.postOwnerId == globals.user!.id
//                             ? RouteNavigators.route(context, const AccountScreen())
//                             : RouteNavigators.route(
//                             context,
//                             RecipientAccountProfile(
//                               recipientEmail: 'email',
//                               recipientImageUrl: postFeedModel!.profilePicture,
//                               recipientId: postFeedModel!.postOwnerId,
//                             ));
//                         progress?.dismiss();
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 20, bottom: 5),
//                       child: Row(
//                         children: [
//                           Helper.renderProfilePicture(
//                             postFeedModel!.profilePicture,
//                             size: 33,
//                           ).paddingOnly(l: 13, t: 10),
//                           SizedBox(width: getScreenWidth(9)),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text(
//                                     '@${postFeedModel!.username!}',
//                                     style: TextStyle(
//                                       fontSize: getScreenHeight(14),
//                                       fontWeight: FontWeight.w500,
//                                       color: AppColors.textColor2,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 3),
//                                   postFeedModel!.verified!
//                                       ? SvgPicture.asset('assets/svgs/verified.svg')
//                                       : const SizedBox.shrink()
//                                 ],
//                               ),
//                               postFeedModel!.post!.location == null
//                                   ? const SizedBox.shrink()
//                                   : Text(
//                                       postFeedModel!.post!.location ?? 'Somewhere',
//                                       style: TextStyle(
//                                         fontSize: getScreenHeight(10),
//                                         fontWeight: FontWeight.w400,
//                                         color: AppColors.textColor2,
//                                       ),
//                                     ),
//                             ],
//                           ).paddingOnly(t: 10),
//                         ],
//                       ),
//                     ),),
//                   //   child: Row(
//                   //     mainAxisAlignment: MainAxisAlignment.start,
//                   //     mainAxisSize: MainAxisSize.min,
//                   //     children: [
//                   //       CupertinoButton(
//                   //         minSize: 0,
//                   //         onPressed: onLike,
//                   //         padding: EdgeInsets.zero,
//                   //         child: likingPost
//                   //             ? const CupertinoActivityIndicator()
//                   //             : isLiked
//                   //                 ? SvgPicture.asset(
//                   //                     'assets/svgs/like-active.svg',
//                   //                     height: getScreenHeight(20),
//                   //                     width: getScreenWidth(20),
//                   //                   )
//                   //                 : SvgPicture.asset(
//                   //                     'assets/svgs/like.svg',
//                   //                     height: getScreenHeight(20),
//                   //                     width: getScreenWidth(20),
//                   //                   ),
//                   //       ),
//                   //       SizedBox(width: getScreenWidth(4)),
//                   //       FittedBox(
//                   //         child: Text(
//                   //           '${postFeedModel!.post!.nLikes}',
//                   //           style: TextStyle(
//                   //             fontSize: getScreenHeight(12),
//                   //             fontWeight: FontWeight.w500,
//                   //             color: AppColors.textColor3,
//                   //           ),
//                   //         ),
//                   //       ),
//                   //       SizedBox(width: getScreenWidth(15)),
//                   //       CupertinoButton(
//                   //         minSize: 0,
//                   //         onPressed: () {
//                   //           RouteNavigators.route(context,
//                   //               ViewCommentsScreen(post: postFeedModel!));
//                   //         },
//                   //         padding: EdgeInsets.zero,
//                   //         child: SvgPicture.asset(
//                   //           'assets/svgs/comment.svg',
//                   //           height: getScreenHeight(20),
//                   //           width: getScreenWidth(20),
//                   //         ),
//                   //         SizedBox(width: getScreenWidth(4)),
//                   //         FittedBox(
//                   //           child: Text(
//                   //             '${postFeedModel!.post!.nLikes}',
//                   //             style: TextStyle(
//                   //               fontSize: getScreenHeight(12),
//                   //               fontWeight: FontWeight.w500,
//                   //               color: AppColors.textColor3,
//                   //             ),
//                   //           ),
//                   //         ),
//                   //         SizedBox(width: getScreenWidth(15)),
//                   //       if (postFeedModel!.postOwnerId !=
//                   //           postFeedModel!.feedOwnerId)
//                   //         CupertinoButton(
//                   //           minSize: 0,
//                   //           onPressed: onMessage,
//                   //           padding: const EdgeInsets.all(0),
//                   //           child: SvgPicture.asset(
//                   //             'assets/svgs/message.svg',
//                   //             height: getScreenHeight(20),
//                   //             width: getScreenWidth(20),
//                   //           ),
//                   //         ),
//                   //     ],
//                   //   ),
//                   // ),
//                // ),
//                 SizedBox(width: getScreenWidth(20)),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Flexible(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 11,
//                           vertical: 7,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           color: const Color(0xFFF5F5F5),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             CupertinoButton(
//                               minSize: 0,
//                               onPressed: onUpvote,
//                               padding: EdgeInsets.zero,
//                               child: isVoted && voteType == 'Upvote'
//                                   ? SvgPicture.asset(
//                                       'assets/svgs/shoutup-active.svg',
//                                       height: getScreenHeight(20),
//                                       width: getScreenWidth(20),
//                                     )
//                                   : SvgPicture.asset(
//                                       'assets/svgs/shoutup.svg',
//                                       height: getScreenHeight(20),
//                                       width: getScreenWidth(20),
//                                     ),
//                             ),
//                             Flexible(child: SizedBox(width: getScreenWidth(4))),
//                             Flexible(child: SizedBox(width: getScreenWidth(4))),
//                             CupertinoButton(
//                               minSize: 0,
//                               onPressed: onDownvote,
//                               padding: EdgeInsets.zero,
//                               child: isVoted && voteType == 'Downvote'
//                                   ? SvgPicture.asset(
//                                       'assets/svgs/shoutdown-active.svg',
//                                       height: getScreenHeight(20),
//                                       width: getScreenWidth(20),
//                                     )
//                                   : SvgPicture.asset(
//                                       'assets/svgs/shoutdown.svg',
//                                       height: getScreenHeight(20),
//                                       width: getScreenWidth(20),
//                                     ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: getScreenWidth(20)),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Flexible(
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 11,
//                             vertical: 7,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             color: const Color(0xFFF5F5F5),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 onPressed: onUpvote,
//                                 padding: EdgeInsets.zero,
//                                 constraints: const BoxConstraints(),
//                                 icon: isVoted && voteType == 'upvote'
//                                     ? SvgPicture.asset(
//                                         'assets/svgs/shoutup-active.svg',
//                                         height: getScreenHeight(20),
//                                         width: getScreenWidth(20),
//                                       )
//                                     : SvgPicture.asset(
//                                         'assets/svgs/shoutup.svg',
//                                         height: getScreenHeight(20),
//                                         width: getScreenWidth(20),
//                                       ),
//                               ),
//                               SizedBox(width: getScreenWidth(4)),
//                               FittedBox(
//                                 child: postFeedModel!.post!.nUpvotes != null ? Text(
//                                   '${postFeedModel!.post!.nUpvotes}',
//                                   style: TextStyle(
//                                     fontSize: getScreenHeight(12),
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColors.textColor3,
//                                   ),
//                                 ) : Text(
//                                     '0',
//                                     style: TextStyle(
//                                     fontSize: getScreenHeight(12),
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.textColor3,
//                                   ),
//                                 ),
//                               ),
//                               Flexible(child: SizedBox(width: getScreenWidth(4))),
//                               Flexible(child: SizedBox(width: getScreenWidth(4))),
//                               IconButton(
//                                 onPressed: onDownvote,
//                                 padding: EdgeInsets.zero,
//                                 constraints: const BoxConstraints(),
//                                 icon: isVoted && voteType == 'downvote'
//                                     ? SvgPicture.asset(
//                                         'assets/svgs/shoutdown-active.svg',
//                                         height: getScreenHeight(20),
//                                         width: getScreenWidth(20),
//                                       )
//                                     : SvgPicture.asset(
//                                         'assets/svgs/shoutdown.svg',
//                                         height: getScreenHeight(20),
//                                         width: getScreenWidth(20),
//                                       ),
//                               ),
//                               SizedBox(width: getScreenWidth(4)),
//                               FittedBox(
//                                 child: postFeedModel!.post!.nDownvotes != null ? Text(
//                                   '${postFeedModel!.post!.nDownvotes}',
//                                   style: TextStyle(
//                                     fontSize: getScreenHeight(12),
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColors.textColor3,
//                                   ),
//                                 ) : Text(
//                                   '0',
//                                   style: TextStyle(
//                                     fontSize: getScreenHeight(12),
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColors.textColor3,
//                                   ),
//                                 ),
//                               ),
//                               // Flexible(child: SizedBox(width: getScreenWidth(4))),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ).paddingOnly(b: 15, r: 16, l: 16, t: 5),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class UserStory extends StatelessWidget {
  const UserStory({
    Key? key,
    required this.size,
    required this.isLive,
    required this.isMe,
    required this.username,
    required this.hasWatched,
    this.image,
    this.isMeOnTap,
    this.onTap,
  }) : super(key: key);

  final Size size;
  final bool isMe;
  final bool isLive;
  final bool hasWatched;
  final String username;
  final String? image;
  final Function()? isMeOnTap;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isMe ? isMeOnTap : onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              !hasWatched
                  ? Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: !isLive
                            ? AppColors.primaryColor
                            : const Color(0xFFDE0606),
                      ),
                      child: Container(
                          padding: const EdgeInsets.all(3.5),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Helper.renderProfilePicture(
                            image,
                            size: 60,
                          )),
                    )
                  : Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF5F5F5),
                      ),
                      child: Container(
                          width: getScreenWidth(70),
                          height: getScreenHeight(70),
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset(
                            'assets/images/user.png',
                            fit: BoxFit.fill,
                            gaplessPlayback: true,
                          ),
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle)),
                    ),
              isMe
                  ? Positioned(
                      bottom: size.width * 0.01,
                      right: size.width * 0.008,
                      child: Container(
                          width: getScreenWidth(21),
                          height: getScreenHeight(21),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.white,
                            size: 14,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                            border: Border.all(
                              color: AppColors.white,
                              width: 1.5,
                            ),
                          )),
                    )
                  : isLive
                      ? Positioned(
                          bottom: size.width * 0.0001,
                          right: size.width / 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: Text('LIVE',
                                style: TextStyle(
                                  fontSize: getScreenHeight(11),
                                  letterSpacing: 1.1,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.white,
                                )),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: const Color(0xFFDE0606),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
            ],
          ),
          isLive
              ? SizedBox(height: getScreenHeight(7))
              : SizedBox(height: getScreenHeight(11)),
          Text(username,
              style: TextStyle(
                fontSize: getScreenHeight(11),
                fontWeight: FontWeight.w400,
              ))
        ],
      ).paddingOnly(r: 25),
    );
  }
}

class DemoSourceEntity {
  int id;
  String url;
  String? previewUrl;
  String type;

  DemoSourceEntity(this.id, this.url, this.type, {this.previewUrl});
}
