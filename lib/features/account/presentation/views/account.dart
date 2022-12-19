import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reach_me/core/components/bottom_sheet_list_tile.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/empty_state.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/components/refresher.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/account/presentation/views/account.details.dart';
import 'package:reach_me/features/account/presentation/views/edit_profile_screen.dart';
import 'package:reach_me/features/account/presentation/views/saved_post.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/chat/presentation/views/msg_chat_interface.dart';
import 'package:reach_me/features/home/data/models/comment_model.dart';
import 'package:reach_me/features/home/data/models/post_model.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';
import 'package:reach_me/features/home/presentation/views/home_screen.dart';
import 'package:reach_me/features/home/presentation/views/timeline.dart';
import 'package:reach_me/features/home/presentation/views/view_comments.dart';
import 'package:reach_me/features/home/presentation/widgets/reposted_post.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/services/database/secure_storage.dart';
import '../../../auth/presentation/views/login_screen.dart';
import '../../../home/presentation/views/post_reach.dart';
import '../../../home/presentation/widgets/post_media.dart';
import 'package:timeago/timeago.dart' as timeago;

class AccountScreen extends StatefulHookWidget {
  static const String id = "account_screen";
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TabController? _tabController;

  late final _reachoutsRefreshController =
      RefreshController(initialRefresh: false);
  late final _commentsRefreshController =
      RefreshController(initialRefresh: false);
  late final _savedPostsRefreshController =
      RefreshController(initialRefresh: false);
  late final _likesRefreshController = RefreshController(initialRefresh: false);
  late final _shoutoutRefreshController =
      RefreshController(initialRefresh: false);
  late final _shoutdownRefreshController =
      RefreshController(initialRefresh: false);
  late final _shareRefreshController = RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    // _reachoutsRefreshController =
    // RefreshController(initialRefresh: false);
    // _commentsRefreshController =
    // RefreshController(initialRefresh: false);
    // _savedPostsRefreshController =
    // RefreshController(initialRefresh: false);
    // _likesRefreshController = RefreshController(initialRefresh: false);
    // _shoutoutRefreshController =
    // RefreshController(initialRefresh: false);
    // _shoutdownRefreshController =
    // RefreshController(initialRefresh: false);
    // _shareRefreshController = RefreshController(initialRefresh: false);
  }

  Set active = {};

  handleTap(index) {
    if (active.isNotEmpty) active.clear();
    setState(() {
      active.add(index);
    });
  }

  TabBar get _tabBar => TabBar(
        isScrollable: true,
        controller: _tabController,
        indicatorWeight: 1.5,
        unselectedLabelColor: AppColors.textColor2,
        indicatorColor: Colors.transparent,
        labelColor: AppColors.white,
        labelPadding: const EdgeInsets.symmetric(horizontal: 10),
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.textColor2,
        ),
        labelStyle: TextStyle(
          fontSize: getScreenHeight(15),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: getScreenHeight(15),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(0);
                collapseProfile();
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: FittedBox(
                  child: Text(
                    'Reaches',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Tab(
            iconMargin: EdgeInsets.zero,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() {
                    _tabController?.animateTo(1);
                    collapseProfile();
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: FittedBox(
                      child: Text(
                        'Likes',
                        style: TextStyle(
                          fontSize: getScreenHeight(15),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(2);
                collapseProfile();
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: FittedBox(
                  child: Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(3);
                collapseProfile();
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: FittedBox(
                  child: Text(
                    'Shoutout',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(4);
                collapseProfile();
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: FittedBox(
                  child: Text(
                    'Shoutdown',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(5);
                collapseProfile();
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: FittedBox(
                  child: Text(
                    'Share',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(6);
                collapseProfile();
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: FittedBox(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
  String message = '';
  bool isGoingDown = false;
  bool isGoingUp = false;
  bool isCollapsed = true;
  double width = getScreenWidth(100);
  double height = getScreenHeight(100);
  ScrollController scrollViewController = ScrollController();

  void collapseProfile() => isCollapsed = false;

  void refreshPage() {
    // switch (_tabController!.index) {
    //   case 0:
    //     _reachoutsRefreshController.requestRefresh();
    //     break;
    //   case 1:
    //     _likesRefreshController.requestRefresh();
    //     break;
    //   case 2:
    //     _commentsRefreshController.requestRefresh();
    //     break;
    //   case 3:
    //     _shoutoutRefreshController.requestRefresh();
    //     break;
    //   case 4:
    //     _shoutdownRefreshController.requestRefresh();
    //     break;
    //   case 5:
    //     _shareRefreshController.requestRefresh();
    //     break;
    //   case 6:
    //     _savedPostsRefreshController.requestRefresh();
    //     break;
    //   default:
    //     _reachoutsRefreshController.requestRefresh();
    //     break;
    // }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final reachDM = useState(false);
    final _posts = useState<List<PostModel>>([]);
    final _comments = useState<List<CommentModel>>([]);
    final _savedPosts = useState<List<SavePostModel>>([]);
    final _currentPost = useState<SavePostModel?>(null);
    final _likedPosts = useState<List<PostFeedModel>>([]);
    final _shoutDowns = useState<List<PostFeedModel>>([]);
    final _shoutOuts = useState<List<PostFeedModel>>([]);
    final _sharedPosts = useState<List<PostFeedModel>>([]);
     final shoutingDown = useState(false);

     final viewProfile = useState(false);
    useEffect(() {
      globals.userBloc!.add(GetUserProfileEvent(email: globals.user!.email!));
      globals.socialServiceBloc!
          .add(GetAllPostsEvent(pageLimit: 50, pageNumber: 1));
      globals.socialServiceBloc!.add(GetPersonalCommentsEvent(
          pageLimit: 50, pageNumber: 1, authId: globals.user!.id));
      globals.socialServiceBloc!
          .add(GetAllSavedPostsEvent(pageLimit: 50, pageNumber: 1));
      globals.socialServiceBloc!
          .add(GetLikedPostsEvent(pageLimit: 50, pageNumber: 1));
      globals.socialServiceBloc!.add(GetVotedPostsEvent(
          pageLimit: 50,
          pageNumber: 1,
          voteType: 'Upvote',
          authId: globals.userId));
      globals.socialServiceBloc!.add(GetVotedPostsEvent(
          pageLimit: 50,
          pageNumber: 1,
          voteType: 'Downvote',
          authId: globals.userId));
      return null;
    }, []);
    var size = MediaQuery.of(context).size;
    return ProgressHUD(
      child: Scaffold(
        body: BlocConsumer<UserBloc, UserState>(
          bloc: globals.userBloc,
          listener: (context, state) {
                 if (state is RecipientUserData) {
                if (reachDM.value) {
                  reachDM.value = false;
                  RouteNavigators.route(
                      context, MsgChatInterface(recipientUser: state.user));
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
                   if (state is GetReachRelationshipSuccess) {
                if (shoutingDown.value) {
                  shoutingDown.value = false;
                  if ((state.isReaching ?? false)) {
                    globals.socialServiceBloc!.add(VotePostEvent(
                      voteType: 'Downvote',
                      postId: _currentPost.value!.post.postId,
                    ));
                  } else {
                    Snackbars.error(context,
                        message: 'You cannot shout down on this user\'s posts');
                  }
                }
              }
            if (state is DeleteAccountSuccess) {
              if (state.deleted ?? false) {
                RouteNavigators.pop(context);
                Snackbars.success(context, message: 'Account deleted!');
                SecureStorage.deleteSecureData();
                RouteNavigators.routeNoWayHome(context, const LoginScreen());
              }
            }

            if (state is DeleteAccountLoading) {
              globals.showLoader(context);
            }

            if (state is DeleteAccountError) {
              RouteNavigators.pop(context);
              Snackbars.error(context, message: state.error);
            }

            if (state is UserError) {
              reachDM.value = false;
            }

            if (state is UserData) {
              globals.user = state.user;
            }
          },
          builder: (context, state) {
            return BlocConsumer<SocialServiceBloc, SocialServiceState>(
              bloc: globals.socialServiceBloc,
              listener: (context, state) {
                if (state is GetAllPostsSuccess) {
                  _posts.value = state.posts!;
                  _reachoutsRefreshController.refreshCompleted();
                }
                if (state is GetAllPostsError) {
                  Snackbars.error(context, message: state.error);
                  _reachoutsRefreshController.refreshFailed();
                }

                
                 if (state is UnlikePostError) {
                    Snackbars.error(context, message: state.error);
                    int pos = _posts.value
                        .indexWhere((e) => e.postId == state.postId);
                    _savedPosts.value[pos].post.isLiked = true;
                    _savedPosts.value[pos].post.nLikes =
                        (_savedPosts.value[pos].post.nLikes ?? 0) + 1;
                  }

                  if (state is LikePostError) {
                    Snackbars.error(context, message: state.error);
                    int pos = _posts.value
                        .indexWhere((e) => e.postId == state.postId);
                    _savedPosts.value[pos].post.isLiked = false;
                    _savedPosts.value[pos].post.nLikes =
                        (_savedPosts.value[pos].post.nLikes ?? 1) - 1;
                  }
                if (state is GetVotedPostsError) {
                  Snackbars.error(context, message: state.error);
                }

                    if (state is DeletePostVoteSuccess) {
                    globals.socialServiceBloc!
                        .add(GetPostFeedEvent(pageLimit: 50, pageNumber: 1));
                  }

                  if (state is DeletePostVoteError) {
                    Snackbars.error(context, message: state.error);
                  }
                if (state is GetPersonalCommentsSuccess) {
                  _comments.value = state.data!;
                  _commentsRefreshController.refreshCompleted();
                }
                if (state is GetPersonalCommentsError) {
                  Snackbars.error(context, message: state.error);
                  _commentsRefreshController.refreshFailed();
                }
                if (state is GetAllSavedPostsSuccess) {
                  _savedPosts.value = state.data!;
                }
                if (state is GetAllSavedPostsError) {
                  Snackbars.error(context, message: state.error);
                }
                if (state is LikePostSuccess || state is UnlikePostSuccess) {
                  refreshPage();
                }

                if (state is VotePostSuccess) {
                  if (!(state.isVoted!)) {
                    Snackbars.success(context,
                        message: 'Post shouted down has been removed!');
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
              },
              builder: (context, state) {
                bool _isLoadingPosts = state is GetAllPostsLoading;
                bool _isLoadingLikes = state is GetLikedPostsLoading;
                bool _isLoadingComments = state is GetPersonalCommentsLoading;
                bool _isLoadingSavedPosts = state is GetAllSavedPostsLoading;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Visibility(
                      visible: isCollapsed,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        fit: StackFit.passthrough,
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          /// Banner image
                          SizedBox(
                            height: getScreenHeight(200),
                            width: size.width,
                            child: GestureDetector(
                              child: const CoverPicture(),
                              onTap: () {
                                RouteNavigators.route(
                                    context,
                                    FullScreenWidget(
                                      child: Stack(children: <Widget>[
                                        Container(
                                          color: AppColors
                                              .black, // Your screen background color
                                        ),
                                        Column(children: <Widget>[
                                          Container(
                                              height: getScreenHeight(100)),
                                          const CoverPicture(),
                                        ]),
                                        Positioned(
                                          top: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          child: AppBar(
                                            title: const Text(
                                                'Cover Photo'), // You can add title here
                                            leading: IconButton(
                                              icon: const Icon(Icons.arrow_back,
                                                  color: AppColors.white),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            ),
                                            backgroundColor: AppColors
                                                .black, //You can make this transparent
                                            elevation: 0.0, //No shadow
                                          ),
                                        ),
                                      ]),
                                    ));
                              },
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Container(
                                    width: getScreenWidth(40),
                                    height: getScreenHeight(40),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          AppColors.textColor2.withOpacity(0.5),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/svgs/back.svg',
                                      color: AppColors.white,
                                      width: getScreenWidth(50),
                                      height: getScreenHeight(50),
                                    ),
                                  ),
                                  onPressed: () => RouteNavigators.route(
                                      context, const HomeScreen()),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Container(
                                    width: getScreenWidth(40),
                                    height: getScreenHeight(40),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          AppColors.textColor2.withOpacity(0.5),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/svgs/pop-vertical.svg',
                                      color: AppColors.white,
                                      width: getScreenWidth(50),
                                      height: getScreenHeight(50),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await showProfileMenuBottomSheet(context,
                                        user: globals.user!);
                                  },
                                  splashRadius: 20,
                                )
                              ]).paddingOnly(t: 40),
                          Positioned(
                            top: size.height * 0.2 - 20,
                            child: AnimatedContainer(
                                width:
                                    isGoingDown ? width : getScreenWidth(100),
                                height:
                                    isGoingDown ? height : getScreenHeight(100),
                                duration: const Duration(seconds: 1),
                                child: GestureDetector(
                                  child: const ProfilePicture(
                                    height: 90,
                                  ),
                                  onTap: () {
                                    RouteNavigators.route(
                                        context,
                                        FullScreenWidget(
                                          child: Stack(children: <Widget>[
                                            Container(
                                              color: AppColors
                                                  .black, // Your screen background color
                                            ),
                                            Column(children: <Widget>[
                                              Container(
                                                  height: getScreenHeight(100)),
                                              Image.network(
                                                globals.user!.profilePicture!,
                                                fit: BoxFit.contain,
                                              ),
                                            ]),
                                            Positioned(
                                              top: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              child: AppBar(
                                                title: const Text(
                                                    'Profile Picture'), // You can add title here
                                                leading: IconButton(
                                                  icon: const Icon(
                                                      Icons.arrow_back,
                                                      color: AppColors.white),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                ),
                                                backgroundColor: AppColors
                                                    .black, //You can make this transparent
                                                elevation: 0.0, //No shadow
                                              ),
                                            ),
                                          ]),
                                        ));
                                  },
                                )),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: isCollapsed,
                      child: Column(
                        children: [
                          SizedBox(height: getScreenHeight(10)),
                          Text(
                              ('${globals.user!.firstName} ${globals.user!.lastName}')
                                  .toTitleCase(),
                              style: TextStyle(
                                fontSize: getScreenHeight(17),
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor2,
                              )),
                          Text('@${globals.user!.username ?? 'username'}',
                              style: TextStyle(
                                fontSize: getScreenHeight(13),
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor2,
                              )),
                          SizedBox(height: getScreenHeight(15)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => RouteNavigators.route(context,
                                        const AccountStatsInfo(index: 0)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          globals.user!.nReachers.toString(),
                                          style: TextStyle(
                                              fontSize: getScreenHeight(15),
                                              color: AppColors.textColor2,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(width: getScreenWidth(5)),
                                        Text(
                                          'Reachers',
                                          style: TextStyle(
                                              fontSize: getScreenHeight(15),
                                              color: AppColors.greyShade2,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: getScreenWidth(20)),
                                  InkWell(
                                    onTap: () => RouteNavigators.route(context,
                                        const AccountStatsInfo(index: 1)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          globals.user!.nReaching.toString(),
                                          style: TextStyle(
                                              fontSize: getScreenHeight(15),
                                              color: AppColors.textColor2,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(width: getScreenWidth(5)),
                                        Text(
                                          'Reaching',
                                          style: TextStyle(
                                              fontSize: getScreenHeight(15),
                                              color: AppColors.greyShade2,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: getScreenWidth(20)),
                                  InkWell(
                                    onTap: () => RouteNavigators.route(context,
                                        const AccountStatsInfo(index: 2)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          globals.user!.nStaring.toString(),
                                          style: TextStyle(
                                              fontSize: getScreenHeight(15),
                                              color: AppColors.textColor2,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(width: getScreenWidth(5)),
                                        Text(
                                          'Star',
                                          style: TextStyle(
                                              fontSize: getScreenHeight(15),
                                              color: AppColors.greyShade2,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: getScreenWidth(20)),
                                  InkWell(
                                    onTap: () => RouteNavigators.route(context,
                                        const AccountStatsInfo(index: 3)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          //nblock Variable here
                                          globals.user!.nBlocked.toString(),
                                          style: TextStyle(
                                              fontSize: getScreenHeight(15),
                                              color: AppColors.textColor2,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(width: getScreenWidth(5)),
                                        Text(
                                          'Block',
                                          style: TextStyle(
                                              fontSize: getScreenHeight(15),
                                              color: AppColors.greyShade2,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          globals.user!.bio != null && globals.user!.bio != ''
                              ? SizedBox(height: getScreenHeight(20))
                              : const SizedBox.shrink(),
                          SizedBox(
                              width: getScreenWidth(290),
                              child: Text(
                                globals.user!.bio ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: getScreenHeight(13),
                                  color: AppColors.greyShade2,
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                          globals.user!.bio != null && globals.user!.bio != ''
                              ? SizedBox(height: getScreenHeight(20))
                              : const SizedBox.shrink(),
                          SizedBox(
                              width: getScreenWidth(145),
                              height: getScreenHeight(45),
                              child: CustomButton(
                                label: 'Edit Profile',
                                labelFontSize: getScreenHeight(14),
                                color: AppColors.white,
                                onPressed: () {
                                  RouteNavigators.route(
                                      context, const EditProfileScreen());
                                },
                                size: size,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 9,
                                  horizontal: 21,
                                ),
                                textColor: AppColors.textColor2,
                                borderSide: const BorderSide(
                                    color: AppColors.greyShade5),
                              )),
                          SizedBox(height: getScreenHeight(15)),
                        ],
                      ).paddingOnly(t: 50),
                    ),
                    Visibility(
                      visible: isCollapsed ? true : false,
                      child: Divider(
                        color: const Color(0xFF767474).withOpacity(0.5),
                        thickness: 0.5,
                      ),
                    ),
                    Visibility(
                      visible: isCollapsed ? false : true,
                      child: GestureDetector(
                        child: Stack(
                          alignment: Alignment.topCenter,
                          fit: StackFit.passthrough,
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            /// Banner image
                            SizedBox(
                              height: getScreenHeight(200),
                              width: size.width,
                              child: SvgPicture.asset(
                                "assets/svgs/cover-banner.svg",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Container(
                                      width: getScreenWidth(40),
                                      height: getScreenHeight(40),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.textColor2
                                            .withOpacity(0.5),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/svgs/back.svg',
                                        color: AppColors.white,
                                        width: getScreenWidth(50),
                                        height: getScreenHeight(50),
                                      ),
                                    ),
                                    onPressed: () => setState(() {
                                      isCollapsed = !isCollapsed;
                                    }),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Container(
                                      width: getScreenWidth(40),
                                      height: getScreenHeight(40),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.textColor2
                                            .withOpacity(0.5),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/svgs/pop-vertical.svg',
                                        color: AppColors.white,
                                        width: getScreenWidth(50),
                                        height: getScreenHeight(50),
                                      ),
                                    ),
                                   onPressed: () => RouteNavigators.route(
                                      context, const HomeScreen()),
                                    splashRadius: 20,
                                  )
                                ]).paddingOnly(t: 40),
                            Positioned(
                              top: size.height * 0.2 - 100,
                              child: GestureDetector(
                                child: Column(
                                  children: [
                                    const ProfilePicture(
                                      height: 60,
                                      width: 60,
                                    ),
                                    SizedBox(height: getScreenHeight(10)),
                                    Column(
                                      children: [
                                        Text(
                                            ('${globals.user!.firstName} ${globals.user!.lastName}')
                                                .toTitleCase(),
                                            style: TextStyle(
                                              fontSize: getScreenHeight(19),
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.white,
                                            )),
                                        Text(
                                            '@${globals.user!.username ?? 'username'}',
                                            style: TextStyle(
                                              fontSize: getScreenHeight(13),
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.white,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  RouteNavigators.route(
                                      context,
                                      FullScreenWidget(
                                        child: Stack(children: <Widget>[
                                          Container(
                                            color: AppColors
                                                .black, // Your screen background color
                                          ),
                                          Column(children: <Widget>[
                                            Container(
                                                height: getScreenHeight(100)),
                                            Image.network(
                                              globals.user!.profilePicture!,
                                              fit: BoxFit.contain,
                                            ),
                                          ]),
                                          Positioned(
                                            top: 0.0,
                                            left: 0.0,
                                            right: 0.0,
                                            child: AppBar(
                                              title: const Text(
                                                  'Profile Picture'), // You can add title here
                                              leading: IconButton(
                                                icon: const Icon(
                                                    Icons.arrow_back,
                                                    color: AppColors.white),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              ),
                                              backgroundColor: AppColors
                                                  .black, //You can make this transparent
                                              elevation: 0.0, //No shadow
                                            ),
                                          ),
                                        ]),
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                        onVerticalDragEnd: (dragEndDetails) {
                          if (dragEndDetails.primaryVelocity! > 0) {
                            setState(() {
                              isCollapsed = !isCollapsed;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: getScreenHeight(10)),
                    Center(child: _tabBar),
                    Expanded(
                      child: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        controller: _tabController,
                        children: [
                          //REACHES TAB
                          if (_isLoadingPosts)
                            const CircularLoader()
                          else
                            Refresher(
                              controller: _reachoutsRefreshController,
                              onRefresh: () {
                                globals.socialServiceBloc!.add(GetAllPostsEvent(
                                  pageLimit: 50,
                                  pageNumber: 1,
                                ));
                              },
                              child: _posts.value.isEmpty
                                  ? ListView(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      children: const [
                                        EmptyTabWidget(
                                          title: "Reaches you’ve made",
                                          subtitle:
                                              "Find all posts or contributions you’ve made here ",
                                        )
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount: _posts.value.length,
                                      itemBuilder: (context, index) {
                                        return _ReacherCard(
                                          postModel: _posts.value[index],
                                          // onLike: () {
                                          //   _likePost(index);
                                          // },
                                        );
                                      },
                                    ),
                            ),

                          //LIKES TAB
                          if (_isLoadingLikes)
                            const CircularLoader()
                          else
                            Refresher(
                              controller: _likesRefreshController,
                              onRefresh: () {
                                globals.socialServiceBloc!.add(
                                    GetLikedPostsEvent(
                                        pageLimit: 50, pageNumber: 1));
                              },
                              child: _likedPosts.value.isEmpty
                                  ? ListView(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      children: const [
                                        EmptyTabWidget(
                                          title: "Likes you made",
                                          subtitle:
                                              "Find post you liked and your post that was liked",
                                        )
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount: _likedPosts.value.length,
                                      itemBuilder: (context, index) {
                                        return PostFeedReacherCard(
                                          likingPost: false,
                                          postFeedModel:
                                              _likedPosts.value[index],
                                          isLiked: _likedPosts
                                                  .value[index].like!.isNotEmpty
                                              ? true
                                              : false,
                                          isVoted: _likedPosts
                                                  .value[index].vote!.isNotEmpty
                                              ? true
                                              : false,
                                          voteType: _likedPosts
                                                  .value[index].vote!.isNotEmpty
                                              ? _likedPosts.value[index]
                                                  .vote![0].voteType
                                              : null,
                                          onMessage: () {
                                            reachDM.value = true;

                                            handleTap(index);
                                            if (active.contains(index)) {
                                              globals.userBloc!.add(
                                                  GetRecipientProfileEvent(
                                                      email: _likedPosts
                                                          .value[index]
                                                          .postOwnerId!));
                                            }
                                          },
                                          onUpvote: () {
                                            handleTap(index);
                                            if (active.contains(index)) {
                                              globals.socialServiceBloc!
                                                  .add(VotePostEvent(
                                                voteType: 'Upvote',
                                                postId: _likedPosts
                                                    .value[index].postId,
                                              ));
                                            }
                                          },
                                          onDownvote: () {
                                            handleTap(index);
                                            if (active.contains(index)) {
                                              globals.socialServiceBloc!
                                                  .add(VotePostEvent(
                                                voteType: 'Downvote',
                                                postId: _likedPosts
                                                    .value[index].postId,
                                              ));
                                            }
                                          },
                                          onLike: () {
                                            handleTap(index);
                                            if (active.contains(index)) {
                                              if (_likedPosts.value[index].like!
                                                  .isNotEmpty) {
                                                globals.socialServiceBloc!
                                                    .add(UnlikePostEvent(
                                                  postId: _likedPosts
                                                      .value[index].postId,
                                                ));
                                              } else {
                                                globals.socialServiceBloc!.add(
                                                  LikePostEvent(
                                                      postId: _likedPosts
                                                          .value[index].postId),
                                                );
                                              }
                                            }
                                          },
                                        );
                                      },
                                    ),
                            ),

                          //COMMENTS TAB
                          if (_isLoadingComments)
                            const CircularLoader()
                          else
                            Refresher(
                              controller: _commentsRefreshController,
                              onRefresh: () {
                                globals.socialServiceBloc!
                                    .add(GetPersonalCommentsEvent(
                                  pageLimit: 50,
                                  pageNumber: 1,
                                  authId: globals.user!.id,
                                ));
                              },
                              child: _comments.value.isEmpty
                                  ? ListView(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      children: const [
                                        EmptyTabWidget(
                                            title:
                                                'Comments you made on a post and comments made on your post',
                                            subtitle:
                                                'Here you will find all comments you’ve made on a post and also those made on your own posts')
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount: _comments.value.length,
                                      itemBuilder: (context, index) {
                                        return _CommentReachCard(
                                          commentModel: _comments.value[index],
                                          onMessage: () {
                                            reachDM.value = true;
                                            handleTap(index);
                                            if (active.contains(index)) {
                                              globals.userBloc!.add(
                                                  GetRecipientProfileEvent(
                                                      email: _likedPosts
                                                          .value[index]
                                                          .postOwnerId!));
                                            }
                                          },
                                          // onLike: () {
                                          //   handleTap(index);
                                          //   if (active.contains(index)) {
                                          //     if (_likedPosts.value[index].like!
                                          //         .isNotEmpty) {
                                          //       globals.socialServiceBloc!
                                          //           .add(UnlikePostEvent(
                                          //         postId: _likedPosts
                                          //             .value[index].postId,
                                          //       ));
                                          //     } else {
                                          //       globals.socialServiceBloc!.add(
                                          //         LikePostEvent(
                                          //             postId: _likedPosts
                                          //                 .value[index].postId),
                                          //       );
                                          //     }
                                          //   }
                                          // },
                                        );
                                      },
                                    ),
                            ),

                          //SHOUTOUTS TAB
                          if (_isLoadingComments)
                            const CircularLoader()
                          else
                            Refresher(
                              controller: _shoutoutRefreshController,
                              onRefresh: () {
                                globals.socialServiceBloc!
                                    .add(GetPersonalCommentsEvent(
                                  pageLimit: 50,
                                  pageNumber: 1,
                                  authId: globals.user!.id,
                                ));
                              },
                              child: _shoutOuts.value.isEmpty
                                  ? ListView(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      children: const [
                                        EmptyTabWidget(
                                            title:
                                                "Posts you've shouted out and your posts that has been shouted out",
                                            subtitle:
                                                "See posts you've shouted out and your post that has been shouted out")
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount: _shoutOuts.value.length,
                                      itemBuilder: (context, index) {
                                        return PostFeedReacherCard(
                                          likingPost: false,
                                          postFeedModel:
                                              _shoutOuts.value[index],
                                          isLiked: _shoutOuts
                                                  .value[index].like!.isNotEmpty
                                              ? true
                                              : false,
                                          isVoted: _shoutOuts
                                                  .value[index].vote!.isNotEmpty
                                              ? true
                                              : false,
                                          voteType: _shoutOuts
                                                  .value[index].vote!.isNotEmpty
                                              ? _shoutOuts.value[index].vote![0]
                                                  .voteType
                                              : null,
                                          onMessage: () {
                                            reachDM.value = true;

                                            handleTap(index);
                                            if (active.contains(index)) {
                                              globals.userBloc!.add(
                                                  GetRecipientProfileEvent(
                                                      email: _shoutOuts
                                                          .value[index]
                                                          .postOwnerId!));
                                            }
                                          },
                                          onUpvote: () {
                                            handleTap(index);
                                            if (active.contains(index)) {
                                              globals.socialServiceBloc!
                                                  .add(VotePostEvent(
                                                voteType: 'Upvote',
                                                postId: _shoutOuts
                                                    .value[index].postId,
                                              ));
                                            }
                                          },
                                          onDownvote: () {
                                            handleTap(index);
                                            if (active.contains(index)) {
                                              globals.socialServiceBloc!
                                                  .add(VotePostEvent(
                                                voteType: 'Downvote',
                                                postId: _shoutOuts
                                                    .value[index].postId,
                                              ));
                                            }
                                          },
                                          onLike: () {
                                            handleTap(index);
                                            if (active.contains(index)) {
                                              if (_shoutOuts.value[index].like!
                                                  .isNotEmpty) {
                                                globals.socialServiceBloc!
                                                    .add(UnlikePostEvent(
                                                  postId: _shoutOuts
                                                      .value[index].postId,
                                                ));
                                              } else {
                                                globals.socialServiceBloc!.add(
                                                  LikePostEvent(
                                                      postId: _shoutOuts
                                                          .value[index].postId),
                                                );
                                              }
                                            }
                                          },
                                        );
                                      },
                                    ),
                            ),

                          //SHOUTDOWN TAB
                          if (_isLoadingComments)
                            const CircularLoader()
                          else
                            Refresher(
                              controller: _shoutdownRefreshController,
                              onRefresh: () {
                                globals.socialServiceBloc!
                                    .add(GetPersonalCommentsEvent(
                                  pageLimit: 50,
                                  pageNumber: 1,
                                  authId: globals.user!.id,
                                ));
                              },
                              child: _shoutDowns.value.isEmpty
                                  ? ListView(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      children: const [
                                        EmptyTabWidget(
                                            title:
                                                "Posts you've shouted down and your posts that has been shouted down",
                                            subtitle:
                                                "See posts you've shouted down and your post that has been shouted down")
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount: _shoutDowns.value.length,
                                      itemBuilder: (context, index) {
                                        return PostFeedReacherCard(
                                          likingPost: false,
                                          postFeedModel:
                                              _shoutDowns.value[index],
                                          isLiked: _shoutDowns
                                                  .value[index].like!.isNotEmpty
                                              ? true
                                              : false,
                                          isVoted: _shoutDowns
                                                  .value[index].vote!.isNotEmpty
                                              ? true
                                              : false,
                                          voteType: _shoutDowns
                                                  .value[index].vote!.isNotEmpty
                                              ? _shoutDowns.value[index]
                                                  .vote![0].voteType
                                              : null,
                                          onMessage: () {
                                            reachDM.value = true;

                                            handleTap(index);
                                            if (active.contains(index)) {
                                              globals.userBloc!.add(
                                                  GetRecipientProfileEvent(
                                                      email: _shoutDowns
                                                          .value[index]
                                                          .postOwnerId!));
                                            }
                                          },
                                          onUpvote: () {
                                            handleTap(index);
                                            if (active.contains(index)) {
                                              globals.socialServiceBloc!
                                                  .add(VotePostEvent(
                                                voteType: 'upvote',
                                                postId: _shoutDowns
                                                    .value[index].postId,
                                              ));
                                            }
                                          },
                                          onDownvote: () {
                                            handleTap(index);
                                            if (active.contains(index)) {
                                              globals.socialServiceBloc!
                                                  .add(VotePostEvent(
                                                voteType: 'downvote',
                                                postId: _shoutDowns
                                                    .value[index].postId,
                                              ));
                                            }
                                          },
                                          onLike: () {
                                            handleTap(index);
                                            if (active.contains(index)) {
                                              if (_shoutDowns.value[index].like!
                                                  .isNotEmpty) {
                                                globals.socialServiceBloc!
                                                    .add(UnlikePostEvent(
                                                  postId: _shoutDowns
                                                      .value[index].postId,
                                                ));
                                              } else {
                                                globals.socialServiceBloc!.add(
                                                  LikePostEvent(
                                                      postId: _shoutDowns
                                                          .value[index].postId),
                                                );
                                              }
                                            }
                                          },
                                        );
                                      },
                                    ),
                            ),

                          //SHARE TAB
                          if (_isLoadingComments)
                            const CircularLoader()
                          else
                            Refresher(
                              controller: _shareRefreshController,
                              onRefresh: () {
                                globals.socialServiceBloc!
                                    .add(GetPersonalCommentsEvent(
                                  pageLimit: 50,
                                  pageNumber: 1,
                                  authId: globals.user!.id,
                                ));
                              },
                              child: _sharedPosts.value.isEmpty
                                  ? ListView(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      children: const [
                                        EmptyTabWidget(
                                            title: "Post you shared",
                                            subtitle: "Find post you've shared")
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount: _sharedPosts.value.length,
                                      itemBuilder: (context, index) {
                                        return Container();
                                      },
                                    ),
                            ),

                          //SAVED POSTS TAB
                          if (_isLoadingSavedPosts)
                            const CircularLoader()
                          else
                            Refresher(
                              controller: _savedPostsRefreshController,
                              onRefresh: () {
                                globals.socialServiceBloc!.add(
                                    GetAllSavedPostsEvent(
                                        pageLimit: 50, pageNumber: 1));
                              },
                              child: _savedPosts.value.isEmpty
                                  ? ListView(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      children: const [
                                        EmptyTabWidget(
                                          title: "No saved posts",
                                          subtitle: "",
                                        )
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount: _savedPosts.value.length,
                                      itemBuilder: (context, index) {
                                        return
                                          SavedPostReacherCard(
                                            likingPost: false,
                                                    
                                                      isLiked: (_savedPosts
                                                                  .value[index]
                                                                  .post
                                                                  .isLiked ??
                                                              false)
                                                          ? true
                                                          : false,
                                                      isVoted: (_savedPosts
                                                                  .value[index]
                                                                  .post
                                                                  .isVoted ??
                                                              '')
                                                          .isNotEmpty,
                                                      voteType: _savedPosts
                                                          .value[index]
                                                          .post
                                                          .isVoted,
                                                      onViewProfile: () {
                                                        viewProfile.value =
                                                            true;
                                                        ProgressHUD.of(context)
                                                            ?.showWithText(
                                                                'Viewing Profile');
                                                        globals.userBloc!.add(
                                                            GetRecipientProfileEvent(
                                                                email: _savedPosts
                                                                    .value[
                                                                        index]
                                                                    .post.postOwnerProfile!.authId));
                                                      },
                                                      onMessage: () {
                                                        HapticFeedback
                                                            .mediumImpact();
                                                        reachDM.value = true;

                                                        handleTap(index);
                                                        if (active
                                                            .contains(index)) {
                                                          globals.userBloc!.add(
                                                              GetRecipientProfileEvent(
                                                                  email: _savedPosts
                                                                    .value[
                                                                        index]
                                                                    .post.postOwnerProfile!.authId));
                                                        }
                                                      },
                                                      onUpvote: () {
                                                        HapticFeedback
                                                            .mediumImpact();
                                                        handleTap(index);

                                                        if (active
                                                            .contains(index)) {
                                                          if ((_savedPosts
                                                                      .value[
                                                                          index]
                                                                      .post.vote ??
                                                                  [])
                                                              .isEmpty) {
                                                            globals
                                                                .socialServiceBloc!
                                                                .add(
                                                                    VotePostEvent(
                                                              voteType:
                                                                  'Upvote',
                                                              postId: _savedPosts
                                                                  .value[index]
                                                                  .post.postId,
                                                            ));
                                                          } else {
                                                            globals
                                                                .socialServiceBloc!
                                                                .add(
                                                                    DeletePostVoteEvent(
                                                              voteId: _savedPosts.value
                                                                  [index]
                                                                  .post.postId,
                                                            ));
                                                          }
                                                        }
                                                      },
                                                      onDownvote: () {
                                                        HapticFeedback
                                                            .mediumImpact();
                                                        handleTap(index);
                                                        _currentPost.value =
                                                            _savedPosts.value[index];
                                                        if (active
                                                            .contains(index)) {
                                                          shoutingDown.value =
                                                              true;
                                                          globals.userBloc!.add(
                                                              GetReachRelationshipEvent(
                                                                  userIdToReach: _savedPosts
                                                                    .value[
                                                                        index]
                                                                    .post.postOwnerProfile!.authId,
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
                                                        if (active
                                                            .contains(index)) {
                                                          if (_savedPosts
                                                                  .value[index]
                                                                  .post
                                                                  .isLiked ??
                                                              false) {
                                                            _savedPosts
                                                                    .value[index]
                                                                    .post
                                                                    .isLiked =
                                                                false;
                                                            _savedPosts
                                                                .value[index]
                                                                .post
                                                                .nLikes = (_savedPosts
                                                                        .value[
                                                                            index]
                                                                        .post
                                                                        .nLikes ??
                                                                    1) -
                                                                1;
                                                            globals
                                                                .socialServiceBloc!
                                                                .add(
                                                                    UnlikePostEvent(
                                                              postId: _savedPosts
                                                                  .value[index]
                                                                  .post.postId,
                                                            ));
                                                          } else {
                                                            _savedPosts
                                                                .value[index]
                                                                .post
                                                                .isLiked = true;
                                                            _savedPosts
                                                                .value[index]
                                                                .post
                                                                .nLikes = (_savedPosts
                                                                        .value[
                                                                            index]
                                                                        .post
                                                                        .nLikes ??
                                                                    0) +
                                                                1;
                                                            globals
                                                                .socialServiceBloc!
                                                                .add(
                                                              LikePostEvent(
                                                                  postId: _savedPosts
                                                                      .value[
                                                                          index]
                                                                      .post.postId),
                                                            );
                                                          }
                                                        }
                                                      },
                                                   
                                          savedPostModel:
                                              _savedPosts.value[index],
                                          onDelete: () {
                                            handleTap(index);
                                            if (active.contains(index)) {
                                              globals.socialServiceBloc!.add(
                                                  DeleteSavedPostEvent(
                                                      postId: _savedPosts
                                                          .value[index]
                                                          .post.postId));
                                            }
                                          },
                                        );
                               
                                      },
                                    ),
                          
                            )
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ReacherCard extends HookWidget {
  const _ReacherCard({
    Key? key,
    required this.postModel,
    this.onComment,
    this.onDownvote,
    this.onLike,
    this.onMessage,
    this.onUpvote,
    this.likeColour,
  }) : super(key: key);

  final PostModel? postModel;
  final Function()? onLike, onComment, onMessage, onUpvote, onDownvote;
  final Color? likeColour;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
     final postDuration = timeago.format(postModel!.createdAt!);
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
            listener: (context, state) {},
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
                            globals.user!.profilePicture,
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
                                    '@${postModel!.postOwnerProfile!.username}',
                                    style: TextStyle(
                                      fontSize: getScreenHeight(15),
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor2,
                                    ),
                                  ),
                                  // const SizedBox(width: 3),
                                  // SvgPicture.asset('assets/svgs/verified.svg')
                                ],
                              ),
                               Row(
                                  children: [
                                    Text(
                                      postModel!.location! == 'nil' ||
                                              postModel!.location! ==
                                                  'NIL' ||
                                              postModel!.location ==
                                                  null
                                          ? ''
                                          : postModel!
                                                      .location!.length >
                                                  23
                                              ? postModel!.location!
                                                  .substring(0, 23)
                                              : postModel!.location!,
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
                              await _showReacherCardBottomSheet(
                                  context, postModel!);
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
                      postModel!.content ?? '',
                      style: TextStyle(
                        fontSize: getScreenHeight(14),
                        fontWeight: FontWeight.w400,
                      ),
                    ).paddingSymmetric(v: 10, h: 16),
                  ),
                  if ((postModel!.imageMediaItems ?? []).isNotEmpty ||
                      (postModel!.videoMediaItem ?? '').isNotEmpty)
                    PostMedia(post: postModel!)
                        .paddingOnly(r: 16, l: 16, b: 16, t: 10)
                  else
                    const SizedBox.shrink(),
                  (postModel!.audioMediaItem ?? '').isNotEmpty
                      ? PostAudioMedia(path: postModel!.audioMediaItem!)
                          .paddingOnly(l: 16, r: 16, b: 10, t: 0)
                      : const SizedBox.shrink(),
                  (postModel?.repostedPost != null)
                      ? RepostedPost(
                          post: postModel!,
                        ).paddingOnly(l: 0, r: 0, b: 10, t: 0)
                      : const SizedBox.shrink(),
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
                                onPressed: () {
                                  if (onLike != null) onLike!();
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: SvgPicture.asset(
                                  postModel!.isLiked ?? false
                                      ? 'assets/svgs/like-active.svg'
                                      : 'assets/svgs/like.svg',
                                  color: likeColour,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                              SizedBox(width: getScreenWidth(4)),
                              FittedBox(
                                child: Text(
                                  '${postModel!.nLikes}',
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
                                  if (onComment != null) onComment!();
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
                                  '${postModel!.nComments}',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(12),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor3,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: postModel!.authId != globals.userId,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: getScreenWidth(15)),
                                    IconButton(
                                      onPressed: () {
                                        if (onMessage != null) onMessage!();
                                      },
                                      padding: const EdgeInsets.all(0),
                                      constraints: const BoxConstraints(),
                                      icon: SvgPicture.asset(
                                        'assets/svgs/message.svg',
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              )
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
                                    onPressed: () {
                                      if (onUpvote != null) onUpvote;
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: SvgPicture.asset(
                                      (postModel?.isVoted ?? '') == 'Upvote'
                                          ? 'assets/svgs/shoutup-active.svg'
                                          : 'assets/svgs/shoutup.svg',
                                      height: 20,
                                    ),
                                  ),
                                  Flexible(
                                      child:
                                          SizedBox(width: getScreenWidth(4))),
                                  Flexible(
                                      child:
                                          SizedBox(width: getScreenWidth(4))),
                                  IconButton(
                                    onPressed: () {
                                      if (onDownvote != null) onDownvote;
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: SvgPicture.asset(
                                      'assets/svgs/downvote.svg',
                                      width: 20,
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
                  ).paddingOnly(b: 32, r: 16, l: 16, t: 5),
                ],
              );
            }),
      ),
    );
  }
}

class _CommentReachCard extends HookWidget {
  const _CommentReachCard({
    Key? key,
    required this.commentModel,
    this.onComment,
    this.onDownvote,
    this.onLike,
    this.onMessage,
    this.onUpvote,
    this.likeColour,
  }) : super(key: key);

  final CommentModel? commentModel;
  final Function()? onLike, onComment, onMessage, onUpvote, onDownvote;
  final Color? likeColour;

  @override
  Widget build(BuildContext context) {
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
            listener: (context, state) {},
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
                            globals.user!.profilePicture,
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
                                    '@${commentModel!.commentOwnerProfile!.username}',
                                    style: TextStyle(
                                      fontSize: getScreenHeight(15),
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor2,
                                    ),
                                  ),
                                  // const SizedBox(width: 3),
                                  // SvgPicture.asset('assets/svgs/verified.svg')
                                ],
                              ),
                              Text(
                                'Comment on @${commentModel!.commentOwnerProfile!.username}',
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
                    ],
                  ),
                  Flexible(
                    child: Text(
                      commentModel!.content ?? '',
                      style: TextStyle(
                        fontSize: getScreenHeight(14),
                        fontWeight: FontWeight.w400,
                      ),
                    ).paddingSymmetric(v: 10, h: 16),
                  ),
                  SizedBox(height: getScreenHeight(10)),
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
                                onPressed: () {
                                  if (onLike != null) onLike!();
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: SvgPicture.asset(
                                  (commentModel!.like ?? []).indexWhere((e) =>
                                              e.authId == globals.userId) <
                                          0
                                      ? 'assets/svgs/like.svg'
                                      : 'assets/svgs/like-active.svg',
                                  color: likeColour,
                                ),
                              ),
                              SizedBox(width: getScreenWidth(4)),
                              FittedBox(
                                child: Text(
                                  '${commentModel!.nLikes}',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(12),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor3,
                                  ),
                                ),
                              ),
                              // SizedBox(width: getScreenWidth(15)),
                              // IconButton(
                              //   onPressed: () {
                              //     // RouteNavigators.route(
                              //     //     context,  ViewCommentsScreen(post: postFeedModel!));
                              //   },
                              //   padding: EdgeInsets.zero,
                              //   constraints: const BoxConstraints(),
                              //   icon: SvgPicture.asset(
                              //     'assets/svgs/comment.svg',
                              //     height: 20,
                              //     width: 20,
                              //   ),
                              // ),
                              // SizedBox(width: getScreenWidth(4)),
                              // FittedBox(
                              //   child: Text(
                              //     '${commentModel!.nComments}',
                              //     style: TextStyle(
                              //       fontSize: getScreenHeight(12),
                              //       fontWeight: FontWeight.w500,
                              //       color: AppColors.textColor3,
                              //     ),
                              //   ),
                              // ),
                              if (commentModel!.authId != globals.user!.id)
                                SizedBox(width: getScreenWidth(15)),
                              if (commentModel!.authId != globals.user!.id)
                                IconButton(
                                  onPressed: () {
                                    if (onMessage != null) onMessage!();
                                  },
                                  padding: const EdgeInsets.all(0),
                                  constraints: const BoxConstraints(),
                                  icon: SvgPicture.asset(
                                    'assets/svgs/message.svg',
                                    height: getScreenHeight(20),
                                    width: getScreenWidth(20),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).paddingOnly(b: 10, r: 20, l: 20),
                ],
              );
            }),
      ),
    );
  }
}

Future _showReacherCardBottomSheet(
    BuildContext context, PostModel postModel) async {
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
                ).paddingOnly(t: 23),
                SizedBox(height: getScreenHeight(20)),
                Column(
                  children: [
                    if (postModel.authId == globals.user!.id)
                      KebabBottomTextButton(
                          label: 'Edit content',
                          onPressed: () {
                            globals.socialServiceBloc!
                                .add(GetPostEvent(postId: postModel.postId));
                          }),
                    if (postModel.authId == globals.user!.id)
                      KebabBottomTextButton(
                          label: 'Delete post',
                          onPressed: () {
                            globals.socialServiceBloc!
                                .add(DeletePostEvent(postId: postModel.postId));
                            RouteNavigators.pop(context);
                          }),
                    KebabBottomTextButton(
                        label: 'Share Post',
                        onPressed: () {
                          RouteNavigators.pop(context);
                          Share.share(
                              'Have fun viewing this: ${postModel.postSlug!}');
                        }),
                    KebabBottomTextButton(
                      label: 'Copy link',
                      onPressed: () {
                        RouteNavigators.pop(context);
                        Clipboard.setData(
                            ClipboardData(text: postModel.postSlug!));
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

class RecipientAccountProfile extends StatefulHookWidget {
  static const String id = "recipient_account_screen";
  final String? recipientEmail,
      recipientImageUrl,
      recipientId,
      recipientCoverImageUrl;
  const RecipientAccountProfile(
      {Key? key,
      this.recipientEmail,
      this.recipientImageUrl,
      this.recipientCoverImageUrl,
      this.recipientId})
      : super(key: key);

  @override
  State<RecipientAccountProfile> createState() =>
      _RecipientAccountProfileState();
}

class _RecipientAccountProfileState extends State<RecipientAccountProfile>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  late final _reachoutsRefreshController =
      RefreshController(initialRefresh: false);
  late final _commentsRefreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    globals.socialServiceBloc!.add(GetAllPostsEvent(
        pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
    globals.socialServiceBloc!.add(GetPersonalCommentsEvent(
        pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
    globals.userBloc!.add(GetRecipientProfileEvent(email: widget.recipientId));
    globals.userBloc!.add(GetReachRelationshipEvent(
        userIdToReach: widget.recipientId,
        type: ReachRelationshipType.reaching));
    globals.userBloc!
        .add(GetStarRelationshipEvent(userIdToStar: widget.recipientId));
    globals.socialServiceBloc!.add(GetLikedPostsEvent(
        pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
    globals.socialServiceBloc!.add(GetVotedPostsEvent(
        pageLimit: 50,
        pageNumber: 1,
        voteType: 'Upvote',
        authId: widget.recipientId));
    globals.socialServiceBloc!.add(GetVotedPostsEvent(
        pageLimit: 50,
        pageNumber: 1,
        voteType: 'Downvote',
        authId: widget.recipientId));
  }

  TabBar get _tabBar => TabBar(
        isScrollable: true,
        controller: _tabController,
        indicatorWeight: 1.5,
        unselectedLabelColor: AppColors.textColor2,
        indicatorColor: Colors.transparent,
        labelColor: AppColors.white,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.textColor2,
        ),
        labelStyle: TextStyle(
          fontSize: getScreenHeight(15),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: getScreenHeight(15),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(0);
                collapseUserProfile();
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: FittedBox(
                  child: Text(
                    'Reaches',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(1);
                collapseUserProfile();
              }),
              child: FittedBox(
                child: Text(
                  'Comment',
                  style: TextStyle(
                    fontSize: getScreenHeight(15),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(2);
                collapseUserProfile();
              }),
              child: FittedBox(
                child: Text(
                  'Likes',
                  style: TextStyle(
                    fontSize: getScreenHeight(15),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
  String message = '';

  bool _isReaching = false;
  bool _isStarring = false;
  bool isUserCollapsed = true;

  void collapseUserProfile() => isUserCollapsed = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final _posts = useState<List<PostModel>>([]);
    final _comments = useState<List<CommentModel>>([]);
    final _likedPosts = useState<List<PostFeedModel>>([]);
    final _shoutDowns = useState<List<PostFeedModel>>([]);
    final _shoutOuts = useState<List<PostFeedModel>>([]);
    final _sharedPosts = useState<List<PostFeedModel>>([]);
    return Scaffold(
      body: BlocConsumer<SocialServiceBloc, SocialServiceState>(
        bloc: globals.socialServiceBloc,
        listener: (context, state) {
          if (state is GetAllPostsSuccess) {
            _posts.value = state.posts!;
            _reachoutsRefreshController.refreshCompleted();
          }
          if (state is GetAllPostsError) {
            Snackbars.error(context, message: state.error);
            _reachoutsRefreshController.refreshFailed();
          }
          if (state is GetPersonalCommentsSuccess) {
            _comments.value = state.data!;
            _commentsRefreshController.refreshCompleted();
          }
          if (state is GetPersonalCommentsError) {
            Snackbars.error(context, message: state.error);
            _commentsRefreshController.refreshFailed();
          }
        },
        builder: (context, state) {
          return BlocConsumer<UserBloc, UserState>(
            bloc: globals.userBloc,
            listener: (context, state) {
              if (state is RecipientUserData) {
                globals.recipientUser = state.user;
                setState(() {});
              }

              if (state is UserError) {
                Snackbars.error(context, message: state.error);
                if ((state.error ?? '')
                    .toLowerCase()
                    .contains('already reaching')) {
                  _isReaching = true;
                  setState(() {});
                }
              }

              if (state is GetStarRelationshipSuccess) {
                _isStarring = state.isStarring!;
                setState(() {});
              }

              if (state is StarUserSuccess) {
                _isStarring = true;
                Snackbars.success(context,
                    message: 'You are now starring this profile!');
                setState(() {});
              }

              if (state is DelStarRelationshipSuccess) {
                _isStarring = false;
                setState(() {});
              }

              if (state is GetReachRelationshipSuccess) {
                _isReaching = state.isReaching!;
                setState(() {});
              }

              if (state is DelReachRelationshipSuccess) {
                _isReaching = false;
                globals.userBloc!
                    .add(GetRecipientProfileEvent(email: widget.recipientId));
                setState(() {});
              }

              if (state is UserLoaded) {
                Snackbars.success(context,
                    message: "Reached User Successfully");
                globals.userBloc!
                    .add(GetRecipientProfileEvent(email: widget.recipientId));
                _isReaching = true;

                setState(() {});
              }
            },
            builder: (context, state) {
              // bool _isLoading = false;
              // bool timelineLoading = false;
              // timelineLoading = false;
              bool _isLoading = state is UserLoading;
              bool timelineLoading = state is GetAllPostsLoading;
              timelineLoading = state is GetPersonalCommentsLoading;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Visibility(
                    visible: isUserCollapsed,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      fit: StackFit.passthrough,
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        /// Banner image
                        GestureDetector(
                          child: SizedBox(
                            height: getScreenHeight(190),
                            width: size.width,
                            child: RecipientCoverPicture(
                              imageUrl: globals.recipientUser!.coverPicture,
                            ),
                          ),
                          onTap: () {
                            RouteNavigators.route(
                                context,
                                FullScreenWidget(
                                  child: Stack(children: <Widget>[
                                    Container(
                                      color: AppColors
                                          .black, // Your screen background color
                                    ),
                                    Column(children: <Widget>[
                                      Container(height: getScreenHeight(100)),
                                      RecipientCoverPicture(
                                          imageUrl: globals
                                              .recipientUser!.coverPicture),
                                    ]),
                                    Positioned(
                                      top: 0.0,
                                      left: 0.0,
                                      right: 0.0,
                                      child: AppBar(
                                        title: const Text(
                                            'Cover Photo'), // You can add title here
                                        leading: IconButton(
                                          icon: const Icon(Icons.arrow_back,
                                              color: AppColors.white),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                        backgroundColor: AppColors
                                            .black, //You can make this transparent
                                        elevation: 0.0, //No shadow
                                      ),
                                    ),
                                  ]),
                                ));
                          },
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: Container(
                                  width: getScreenWidth(40),
                                  height: getScreenHeight(40),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        AppColors.textColor2.withOpacity(0.5),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/svgs/back.svg',
                                    color: AppColors.white,
                                    width: getScreenWidth(50),
                                    height: getScreenHeight(50),
                                  ),
                                ),
                                onPressed: () => RouteNavigators.route(
                                    context, const HomeScreen()),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: Container(
                                  width: getScreenWidth(40),
                                  height: getScreenHeight(40),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        AppColors.textColor2.withOpacity(0.5),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/svgs/pop-vertical.svg',
                                    color: AppColors.white,
                                    width: getScreenWidth(50),
                                    height: getScreenHeight(50),
                                  ),
                                ),
                                onPressed: () async {
                                  await showProfileMenuBottomSheet(context,
                                      user: globals.recipientUser!,
                                      isStarring: _isStarring);
                                },
                                splashRadius: 20,
                              )
                            ]).paddingOnly(t: 40),

                        Positioned(
                          top: size.height * 0.2 - 30,
                          child: AnimatedContainer(
                            width: getScreenWidth(100),
                            height: getScreenHeight(100),
                            duration: const Duration(seconds: 1),
                            child: globals.recipientUser!.profilePicture == null
                                ? ImagePlaceholder(
                                    width: getScreenWidth(100),
                                    height: getScreenHeight(100),
                                    border: Border.all(
                                        color: Colors.grey.shade50, width: 3.0),
                                  )
                                : GestureDetector(
                                    child: RecipientProfilePicture(
                                      imageUrl:
                                          globals.recipientUser!.profilePicture,
                                      width: getScreenWidth(100),
                                      height: getScreenHeight(100),
                                      border: Border.all(
                                          color: Colors.grey.shade50,
                                          width: 3.0),
                                    ),
                                    onTap: () {
                                      RouteNavigators.route(
                                          context,
                                          FullScreenWidget(
                                            child: Stack(children: <Widget>[
                                              Container(
                                                color: AppColors
                                                    .black, // Your screen background color
                                              ),
                                              Column(children: <Widget>[
                                                Container(
                                                    height:
                                                        getScreenHeight(100)),
                                                Container(
                                                  height: size.height - 100,
                                                  width: size.width,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    image: DecorationImage(
                                                      image: NetworkImage(widget
                                                          .recipientImageUrl!),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                              Positioned(
                                                top: 0.0,
                                                left: 0.0,
                                                right: 0.0,
                                                child: AppBar(
                                                  title: const Text(
                                                      'Profile Picture'), // You can add title here
                                                  leading: IconButton(
                                                    icon: const Icon(
                                                        Icons.arrow_back,
                                                        color: AppColors.white),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                  ),
                                                  backgroundColor: AppColors
                                                      .black, //You can make this transparent
                                                  elevation: 0.0, //No shadow
                                                ),
                                              ),
                                            ]),
                                          ));
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Visibility(
                        visible: isUserCollapsed,
                        child: Column(
                          children: [
                            SizedBox(height: getScreenHeight(15)),
                            Text(
                                ('@${globals.recipientUser!.username}')
                                    .toLowerCase(),
                                style: TextStyle(
                                  fontSize: getScreenHeight(15),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textColor2,
                                )),
                            // Text('@${globals.recipientUser!.username ?? 'username'}',
                            //     style: TextStyle(
                            //       fontSize: getScreenHeight(13),
                            //       fontWeight: FontWeight.w400,
                            //       color: AppColors.textColor2,
                            //     )),
                            SizedBox(height: getScreenHeight(15)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () => RouteNavigators.route(
                                          context,
                                          RecipientAccountStatsInfo(
                                            index: 0,
                                            recipientId: widget.recipientId,
                                            // recipientId: widget.recipientId,
                                          )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            globals.recipientUser!.nReachers
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: getScreenHeight(15),
                                                color: AppColors.textColor2,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            'Reachers',
                                            style: TextStyle(
                                                fontSize: getScreenHeight(13),
                                                color: AppColors.greyShade2,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: getScreenWidth(20)),
                                    InkWell(
                                      onTap: () => RouteNavigators.route(
                                          context,
                                          RecipientAccountStatsInfo(
                                            index: 1,
                                            recipientId: widget.recipientId,
                                          )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            globals.recipientUser!.nReaching
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: getScreenHeight(15),
                                                color: AppColors.textColor2,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            'Reaching',
                                            style: TextStyle(
                                                fontSize: getScreenHeight(13),
                                                color: AppColors.greyShade2,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //SizedBox(width: getScreenWidth(20)),
                                    /*InkWell(
                                      onTap: () => RouteNavigators.route(
                                          context, RecipientAccountStatsInfo(index: 2, recipientId: widget.recipientId)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            globals.recipientUser!.nStaring
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: getScreenHeight(15),
                                                color: AppColors.textColor2,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            'Starring',
                                            style: TextStyle(
                                                fontSize: getScreenHeight(13),
                                                color: AppColors.greyShade2,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    )*/
                                  ],
                                ),
                              ],
                            ),
                            globals.recipientUser!.bio != null &&
                                    globals.recipientUser!.bio != ''
                                ? SizedBox(height: getScreenHeight(20))
                                : const SizedBox.shrink(),
                            SizedBox(
                                width: getScreenWidth(290),
                                child: Text(
                                  globals.recipientUser!.bio ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: getScreenHeight(13),
                                    color: AppColors.greyShade2,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                            globals.recipientUser!.bio != null &&
                                    globals.recipientUser!.bio != ''
                                ? SizedBox(height: getScreenHeight(20))
                                : const SizedBox.shrink(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: getScreenWidth(130),
                                  height: getScreenHeight(41),
                                  child: CustomButton(
                                    isLoading: _isLoading,
                                    loaderColor: _isReaching
                                        ? AppColors.primaryColor
                                        : AppColors.white,
                                    label: _isReaching ? 'Reaching' : 'Reach',
                                    color: _isReaching
                                        ? AppColors.white
                                        : AppColors.primaryColor,
                                    onPressed: () {
                                      if (!_isReaching) {
                                        globals.userBloc!.add(ReachUserEvent(
                                            userIdToReach:
                                                globals.recipientUser!.id));
                                      } else {
                                        globals.userBloc!.add(
                                            DelReachRelationshipEvent(
                                                userIdToDelete:
                                                    globals.recipientUser!.id));
                                      }
                                    },
                                    size: size,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 9,
                                      horizontal: 21,
                                    ),
                                    textColor: _isReaching
                                        ? AppColors.black
                                        : AppColors.white,
                                    borderSide: _isReaching
                                        ? const BorderSide(
                                            color: AppColors.greyShade5)
                                        : BorderSide.none,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                    width: getScreenWidth(130),
                                    height: getScreenHeight(41),
                                    child: CustomButton(
                                      label: 'Message',
                                      color: AppColors.white,
                                      onPressed: () {
                                        RouteNavigators.route(
                                            context,
                                            MsgChatInterface(
                                              recipientUser:
                                                  globals.recipientUser,
                                            ));
                                      },
                                      size: size,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 9,
                                        horizontal: 21,
                                      ),
                                      textColor: AppColors.textColor2,
                                      borderSide: const BorderSide(
                                          color: AppColors.greyShade5),
                                    )),
                              ],
                            ),
                            SizedBox(height: getScreenHeight(15)),
                          ],
                        ).paddingOnly(t: 50),
                      ),
                      Visibility(
                        visible: _isReaching,
                        child: Positioned(
                            top: size.height * 0.1 - 55,
                            right: size.width * 0.4,
                            //child: FractionalTranslation(
                            //translation: const Offset(0.1, 0.1),
                            child: InkWell(
                              onTap: () {
                                print("User Tap for starring");
                                if (!_isStarring) {
                                  globals.userBloc!.add(StarUserEvent(
                                      userIdToStar: widget.recipientId));
                                } else {
                                  globals.userBloc!.add(
                                      DelStarRelationshipEvent(
                                          starIdToDelete: widget.recipientId));
                                }
                              },
                              child: Container(
                                width: getScreenHeight(30),
                                height: getScreenHeight(30),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: !_isStarring
                                          ? Colors.grey
                                          : Colors.yellowAccent),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.star,
                                    size: 19,
                                    color: !_isStarring
                                        ? Colors.grey
                                        : Colors.yellowAccent),
                              ),
                            )
                            //),
                            ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: isUserCollapsed ? true : false,
                    child: Divider(
                      color: const Color(0xFF767474).withOpacity(0.5),
                      thickness: 0.5,
                    ),
                  ),
                  Visibility(
                    visible: isUserCollapsed ? false : true,
                    child: GestureDetector(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        fit: StackFit.passthrough,
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          /// Banner image
                          SizedBox(
                            height: getScreenHeight(200),
                            width: size.width,
                            child: SvgPicture.asset(
                                  "assets/svgs/cover-banner.svg",
                                  fit: BoxFit.cover,
                                ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Container(
                                    width: getScreenWidth(40),
                                    height: getScreenHeight(40),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          AppColors.textColor2.withOpacity(0.5),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/svgs/back.svg',
                                      color: AppColors.white,
                                      width: getScreenWidth(50),
                                      height: getScreenHeight(50),
                                    ),
                                  ),
                                  onPressed: () => RouteNavigators.route(
                                        context, const HomeScreen()),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Container(
                                    width: getScreenWidth(40),
                                    height: getScreenHeight(40),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          AppColors.textColor2.withOpacity(0.5),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/svgs/pop-vertical.svg',
                                      color: AppColors.white,
                                      width: getScreenWidth(50),
                                      height: getScreenHeight(50),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await showProfileMenuBottomSheet(context,
                                        user: globals.recipientUser!,
                                        isStarring: _isStarring);
                                  },
                                  splashRadius: 20,
                                )
                              ]).paddingOnly(t: 40),
                          Positioned(
                            top: size.height * 0.2 - 100,
                            child: Column(
                              children: [
                                globals.recipientUser!.profilePicture == null
                                    ? ImagePlaceholder(
                                        width: 60,
                                        height: 60,
                                        border: Border.all(
                                            color: Colors.grey.shade50,
                                            width: 3.0),
                                      )
                                    : GestureDetector(
                                        child: RecipientProfilePicture(
                                          imageUrl: globals
                                              .recipientUser!.profilePicture,
                                          width: 60,
                                          height: 60,
                                          border: Border.all(
                                              color: Colors.grey.shade50,
                                              width: 3.0),
                                        ),
                                        onTap: () {
                                          RouteNavigators.route(
                                              context,
                                              Stack(children: <Widget>[
                                                Container(
                                                  color: AppColors
                                                      .black, // Your screen background color
                                                ),
                                                Column(children: <Widget>[
                                                  Container(
                                                      height:
                                                          getScreenHeight(100)),
                                                  Container(
                                                    height: size.height - 100,
                                                    width: size.width,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      image: DecorationImage(
                                                        image: NetworkImage(widget
                                                            .recipientImageUrl!),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                                AppBar(
                                                  title: const Text(
                                                      'Profile Picture'), // You can add title here
                                                  leading: IconButton(
                                                    icon: const Icon(
                                                        Icons.arrow_back,
                                                        color: AppColors.white),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                  ),
                                                  backgroundColor: AppColors
                                                      .black, //You can make this transparent
                                                  elevation: 0.0, //No shadow
                                                ),
                                              ]));
                                        },
                                      ),
                                SizedBox(height: getScreenHeight(20)),
                                Column(
                                  children: [
                                    Text(
                                        ('${globals.recipientUser!.firstName} ${globals.recipientUser!.lastName}')
                                            .toTitleCase(),
                                        style: TextStyle(
                                          fontSize: getScreenHeight(19),
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.white,
                                        )),
                                    Text(
                                        '@${globals.recipientUser!.username ?? 'username'}',
                                        style: TextStyle(
                                          fontSize: getScreenHeight(13),
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.white,
                                        )),
                                    SizedBox(height: getScreenHeight(15)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onVerticalDragEnd: (dragEndDetails) {
                          if (dragEndDetails.primaryVelocity! > 0) {
                            setState(() {
                              isUserCollapsed = !isUserCollapsed;
                            });
                          }
                        },
                    ),
                  ),
                  SizedBox(height: getScreenHeight(10)),
                  Visibility(
                    visible: _isReaching,
                    child: Expanded(
                      child: Column(
                        children: [
                          Center(child: _tabBar),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                //REACHES TAB
                                if (timelineLoading)
                                  const CircularLoader()
                                else
                                  Refresher(
                                    controller: _reachoutsRefreshController,
                                    onRefresh: () {
                                      globals.socialServiceBloc!
                                          .add(GetAllPostsEvent(
                                        pageLimit: 50,
                                        pageNumber: 1,
                                        authId: widget.recipientId,
                                      ));
                                    },
                                    child: _posts.value.isEmpty
                                        ? ListView(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            children: const [
                                              EmptyTabWidget(
                                                title: "Reaches you’ve made",
                                                subtitle:
                                                    "Find all posts or contributions you’ve made here ",
                                              )
                                            ],
                                          )
                                        : ListView.builder(
                                            itemCount: _posts.value.length,
                                            itemBuilder: (context, index) {
                                              return _ReacherCard(
                                                postModel: _posts.value[index],
                                                onMessage: () {
                                                  RouteNavigators.route(
                                                      context,
                                                      MsgChatInterface(
                                                        recipientUser: globals
                                                            .recipientUser,
                                                      ));
                                                },
                                                onComment: () {
                                                  RouteNavigators.route(
                                                      context,
                                                      ViewCommentsScreen(
                                                        post: PostFeedModel(
                                                            firstName: globals
                                                                .recipientUser!
                                                                .firstName,
                                                            lastName: globals
                                                                .recipientUser!
                                                                .lastName,
                                                            location: globals
                                                                .recipientUser!
                                                                .location,
                                                            profilePicture: globals
                                                                .recipientUser!
                                                                .profilePicture,
                                                            postId: _posts
                                                                .value[index]
                                                                .postId,
                                                            postOwnerId: globals
                                                                .recipientUser!
                                                                .id,
                                                            username: globals
                                                                .recipientUser!
                                                                .username,
                                                            post: _posts
                                                                .value[index]),
                                                      ));
                                                },
                                              );
                                            },
                                          ),
                                  ),

                                //COMMENTS TAB
                                if (timelineLoading)
                                  const CircularLoader()
                                else
                                  Refresher(
                                    controller: _commentsRefreshController,
                                    onRefresh: () {
                                      globals.socialServiceBloc!
                                          .add(GetPersonalCommentsEvent(
                                        pageLimit: 50,
                                        pageNumber: 1,
                                        authId: widget.recipientId,
                                      ));
                                    },
                                    child: _comments.value.isEmpty
                                        ? ListView(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            children: const [
                                              EmptyTabWidget(
                                                  title:
                                                      'Comments you made on a post and comments made on your post',
                                                  subtitle:
                                                      'Here you will find all comments you’ve made on a post and also those made on your own posts')
                                            ],
                                          )
                                        : ListView.builder(
                                            itemCount: _comments.value.length,
                                            itemBuilder: (context, index) {
                                              return _CommentReachCard(
                                                commentModel:
                                                    _comments.value[index],
                                              );
                                            },
                                          ),
                                  ),

                                //LIKES TAB
                                ListView(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  children: const [
                                    EmptyTabWidget(
                                      title: "Likes they made",
                                      subtitle: "Find post they liked",
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
