import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reach_me/core/components/bottom_sheet_list_tile.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/empty_state.dart';
import 'package:reach_me/core/components/media_card.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/components/refresher.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/components/snackbar.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
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
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';

class AccountScreen extends StatefulHookWidget {
  static const String id = "account_screen";
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<AccountScreen> {
  @override
  bool get wantKeepAlive => true;

  TabController? _tabController;

  late final _reachoutsRefreshController = RefreshController();
  late final _commentsRefreshController = RefreshController();
  late final _savedPostsRefreshController = RefreshController();
  // late final _shoutoutsRefreshController = RefreshController();
  // late final _shoutdownsRefreshController = RefreshController();
  // late final _likesRefreshController = RefreshController();
  // late final _sharesRefreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  TabBar get _tabBar => TabBar(
        isScrollable: true,
        controller: _tabController,
        indicatorWeight: 1.5,
        unselectedLabelColor: AppColors.greyShade4,
        indicatorColor: Colors.transparent,
        labelColor: AppColors.primaryColor,
        labelPadding: const EdgeInsets.symmetric(horizontal: 10),
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
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
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _tabController!.index == 0
                      ? AppColors.textColor2
                      : Colors.transparent,
                ),
                child: FittedBox(
                  child: Text(
                    'Reaches',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                      color: _tabController!.index == 0
                          ? AppColors.white
                          : AppColors.textColor2,
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
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: _tabController!.index == 1
                          ? AppColors.textColor2
                          : Colors.transparent,
                    ),
                    child: FittedBox(
                      child: Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: getScreenHeight(15),
                          fontWeight: FontWeight.w400,
                          color: _tabController!.index == 1
                              ? AppColors.white
                              : AppColors.textColor2,
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
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _tabController!.index == 2
                      ? AppColors.textColor2
                      : Colors.transparent,
                ),
                child: FittedBox(
                  child: Text(
                    'Likes',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                      color: _tabController!.index == 2
                          ? AppColors.white
                          : AppColors.textColor2,
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
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _tabController!.index == 3
                      ? AppColors.textColor2
                      : Colors.transparent,
                ),
                child: FittedBox(
                  child: Text(
                    'Saved posts',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                      color: _tabController!.index == 3
                          ? AppColors.white
                          : AppColors.textColor2,
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
  double width = getScreenWidth(100);
  double height = getScreenHeight(100);
  ScrollController scrollViewController = ScrollController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _posts = useState<List<PostModel>>([]);
    final _comments = useState<List<CommentModel>>([]);
    final _savedPosts = useState<List<SavePostModel>>([]);
    useEffect(() {
      globals.userBloc!.add(GetUserProfileEvent(email: globals.user!.email!));
      globals.socialServiceBloc!
          .add(GetAllPostsEvent(pageLimit: 50, pageNumber: 1));
      globals.socialServiceBloc!.add(GetPersonalCommentsEvent(
          pageLimit: 50, pageNumber: 1, authId: globals.user!.id));
      globals.socialServiceBloc!
          .add(GetAllSavedPostsEvent(pageLimit: 50, pageNumber: 1));
      return null;
    }, []);
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: BlocConsumer<UserBloc, UserState>(
          bloc: globals.userBloc,
          listener: (context, state) {
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
                },
                builder: (context, state) {
                  bool _isLoading = state is GetAllPostsLoading;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        fit: StackFit.passthrough,
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          /// Banner image
                          SizedBox(
                            height: getScreenHeight(140),
                            width: size.width,
                            child: Image.asset(
                              'assets/images/cover.png',
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
                                        user: globals.user!);
                                  },
                                  splashRadius: 20,
                                )
                              ]).paddingOnly(t: 25),

                          Positioned(
                            top: size.height * 0.1,
                            child: AnimatedContainer(
                              width: isGoingDown ? width : getScreenWidth(100),
                              height:
                                  isGoingDown ? height : getScreenHeight(100),
                              duration: const Duration(seconds: 1),
                              child: Helper.renderProfilePicture(
                                globals.user!.profilePicture,
                                size: 100,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: getScreenHeight(10)),
                          Text(
                              ('${globals.user!.firstName} ${globals.user!.lastName}')
                                  .toTitleCase(),
                              style: TextStyle(
                                fontSize: getScreenHeight(15),
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
                                    child: Column(
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
                                    onTap: () => RouteNavigators.route(context,
                                        const AccountStatsInfo(index: 1)),
                                    child: Column(
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
                                  SizedBox(width: getScreenWidth(20)),
                                  InkWell(
                                    onTap: () => RouteNavigators.route(context,
                                        const AccountStatsInfo(index: 2)),
                                    child: Column(
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
                                        Text(
                                          'Starring',
                                          style: TextStyle(
                                              fontSize: getScreenHeight(13),
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
                      Divider(
                        color: const Color(0xFF767474).withOpacity(0.5),
                        thickness: 0.5,
                      ),
                      Center(child: _tabBar),
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: [
                            //REACHES TAB
                            if (_isLoading)
                              const CircularLoader()
                            else
                              Refresher(
                                controller: _reachoutsRefreshController,
                                onRefresh: () {
                                  globals.socialServiceBloc!
                                      .add(GetAllPostsEvent(
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

                            //COMMENTS TAB
                            if (_isLoading)
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
                                  title: "Likes you made",
                                  subtitle:
                                      "Find post you liked and your post that was liked",
                                )
                              ],
                            ),

                            //SAVED POSTS TAB
                            if (_isLoading)
                              const CircularLoader()
                            else
                              _savedPosts.value.isEmpty
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
                                        return SavedPostReacherCardd(
                                            savedPostModel:
                                                _savedPosts.value[index]);
                                      },
                                    ),
                          ],
                        ),
                      ),
                    ],
                  );
                });
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
                                    '@${globals.user!.username}',
                                    style: TextStyle(
                                      fontSize: getScreenHeight(15),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor2,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  SvgPicture.asset('assets/svgs/verified.svg')
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
                  if (postModel!.imageMediaItems!.isNotEmpty &&
                      postModel!.audioMediaItem!.isNotEmpty &&
                      postModel!.videoMediaItem!.isNotEmpty)
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
                                  // RouteNavigators.route(
                                  //     context,  ViewCommentsScreen(post: postFeedModel!));
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
                              SizedBox(width: getScreenWidth(15)),
                              IconButton(
                                onPressed: () {},
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
                                      'assets/svgs/upvote-active.svg',
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
                                    onPressed: () {},
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
                                    (globals.user!.firstName! +
                                            ' ' +
                                            globals.user!.lastName!)
                                        .toTitleCase(),
                                    style: TextStyle(
                                      fontSize: getScreenHeight(15),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor2,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  SvgPicture.asset('assets/svgs/verified.svg')
                                ],
                              ),
                              Text(
                                'Comment on @${commentModel!.commentProfile!.username}',
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
                              // await _showReacherCardBottomSheet(
                              //     context, commentModel!);
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
                      commentModel!.content ?? '',
                      style: TextStyle(
                        fontSize: getScreenHeight(14),
                        fontWeight: FontWeight.w400,
                      ),
                    ).paddingSymmetric(v: 10, h: 16),
                  ),
                  // if (commentModel!.imageMediaItems!.isNotEmpty &&
                  //     commentModel!.audioMediaItem!.isNotEmpty &&
                  //     commentModel!.audioMediaItem!.isNotEmpty)
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Flexible(
                  //         child: Container(
                  //           height: getScreenHeight(152),
                  //           width: getScreenWidth(152),
                  //           clipBehavior: Clip.hardEdge,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(15),
                  //             image: const DecorationImage(
                  //               image: AssetImage('assets/images/post.png'),
                  //               fit: BoxFit.fitHeight,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(width: getScreenWidth(8)),
                  //       Flexible(child: MediaCard(size: size)),
                  //     ],
                  //   ).paddingOnly(r: 16, l: 16, b: 16, t: 10),
                  SizedBox(height: getScreenHeight(16)),
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
                                onPressed: () {},
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
                                  '${commentModel!.nLikes}',
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
                                  // RouteNavigators.route(
                                  //     context,  ViewCommentsScreen(post: postFeedModel!));
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
                                  '${commentModel!.nComments}',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(12),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor3,
                                  ),
                                ),
                              ),
                              SizedBox(width: getScreenWidth(15)),
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
                                    child: SizedBox(width: getScreenWidth(4)),
                                  ),
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

Future _showReacherCardBottomSheet(
    BuildContext context, PostModel postModel) async {
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
                        label: 'Edit content',
                        onPressed: () {
                          globals.socialServiceBloc!
                              .add(GetPostEvent(postId: postModel.postId));
                        }),
                    KebabBottomTextButton(
                        label: 'Delete post',
                        onPressed: () {
                          globals.socialServiceBloc!
                              .add(DeletePostEvent(postId: postModel.postId));
                          RouteNavigators.pop(context);
                        }),
                    KebabBottomTextButton(
                        label: 'Share Post', onPressed: () {}),
                    const KebabBottomTextButton(label: 'Copy link'),
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
  final String? recipientEmail, recipientImageUrl, recipientId;
  const RecipientAccountProfile(
      {Key? key, this.recipientEmail, this.recipientImageUrl, this.recipientId})
      : super(key: key);

  @override
  State<RecipientAccountProfile> createState() =>
      _RecipientAccountProfileState();
}

class _RecipientAccountProfileState extends State<RecipientAccountProfile>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  late final _reachoutsRefreshController = RefreshController();
  late final _commentsRefreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    globals.socialServiceBloc!.add(GetAllPostsEvent(
        pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
    globals.socialServiceBloc!.add(GetPersonalCommentsEvent(
        pageLimit: 50, pageNumber: 1, authId: widget.recipientId));
    globals.userBloc!
        .add(GetRecipientProfileEvent(email: widget.recipientId));
    globals.userBloc!
        .add(GetReachRelationshipEvent(userIdToReach: widget.recipientId));
    globals.userBloc!
        .add(GetStarRelationshipEvent(userIdToStar: widget.recipientId));
  }

  TabBar get _tabBar => TabBar(
        isScrollable: true,
        controller: _tabController,
        indicatorWeight: 1.5,
        unselectedLabelColor: AppColors.greyShade4,
        indicatorColor: Colors.transparent,
        labelColor: AppColors.primaryColor,
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
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _tabController!.index == 0
                      ? AppColors.textColor2
                      : Colors.transparent,
                ),
                child: FittedBox(
                  child: Text(
                    'Reaches',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                      color: _tabController!.index == 0
                          ? AppColors.white
                          : AppColors.textColor2,
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
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _tabController!.index == 1
                      ? AppColors.textColor2
                      : Colors.transparent,
                ),
                child: FittedBox(
                  child: Text(
                    'Comment',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                      color: _tabController!.index == 1
                          ? AppColors.white
                          : AppColors.textColor2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(2);
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _tabController!.index == 2
                      ? AppColors.textColor2
                      : Colors.transparent,
                ),
                child: FittedBox(
                  child: Text(
                    'Likes',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                      color: _tabController!.index == 2
                          ? AppColors.white
                          : AppColors.textColor2,
                    ),
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
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final _posts = useState<List<PostModel>>([]);
    final _comments = useState<List<CommentModel>>([]);
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
              }

              if (state is GetStarRelationshipSuccess) {
                _isStarring = state.isStarring!;
                setState(() {});
              }

              if (state is StarUserSuccess) {
                // globals.userBloc!.add(
                //     GetRecipientProfileEvent(email: widget.recipientEmail));
                _isStarring = true;
                Snackbars.success(context,
                    message: 'You are now starring this profile!');
                setState(() {});
              }

              if (state is DelStarRelationshipSuccess) {
                // globals.userBloc!.add(
                //     GetRecipientProfileEvent(email: widget.recipientEmail));
                _isStarring = false;
                setState(() {});
              }

              if (state is GetReachRelationshipSuccess) {
                // globals.userBloc!.add(
                //     GetRecipientProfileEvent(email: widget.recipientEmail));
                _isReaching = state.isReaching!;
                setState(() {});
              }

              if (state is DelReachRelationshipSuccess) {
                // globals.userBloc!.add(
                //     GetRecipientProfileEvent(email: widget.recipientEmail));
                _isReaching = false;
                setState(() {});
              }

              if (state is UserLoaded) {
                globals.userBloc!.add(
                    GetRecipientProfileEvent(email: widget.recipientEmail));
                _isReaching = true;
                setState(() {});
              }
            },
            builder: (context, state) {
              bool _isLoading = state is UserLoading;
              bool timelineLoading = state is GetAllPostsLoading;
              timelineLoading = state is GetPersonalCommentsLoading;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    fit: StackFit.passthrough,
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      /// Banner image
                      SizedBox(
                        height: getScreenHeight(140),
                        width: size.width,
                        child: Image.asset(
                          'assets/images/cover.png',
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
                                  color: AppColors.textColor2.withOpacity(0.5),
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
                                  color: AppColors.textColor2.withOpacity(0.5),
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
                          ]).paddingOnly(t: 25),

                      Positioned(
                        top: size.height * 0.1,
                        child: AnimatedContainer(
                          width: getScreenWidth(100),
                          height: getScreenHeight(100),
                          duration: const Duration(seconds: 1),
                          child: widget.recipientImageUrl == null
                              ? ImagePlaceholder(
                                  width: getScreenWidth(100),
                                  height: getScreenHeight(100),
                                  border: Border.all(
                                      color: Colors.grey.shade50, width: 3.0),
                                )
                              : RecipientProfilePicture(
                                  imageUrl: widget.recipientImageUrl,
                                  width: getScreenWidth(100),
                                  height: getScreenHeight(100),
                                  border: Border.all(
                                      color: Colors.grey.shade50, width: 3.0),
                                ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: getScreenHeight(10)),
                      Text(
                          ('@${globals.recipientUser!.username}').toLowerCase(),
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
                                    context, const AccountStatsInfo(index: 0)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      globals.recipientUser!.nReachers
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: getScreenHeight(15),
                                          color: AppColors.textColor2,
                                          fontWeight: FontWeight.w600),
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
                                    context, const AccountStatsInfo(index: 1)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      globals.recipientUser!.nReaching
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: getScreenHeight(15),
                                          color: AppColors.textColor2,
                                          fontWeight: FontWeight.w600),
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
                              SizedBox(width: getScreenWidth(20)),
                              InkWell(
                                onTap: () => RouteNavigators.route(
                                    context, const AccountStatsInfo(index: 2)),
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
                                          fontWeight: FontWeight.w600),
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
                              )
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
                                        recipientUser: globals.recipientUser,
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
                  Divider(
                    color: const Color(0xFF767474).withOpacity(0.5),
                    thickness: 0.5,
                  ),
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
                              globals.socialServiceBloc!.add(GetAllPostsEvent(
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
                                        // onLike: () {
                                        //   _likePost(index);
                                        // },
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
                                        commentModel: _comments.value[index],
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
              );
            },
          );
        },
      ),
    );
  }
}
