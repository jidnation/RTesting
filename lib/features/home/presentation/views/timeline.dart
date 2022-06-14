import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reach_me/core/components/bottom_sheet_list_tile.dart';
import 'package:reach_me/core/components/empty_state.dart';
import 'package:reach_me/core/components/refresher.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/helper/logger.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/features/chat/presentation/views/chats_list_screen.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';
import 'package:reach_me/features/home/presentation/views/post_reach.dart';
import 'package:reach_me/features/home/presentation/views/view_comments.dart';
import 'package:reach_me/core/components/media_card.dart';
import 'package:reach_me/features/home/presentation/widgets/app_drawer.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';

class TimelineScreen extends StatefulHookWidget {
  static const String id = "timeline_screen";
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with AutomaticKeepAliveClientMixin<TimelineScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    globals.userBloc!.add(GetUserProfileEvent(email: globals.email!));
    globals.socialServiceBloc!
        .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
    super.initState();
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
    globals.socialServiceBloc!
        .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isLiked = useState<bool>(false);
    final selectedIndex = useState<int>(0);
    final scaffoldKey =
        useState<GlobalKey<ScaffoldState>>(GlobalKey<ScaffoldState>());
    final _posts = useState<List<PostFeedModel>>([]);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey.value,
      drawer: const AppDrawer(),
      extendBodyBehindAppBar: true,
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
            onPressed: () => scaffoldKey.value.currentState!.openDrawer(),
            icon: Helper.renderProfilePicture(globals.user!.profilePicture)),
        titleSpacing: 5,
        leadingWidth: getScreenWidth(70),
        title: Text(
          'Reachme',
          style: TextStyle(
            color: AppColors.textColor2,
            fontSize: getScreenHeight(21),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/svgs/post.svg',
              width: getScreenWidth(22),
              height: getScreenHeight(22),
            ),
            onPressed: () => RouteNavigators.route(context, const PostReach()),
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/svgs/message.svg',
              width: getScreenWidth(22),
              height: getScreenHeight(22),
            ),
            onPressed: () => RouteNavigators.route(
              context,
              const ChatsListScreen(),
            ),
          ).paddingOnly(r: 16),
        ],
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<SocialServiceBloc, SocialServiceState>(
            bloc: globals.socialServiceBloc,
            listener: (context, state) {
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
              }

              if (state is GetPostFeedSuccess) {
                _posts.value = state.posts!;
                Console.log('posts', _posts.value);
              }

              if (state is LikePostError ||
                  state is LikePostSuccess ||
                  state is UnlikePostError ||
                  state is UnlikePostSuccess) {
                globals.socialServiceBloc!
                    .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
              }

              if (state is LikePostSuccess) {
                isLiked.value = state.isLiked!;
              }
              if (state is UnlikePostSuccess) {
                isLiked.value = state.isUnliked!;
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
            },
            builder: (context, state) {
              bool _isLoading = state is CreatePostLoading;
              _isLoading = state is GetPostFeedLoading;
              _isLoading = state is DeletePostLoading;
              _isLoading = state is EditContentLoading;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    child: _posts.value.isEmpty
                        ? EmptyTimelineWidget(loading: _isLoading)
                        : SizedBox(
                            height: getScreenHeight(100),
                            child: Refresher(
                              onRefresh: onRefresh,
                              controller: _refreshController,
                              child: ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: [
                                  const SizedBox(
                                      height: kToolbarHeight + 20), //30
                                  _isLoading
                                      ? const LinearLoader()
                                      : const SizedBox.shrink(),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: SizedBox(
                                      child: Row(
                                        children: [
                                          UserStory(
                                              size: size,
                                              isMe: true,
                                              isLive: false,
                                              hasWatched: false,
                                              username: 'Add Moment'),
                                        ],
                                      ),
                                    ).paddingOnly(l: 11),
                                  ),
                                  SizedBox(height: getScreenHeight(12)),
                                  const Divider(
                                    thickness: 0.5,
                                    color: AppColors.greyShade4,
                                  ),
                                  Column(
                                    children: List.generate(
                                      _posts.value.length,
                                      (index) => _ReacherCard(
                                        postFeedModel: _posts.value[index],
                                        likeColour: _posts.value[index].isLiked!
                                            ? AppColors.primaryColor
                                            : null,
                                        onLike: () {
                                          selectedIndex.value = index;
                                          handleTap(index);
                                          if (active.contains(index)) {
                                            Console.log('like post',
                                                _posts.value[index].isLiked);
                                            _posts.value[index].isLiked!
                                                ? globals.socialServiceBloc!
                                                    .add(UnlikePostEvent(
                                                    postId: _posts
                                                        .value[index].postId,
                                                  ))
                                                : globals.socialServiceBloc!
                                                    .add(LikePostEvent(
                                                    postId: _posts
                                                        .value[index].postId,
                                                  ));
                                          }
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  )
                ],
              ).paddingOnly(t: 10);
            }),
      ),
    );
  }
}

class _ReacherCard extends HookWidget {
  const _ReacherCard({
    Key? key,
    required this.postFeedModel,
    this.onComment,
    this.onDownvote,
    this.onLike,
    this.onMessage,
    this.onUpvote,
    this.likeColour,
  }) : super(key: key);

  final PostFeedModel? postFeedModel;
  final Function()? onLike, onComment, onMessage, onUpvote, onDownvote;
  final Color? likeColour;

