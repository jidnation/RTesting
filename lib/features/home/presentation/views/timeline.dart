import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/components/refresher.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/database/secure_storage.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/file_utils.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/core/utils/location.helper.dart';
import 'package:reach_me/features/account/presentation/views/account.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/features/auth/presentation/views/login_screen.dart';
import 'package:reach_me/features/chat/presentation/views/chats_list_screen.dart';
import 'package:reach_me/features/dictionary/presentation/widgets/view_words_dialog.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/data/models/status.model.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';
import 'package:reach_me/features/home/presentation/views/comment_reach.dart';
import 'package:reach_me/features/home/presentation/views/post_reach.dart';
import 'package:reach_me/features/home/presentation/views/status/create.status.dart';
import 'package:reach_me/features/home/presentation/views/status/view.status.dart';
import 'package:reach_me/features/home/presentation/widgets/post_media.dart';
import 'package:reach_me/features/home/presentation/widgets/reposted_post.dart';
import 'package:reach_me/features/moment/user_posting.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../chat/presentation/views/msg_chat_interface.dart';
import '../../../moment/moment_audio_player.dart';
import '../../../timeline/suggestion_widget.dart';
import '../../../timeline/video_player.dart';
import 'full_post.dart';

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
    final reachDM = useState<PostFeedModel?>(null);
    final viewProfile = useState(false);
    final shoutingDown = useState(false);
    final _posts = useState<List<PostFeedModel>>([]);
    final _currentPost = useState<PostFeedModel?>(null);
    final _myStatus = useState<List<StatusModel>>([]);
    final _userStatus = useState<List<StatusFeedResponseModel>>([]);
    final _mutedStatus = useState<List<StatusFeedResponseModel>>([]);
    var size = MediaQuery.of(context).size;
    debugPrint(globals.token);
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
                  style: TextStyle(color: AppColors.primaryColor, fontSize: 20),
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
                if (reachDM.value != null) {
                  RouteNavigators.route(
                      context,
                      MsgChatInterface(
                        recipientUser: state.user,
                        quotedData: jsonEncode(reachDM.value!.toJson()),
                      ));
                  reachDM.value = null;
                } else if (viewProfile.value) {
                  viewProfile.value = false;
                  ProgressHUD.of(context)?.dismiss();
                  globals.recipientUser = state.user;
                  state.user!.id == globals.user!.id
                      ? RouteNavigators.route(context, const AccountScreen())
                      : RouteNavigators.route(
                          context,
                          RecipientAccountProfile(
                            recipientEmail: 'email',
                            recipientImageUrl: state.user!.profilePicture,
                            recipientId: state.user!.id,
                          ));
                }
              }
              if (state is UserError) {
                ProgressHUD.of(context)?.dismiss();
                if (viewProfile.value) {
                  Snackbars.error(context,
                      message: (state.error ?? '').contains('Profile')
                          ? 'Account not available!'
                          : state.error);
                }
                reachDM.value = null;
                viewProfile.value = false;
              }
              if (state is GetReachRelationshipSuccess) {
                if (shoutingDown.value) {
                  shoutingDown.value = false;
                  if ((state.isReaching ?? false)) {
                    globals.socialServiceBloc!.add(VotePostEvent(
                      voteType: 'Downvote',
                      postId: _currentPost.value!.postId,
                    ));
                  } else {
                    Snackbars.error(context,
                        message: 'You cannot shout down on this user\'s posts');
                  }
                }
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
                    List<String> mediaUrls = state.data as List<String>;
                    List<String> imageUrls = mediaUrls
                        .where((e) => FileUtils.fileType(e) == 'image')
                        .toList();
                    String videoUrl = mediaUrls.firstWhere(
                        (e) => FileUtils.fileType(e) == 'video',
                        orElse: () => '');
                    String audioUrl = mediaUrls.firstWhere(
                        (e) => FileUtils.fileType(e) == 'audio',
                        orElse: () => '');
                    globals.socialServiceBloc!.add(CreatePostEvent(
                        content: globals.postContent,
                        commentOption: globals.postCommentOption,
                        imageMediaItem: imageUrls.isNotEmpty ? imageUrls : null,
                        videoMediaItem: videoUrl.isNotEmpty ? videoUrl : null,
                        audioMediaItem: audioUrl.isNotEmpty ? audioUrl : null,
                        location: globals.location,
                        postRating: globals.postRating));
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
                    final muted = state.status!
                        .where((e) => e.status?.first.status?.isMuted ?? false)
                        .toList();
                    final unmuted = state.status!
                        .where(
                            (e) => !(e.status?.first.status?.isMuted ?? false))
                        .toList();
                    _userStatus.value = unmuted;
                    _mutedStatus.value = muted;
                  }
                  if (state is GetAllStatusError) {
                    Snackbars.error(context, message: state.error);
                  }
                  if (state is VotePostSuccess) {
                    if (!(state.isVoted!)) {
                      Snackbars.success(context,
                          message:
                              'The post you shouted down has been removed!');
                    } else {
                      Snackbars.success(context,
                          message: 'You shouted at this post');
                    }
                    globals.socialServiceBloc!
                        .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
                  }
                  if (state is DeletePostVoteSuccess) {
                    globals.socialServiceBloc!
                        .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
                  }
                  if (state is DeletePostVoteError) {
                    Snackbars.error(context, message: state.error);
                  }
                  if (state is GetPostFeedSuccess) {
                    _firstLoad = false;
                    _posts.value = (state.posts!);
                    _posts.value.sort((a, b) => b.post!.createdAt!
                        .toIso8601String()
                        .compareTo(a.post!.createdAt!.toIso8601String()));
                    _refreshController.refreshCompleted();
                  }
                  if (state is UnlikePostSuccess) {}
                  if (state is LikePostSuccess) {}
                  if (state is UnlikePostError) {
                    Snackbars.error(context, message: state.error);
                    int pos = _posts.value
                        .indexWhere((e) => e.postId == state.postId);
                    _posts.value[pos].post?.isLiked = true;
                    _posts.value[pos].post?.nLikes =
                        (_posts.value[pos].post?.nLikes ?? 0) + 1;
                  }
                  if (state is LikePostError) {
                    Snackbars.error(context, message: state.error);
                    int pos = _posts.value
                        .indexWhere((e) => e.postId == state.postId);
                    _posts.value[pos].post?.isLiked = false;
                    _posts.value[pos].post?.nLikes =
                        (_posts.value[pos].post?.nLikes ?? 1) - 1;
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
                  bool _isLoading = state is CreatePostLoading ||
                      state is GetPostFeedLoading ||
                      state is DeletePostLoading ||
                      state is EditContentLoading;
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
                                          Visibility(
                                            visible: _posts.value.isNotEmpty,
                                            child: Container(
                                              color: AppColors.white,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        getScreenHeight(105),
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      child: SizedBox(
                                                        child: Row(
                                                          children: [
                                                            UserStory(
                                                              size: size,
                                                              image: globals
                                                                      .user!
                                                                      .profilePicture ??
                                                                  '',
                                                              isMe: true,
                                                              isLive: false,
                                                              hasWatched: false,
                                                              username:
                                                                  'Add Status',
                                                              isMeOnTap:
                                                                  () async {
                                                                var cameras =
                                                                    await availableCameras();
                                                                RouteNavigators
                                                                    .route(
                                                                        context,
                                                                        UserPosting(
                                                                          phoneCameras:
                                                                              cameras,
                                                                          initialIndex:
                                                                              0,
                                                                        ));
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
                                                                image: globals
                                                                        .user!
                                                                        .profilePicture ??
                                                                    '',
                                                                isMe: false,
                                                                isLive: false,
                                                                hasWatched:
                                                                    false,
                                                                username:
                                                                    'Your status',
                                                                onTap: () {
                                                                  RouteNavigators.route(
                                                                      context,
                                                                      ViewMyStatus(
                                                                          status:
                                                                              _myStatus.value));
                                                                },
                                                              ),
                                                            ...List.generate(
                                                              _userStatus
                                                                  .value.length,
                                                              (index) =>
                                                                  UserStory(
                                                                size: size,
                                                                isMe: false,
                                                                isLive: false,
                                                                hasWatched:
                                                                    false,
                                                                image: _userStatus
                                                                    .value[
                                                                        index]
                                                                    .status![0]
                                                                    .statusOwnerProfile!
                                                                    .profilePicture,
                                                                username: _userStatus
                                                                    .value[
                                                                        index]
                                                                    .status![
                                                                        index]
                                                                    .statusOwnerProfile!
                                                                    .username!,
                                                                onTap:
                                                                    () async {
                                                                  // RouteNavigators
                                                                  //     .route(
                                                                  //   context,
                                                                  //   ViewUserStatus(
                                                                  //       status: _userStatus
                                                                  //           .value[
                                                                  //               index]
                                                                  //           .status!),
                                                                  // );
                                                                  final res = await Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (c) => ViewUserStatus(
                                                                              isMuted: false,
                                                                              status: _userStatus.value[index].status!)));
                                                                  if (res ==
                                                                      null)
                                                                    return;
                                                                  if (res
                                                                      is MuteResult) {
                                                                    _mutedStatus
                                                                        .value = [
                                                                      ..._mutedStatus
                                                                          .value,
                                                                      _userStatus
                                                                              .value[
                                                                          index]
                                                                    ];
                                                                    _userStatus
                                                                        .value = [
                                                                      ..._userStatus
                                                                          .value
                                                                    ]..removeAt(
                                                                        index);
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            // ..._userStatus.value.map(
                                                            //   (e) =>
                                                            // ),
                                                          ],
                                                        ),
                                                      ).paddingOnly(l: 11),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          getScreenHeight(5)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: getScreenHeight(2)),
                                          Visibility(
                                            visible: _posts.value.isNotEmpty &&
                                                _mutedStatus.value.isNotEmpty,
                                            child: Container(
                                              color: AppColors.white,
                                              child: ListTileTheme(
                                                dense: true,
                                                child: ExpansionTile(
                                                  collapsedIconColor:
                                                      AppColors.greyShade4,
                                                  iconColor:
                                                      AppColors.greyShade4,
                                                  title: Text(
                                                    'Muted Statuses',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .greyShade3),
                                                  ),
                                                  childrenPadding:
                                                      EdgeInsets.fromLTRB(
                                                          16, 0, 16, 16),
                                                  tilePadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 16),
                                                  children: [
                                                    Row(
                                                      children: [
                                                        ...List.generate(
                                                          _mutedStatus
                                                              .value.length,
                                                          (index) => UserStory(
                                                            size: size,
                                                            isMe: false,
                                                            isLive: false,
                                                            isMuted: true,
                                                            hasWatched: false,
                                                            image: _mutedStatus
                                                                .value[index]
                                                                .status![0]
                                                                .statusOwnerProfile!
                                                                .profilePicture,
                                                            username: _mutedStatus
                                                                .value[index]
                                                                .status![index]
                                                                .statusOwnerProfile!
                                                                .username!,
                                                            onTap: () async {
                                                              final res = await Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (c) => ViewUserStatus(
                                                                          isMuted:
                                                                              true,
                                                                          status: _mutedStatus
                                                                              .value[index]
                                                                              .status!)));
                                                              if (res == null)
                                                                return;
                                                              if (res
                                                                  is MuteResult) {
                                                                _userStatus
                                                                    .value = [
                                                                  ..._userStatus
                                                                      .value,
                                                                  _mutedStatus
                                                                          .value[
                                                                      index]
                                                                ];
                                                                _mutedStatus
                                                                    .value = [
                                                                  ..._mutedStatus
                                                                      .value
                                                                ]..removeAt(
                                                                    index);
                                                              }
                                                              // RouteNavigators
                                                              //     .route(
                                                              //   context,
                                                              //   ViewUserStatus(
                                                              //       status: _mutedStatus
                                                              //           .value[
                                                              //               index]
                                                              //           .status!),
                                                              // );
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
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
                                                      return GestureDetector(
                                                        onTap: () {
                                                          () => Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (builder) =>
                                                                          FullPostScreen(
                                                                            postFeedModel:
                                                                                _posts.value[index],
                                                                          )));
                                                        },
                                                        child:
                                                            PostFeedReacherCard(
                                                          likingPost: false,
                                                          postFeedModel: _posts
                                                              .value[index],
                                                          voterProfile: _posts
                                                              .value[index]
                                                              .voterProfile,
                                                          isLiked: (_posts
                                                                      .value[
                                                                          index]
                                                                      .post
                                                                      ?.isLiked ??
                                                                  false)
                                                              ? true
                                                              : false,
                                                          isVoted: (_posts
                                                                      .value[
                                                                          index]
                                                                      .post
                                                                      ?.isVoted ??
                                                                  '')
                                                              .isNotEmpty,
                                                          voteType: _posts
                                                              .value[index]
                                                              .post
                                                              ?.isVoted,
                                                          onViewProfile: () {
                                                            viewProfile.value =
                                                                true;
                                                            ProgressHUD.of(
                                                                    context)
                                                                ?.showWithText(
                                                                    'Viewing Profile');
                                                            globals.userBloc!.add(
                                                                GetRecipientProfileEvent(
                                                                    email: _posts
                                                                        .value[
                                                                            index]
                                                                        .postOwnerId));
                                                          },
                                                          onMessage: () {
                                                            HapticFeedback
                                                                .mediumImpact();
                                                            reachDM.value =
                                                                _posts.value[
                                                                    index];

                                                            handleTap(index);
                                                            if (active.contains(
                                                                index)) {
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

                                                            if (active.contains(
                                                                index)) {
                                                              if ((_posts
                                                                          .value[
                                                                              index]
                                                                          .vote ??
                                                                      [])
                                                                  .isEmpty) {
                                                                globals
                                                                    .socialServiceBloc!
                                                                    .add(
                                                                        VotePostEvent(
                                                                  voteType:
                                                                      'Upvote',
                                                                  postId: _posts
                                                                      .value[
                                                                          index]
                                                                      .postId,
                                                                ));
                                                              } else {
                                                                globals
                                                                    .socialServiceBloc!
                                                                    .add(
                                                                        DeletePostVoteEvent(
                                                                  voteId: _posts
                                                                      .value[
                                                                          index]
                                                                      .postId,
                                                                ));
                                                              }
                                                            }
                                                          },
                                                          onDownvote: () {
                                                            HapticFeedback
                                                                .mediumImpact();
                                                            handleTap(index);
                                                            _currentPost.value =
                                                                _posts.value[
                                                                    index];
                                                            if (active.contains(
                                                                index)) {
                                                              shoutingDown
                                                                  .value = true;
                                                              globals.userBloc!.add(GetReachRelationshipEvent(
                                                                  userIdToReach: _posts
                                                                      .value[
                                                                          index]
                                                                      .postOwnerId,
                                                                  type: ReachRelationshipType
                                                                      .reacher));
                                                            }
                                                          },
                                                          onLike: () {
                                                            HapticFeedback
                                                                .mediumImpact();
                                                            handleTap(index);
                                                            // Console.log(
                                                            //     'Like Data',
                                                            //     _posts.value[index]
                                                            //         .toJson());
                                                            if (active.contains(
                                                                index)) {
                                                              if (_posts
                                                                      .value[
                                                                          index]
                                                                      .post
                                                                      ?.isLiked ??
                                                                  false) {
                                                                _posts
                                                                        .value[
                                                                            index]
                                                                        .post
                                                                        ?.isLiked =
                                                                    false;
                                                                _posts
                                                                    .value[
                                                                        index]
                                                                    .post
                                                                    ?.nLikes = (_posts
                                                                            .value[index]
                                                                            .post
                                                                            ?.nLikes ??
                                                                        1) -
                                                                    1;
                                                                globals
                                                                    .socialServiceBloc!
                                                                    .add(
                                                                        UnlikePostEvent(
                                                                  postId: _posts
                                                                      .value[
                                                                          index]
                                                                      .postId,
                                                                ));
                                                              } else {
                                                                _posts
                                                                    .value[
                                                                        index]
                                                                    .post
                                                                    ?.isLiked = true;
                                                                _posts
                                                                    .value[
                                                                        index]
                                                                    .post
                                                                    ?.nLikes = (_posts
                                                                            .value[index]
                                                                            .post
                                                                            ?.nLikes ??
                                                                        0) +
                                                                    1;
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
                                                        ),
                                                      );
                                                    },
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          )
                        ]).paddingOnly(t: 10),
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
    this.onViewProfile,
    this.voterProfile,
    required this.isVoted,
    required this.voteType,
    required this.isLiked,
  }) : super(key: key);
  final PostFeedModel? postFeedModel;
  final bool likingPost;
  final Function()? onLike, onMessage, onUpvote, onDownvote, onViewProfile;
  final bool isLiked, isVoted;
  final String? voteType;
  final PostProfileModel? voterProfile;
  @override
  Widget build(BuildContext context) {
    final postDuration = timeago.format(postFeedModel!.post!.createdAt!);
    var scr = GlobalKey();

    Future<String> saveImage(Uint8List? bytes) async {
      await [Permission.storage].request();
      String time = DateTime.now().microsecondsSinceEpoch.toString();
      final name = 'screenshot_${time}_reachme';
      final result = await ImageGallerySaver.saveImage(bytes!, name: name);
      debugPrint("Result ${result['filePath']}");
      Snackbars.success(context, message: 'Image saved to Gallery');
      RouteNavigators.pop(context);
      return result['filePath'];
    }

    final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
    void takeScreenShot() async {
      RenderRepaintBoundary boundary = scr.currentContext!.findRenderObject()
          as RenderRepaintBoundary; // the key provided
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      debugPrint("Byte Data: $byteData");
      await saveImage(byteData!.buffer.asUint8List());
    }

    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        right: getScreenWidth(16),
        left: getScreenWidth(16),
        bottom: getScreenHeight(16),
      ),
      child: RepaintBoundary(
        key: scr,
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (builder) => FullPostScreen(
                    postFeedModel: postFeedModel,
                  ))),
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (builder) => FullPostScreen(
                        postFeedModel: postFeedModel,
                      ))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: voterProfile != null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                          child: RichText(
                            text: TextSpan(
                                text:
                                    '@${voterProfile?.authId != globals.userId ? voterProfile?.username?.appendOverflow(15) : 'You'}',
                                style: const TextStyle(
                                    color: AppColors.black,
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                                children: const [
                                  TextSpan(
                                      text: ' shouted out this reach',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.w500))
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: getScreenHeight(8),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          minSize: 0,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (onViewProfile != null) {
                              onViewProfile!();
                            } else {
                              final progress = ProgressHUD.of(context);
                              progress?.showWithText('Viewing Reacher...');
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
                                          recipientId:
                                              postFeedModel!.postOwnerId,
                                        ));
                                progress?.dismiss();
                              });
                            }
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
                                        '@${postFeedModel!.username ?? ''}',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(14),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textColor2,
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      postFeedModel!.verified ?? false
                                          ? SvgPicture.asset(
                                              'assets/svgs/verified.svg')
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                FullPostScreen(
                                                  postFeedModel: postFeedModel,
                                                ))),
                                    child: Row(
                                      children: [
                                        Text(
                                          postFeedModel!.post!.location! ==
                                                      'nil' ||
                                                  postFeedModel!
                                                          .post!.location! ==
                                                      'NIL' ||
                                                  postFeedModel!.post!.location ==
                                                      null
                                              ? ''
                                              : postFeedModel!.post!.location!
                                                          .length >
                                                      23
                                                  ? postFeedModel!
                                                      .post!.location!
                                                      .substring(0, 23)
                                                  : postFeedModel!
                                                      .post!.location!,
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
                                    ),
                                  )
                                ],
                              ).paddingOnly(t: 10),
                            ],
                          ),
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
                                downloadPost: takeScreenShot,
                                postFeedModel: postFeedModel!,
                              );
                            },
                            iconSize: getScreenHeight(19),
                            padding: const EdgeInsets.all(0),
                            icon:
                                SvgPicture.asset('assets/svgs/kebab card.svg'),
                          ),
                        ],
                      )
                    ],
                  ),
                  postFeedModel!.post!.content == null
                      ? const SizedBox.shrink()
                      : ExpandableText(
                          "${postFeedModel!.post!.content}",
                          prefixText: postFeedModel!.post!.edited!
                              ? "(Reach Edited)"
                              : null,
                          prefixStyle: TextStyle(
                              fontSize: getScreenHeight(12),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              color: AppColors.primaryColor),
                          onPrefixTap: () {
                            tooltipkey.currentState?.ensureTooltipVisible();
                          },
                          expandText: 'see more',
                          maxLines: 2,
                          linkColor: Colors.blue,
                          animation: true,
                          expanded: false,
                          collapseText: 'see less',
                          onHashtagTap: (value) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DictionaryDialog(
                                    abbr: value,
                                    meaning: '',
                                    word: '',
                                  );
                                });
                          },
                          onMentionTap: (value) {},
                          mentionStyle: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue),
                          hashtagStyle: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue),
                        ).paddingSymmetric(h: 16, v: 10),
                  Tooltip(
                    key: tooltipkey,
                    triggerMode: TooltipTriggerMode.manual,
                    showDuration: const Duration(seconds: 1),
                    message: 'This reach has been edited',
                  ),
                  if ((postFeedModel?.post?.imageMediaItems ?? []).isNotEmpty)
                    PostMedia(post: postFeedModel!.post!)
                        .paddingOnly(r: 16, l: 16, b: 16, t: 10)
                  else
                    const SizedBox.shrink(),
                  if ((postFeedModel?.post?.videoMediaItem ?? '').isNotEmpty)
                    TimeLineVideoPlayer(
                        post: postFeedModel!.post!,
                        videoUrl: postFeedModel!.post!.videoMediaItem!)
                  else
                    const SizedBox.shrink(),
                  (postFeedModel?.post?.audioMediaItem ?? '').isNotEmpty
                      ? Container(
                          height: 59,
                          margin: const EdgeInsets.only(bottom: 10),
                          width: SizeConfig.screenWidth,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xfff5f5f5)),
                          child: Row(children: [
                            Expanded(
                                child: MomentAudioPlayer(
                              audioPath: postFeedModel!.post!.audioMediaItem!,
                            )),
                          ]),
                        )
                      : const SizedBox.shrink(),
                  (postFeedModel?.post?.repostedPost != null)
                      ? RepostedPost(
                          post: postFeedModel!.post!,
                        ).paddingOnly(l: 0, r: 0, b: 10, t: 0)
                      : const SizedBox.shrink(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: Container(
                          height: 40,
                          width: getScreenWidth(160),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFFF5F5F5),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onLongPress: () {
                                    if ((postFeedModel!.post!.nLikes ?? 0) >
                                        0) {
                                      showPostReactors(context,
                                          postId: postFeedModel!.post!.postId!,
                                          reactionType: 'Like');
                                    }
                                  },
                                  child: CupertinoButton(
                                    minSize: 0,
                                    onPressed: onLike,
                                    padding: EdgeInsets.zero,
                                    child: isLiked
                                        ? SvgPicture.asset(
                                            'assets/svgs/like-active.svg',
                                          )
                                        : SvgPicture.asset(
                                            'assets/svgs/like.svg',
                                          ),
                                  ),
                                ),
                                SizedBox(width: getScreenWidth(4)),
                                FittedBox(
                                  child: Text(
                                    '${postFeedModel!.post!.nLikes}',
                                    style: TextStyle(
                                      fontSize: getScreenHeight(15),
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor3,
                                    ),
                                  ),
                                ),
                                SizedBox(width: getScreenWidth(15)),
                                CupertinoButton(
                                  minSize: 0,
                                  onPressed: () {
                                    RouteNavigators.route(
                                        context,
                                        // ViewCommentsScreen(
                                        //     post: postFeedModel!)
                                        CommentReach(
                                            postFeedModel: postFeedModel));
                                  },
                                  padding: EdgeInsets.zero,
                                  child: SvgPicture.asset(
                                    'assets/svgs/comment.svg',
                                  ),
                                ),
                                SizedBox(width: getScreenWidth(4)),
                                FittedBox(
                                  child: Text(
                                    '${postFeedModel!.post!.nComments}',
                                    style: TextStyle(
                                      fontSize: getScreenHeight(15),
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor3,
                                    ),
                                  ),
                                ),
                                if (postFeedModel!.postOwnerId !=
                                    globals.userId)
                                  SizedBox(width: getScreenWidth(15)),
                                if (postFeedModel!.postOwnerId !=
                                    globals.userId)
                                  CupertinoButton(
                                    minSize: 0,
                                    onPressed: onMessage,
                                    padding: const EdgeInsets.all(0),
                                    child: SvgPicture.asset(
                                      'assets/svgs/message.svg',
                                    ),
                                  ),
                              ]),
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
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xFFF5F5F5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onLongPress: () {
                                      if ((postFeedModel!.post!.nUpvotes ?? 0) >
                                              0 &&
                                          (postFeedModel!.post!.authId ==
                                              globals.user!.id!)) {
                                        showPostReactors(context,
                                            postId:
                                                postFeedModel!.post!.postId!,
                                            reactionType: 'Upvote');
                                      }
                                    },
                                    child: CupertinoButton(
                                      minSize: 0,
                                      onPressed: onUpvote,
                                      padding: EdgeInsets.zero,
                                      child: isVoted && voteType == 'Upvote'
                                          ? SvgPicture.asset(
                                              'assets/svgs/shoutup-active.svg',
                                              height: 25,
                                              width: 25,
                                            )
                                          : SvgPicture.asset(
                                              'assets/svgs/shoutup.svg',
                                              height: 25,
                                              width: 25,
                                            ),
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      '${postFeedModel!.post!.nUpvotes ?? 0}',
                                      style: TextStyle(
                                        fontSize: getScreenHeight(18),
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textColor3,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      child:
                                          SizedBox(width: getScreenWidth(4))),
                                  Flexible(
                                      child:
                                          SizedBox(width: getScreenWidth(4))),
                                  GestureDetector(
                                    onLongPress: () {
                                      if ((postFeedModel!.post!.nDownvotes ??
                                                  0) >
                                              0 &&
                                          (postFeedModel!.post!.authId ==
                                              globals.user!.id!)) {
                                        showPostReactors(context,
                                            postId:
                                                postFeedModel!.post!.postId!,
                                            reactionType: 'Downvote');
                                      }
                                    },
                                    child: CupertinoButton(
                                      minSize: 0,
                                      onPressed: onDownvote,
                                      padding: EdgeInsets.zero,
                                      child: isVoted && voteType == 'Downvote'
                                          ? SvgPicture.asset(
                                              'assets/svgs/shoutdown-active.svg',
                                              height: 25,
                                              width: 25,
                                            )
                                          : SvgPicture.asset(
                                              'assets/svgs/shoutdown.svg',
                                              height: 25,
                                              width: 25,
                                            ),
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      '${postFeedModel!.post!.nDownvotes ?? 0}',
                                      style: TextStyle(
                                        fontSize: getScreenHeight(18),
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textColor3,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      child:
                                          SizedBox(width: getScreenWidth(4))),
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
        ),
      ),
    );
  }
}

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
    this.isMuted,
    this.onTap,
  }) : super(key: key);
  final Size size;
  final bool isMe;
  final bool isLive;
  final bool hasWatched;
  final bool? isMuted;
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
                        color: isMuted ?? false
                            ? AppColors.greyShade10
                            : !isLive
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
          Text(
              (username.length > 11
                  ? '${username.substring(0, 11)}...'
                  : username),
              style: TextStyle(
                  fontSize: getScreenHeight(11),
                  fontWeight: FontWeight.w400,
                  color: isMuted ?? false ? AppColors.greyShade3 : null,
                  overflow: TextOverflow.ellipsis))
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