  @override
  Widget build(BuildContext context) {
    //final isLiked = useState(false);
    // useEffect(() {
    //   globals.socialServiceBloc!
    //       .add(CheckPostLikeEvent(postId: postFeedModel!.postId));
    //   globals.socialServiceBloc!
    //       .add(CheckPostVoteEvent(postId: postFeedModel!.postId));
    //   return null;
    // }, []);
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 7,
      ),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: BlocConsumer<SocialServiceBloc, SocialServiceState>(
            bloc: globals.socialServiceBloc,
            listener: (context, state) {
              // if (state is CheckPostLikeError) {
              //   Snackbars.error(context, message: state.error);
              // }
              // if (state is CheckPostLikeSuccess) {
              //   isLiked.value = state.checkPostLike!;
              // }
              // if (state is CheckPostVoteError) {
              //   Snackbars.error(context, message: state.error);
              // }
              // if (state is CheckPostVoteSuccess) {
              //   // postFeedModel!.isVoted = state.isVoted;
              // }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Helper.renderProfilePicture(
                                  postFeedModel!.profilePicture,
                                  size: 33)
                              .paddingOnly(l: 13, t: 10),
                          SizedBox(width: getScreenWidth(9)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    (postFeedModel!.firstName! +
                                            ' ' +
                                            postFeedModel!.lastName!)
                                        .toTitleCase(),
                                    style: TextStyle(
                                      fontSize: getScreenHeight(15),
                                      fontWeight: FontWeight.w600,
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
                              Text(
                                'Manchester, United Kingdom',
                                style: TextStyle(
                                  fontSize: getScreenHeight(11),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textColor2,
                                ),
                              ),
                            ],
                          ).paddingOnly(t: 10),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset('assets/svgs/starred.svg'),
                          SizedBox(width: getScreenWidth(9)),
                          IconButton(
                            onPressed: () async {
                              await showReacherCardBottomSheet(
                                context,
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
                  Flexible(
                    child: Text(
                      postFeedModel!.post!.edited!
                          ? "${postFeedModel!.post!.content ?? ''} (edited)"
                          : postFeedModel!.post!.content ?? '',
                      style: TextStyle(
                        fontSize: getScreenHeight(14),
                        fontWeight: FontWeight.w400,
                      ),
                    ).paddingSymmetric(v: 10, h: 16),
                  ),
                  if (postFeedModel!.post!.imageMediaItems!.isNotEmpty &&
                      postFeedModel!.post!.audioMediaItem!.isNotEmpty &&
                      postFeedModel!.post!.audioMediaItem!.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            height: getScreenHeight(152),
                            width: getScreenWidth(152),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/post.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: getScreenWidth(8)),
                        Flexible(child: MediaCard(size: size)),
                      ],
                    ).paddingOnly(r: 16, l: 16, b: 16, t: 10),
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
                              IconButton(
                                onPressed: onLike,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: SvgPicture.asset(
                                  'assets/svgs/like.svg',
                                  color: likeColour,
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
                              IconButton(
                                onPressed: () {
                                  RouteNavigators.route(context,
                                      ViewCommentsScreen(post: postFeedModel!));
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: SvgPicture.asset(
                                  'assets/svgs/comment.svg',
                                  height: 20,
                                  width: 20,
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
                                IconButton(
                                  onPressed: () {},
                                  padding: const EdgeInsets.all(0),
                                  constraints: const BoxConstraints(),
                                  icon: SvgPicture.asset(
                                    'assets/svgs/message.svg',
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
                                  IconButton(
                                    onPressed: () {},
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: SvgPicture.asset(
                                      'assets/svgs/shoutout-a.svg',
                                    ),
                                  ),
                                  Flexible(
                                      child:
                                          SizedBox(width: getScreenWidth(4))),
                                  // FittedBox(
                                  //   child: Text(
                                  //     '${postFeedModel!.post!.nUpvotes}',
                                  //     style: TextStyle(
                                  //       fontSize: getScreenHeight(12),
                                  //       fontWeight: FontWeight.w500,
                                  //       color: AppColors.textColor3,
                                  //     ),
                                  //   ),
                                  // ),
                                  Flexible(
                                      child:
                                          SizedBox(width: getScreenWidth(4))),
                                  IconButton(
                                    onPressed: () {},
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: SvgPicture.asset(
                                      'assets/svgs/shoutdown.svg',
                                    ),
                                  ),
                                  Flexible(
                                      child:
                                          SizedBox(width: getScreenWidth(4))),
                                  // FittedBox(
                                  //   child: Text(
                                  //     '${postFeedModel!.post!.nDownvotes}',
                                  //     style: TextStyle(
                                  //       fontSize: getScreenHeight(12),
                                  //       fontWeight: FontWeight.w500,
                                  //       color: AppColors.textColor3,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ).paddingOnly(b: 32, r: 16, l: 16, t: 5),
                ],
              );
            }),
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
  }) : super(key: key);

  final Size size;
  final bool isMe;
  final bool isLive;
  final bool hasWatched;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            !hasWatched
                ? Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: !isLive
                          ? AppColors.primaryColor
                          : const Color(0xFFDE0606),
                    ),
                    child: Container(
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
                          ),
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle)),
                    ),
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
    ).paddingOnly(r: 16);
  }
}

class DemoSourceEntity {
  int id;
  String url;
  String? previewUrl;
  String type;

  DemoSourceEntity(this.id, this.url, this.type, {this.previewUrl});
}
