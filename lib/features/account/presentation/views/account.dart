import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/empty_state.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/account/presentation/views/edit_profile_screen.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/home/presentation/bloc/user_bloc.dart';
import 'package:reach_me/features/home/presentation/views/home_screen.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';

class AccountScreen extends StatefulWidget {
  static const String id = "account_screen";
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    globals.userBloc!.add(GetUserProfileEvent(email: globals.user!.email));
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
                    'Comment',
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
                    'Reachouts',
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
                    'Shoutouts',
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
                    'Shoutdowns',
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
          Tab(
            child: GestureDetector(
              onTap: () => setState(() {
                _tabController?.animateTo(4);
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _tabController!.index == 4
                      ? AppColors.textColor2
                      : Colors.transparent,
                ),
                child: FittedBox(
                  child: Text(
                    'Likes',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                      color: _tabController!.index == 4
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
                _tabController?.animateTo(5);
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _tabController!.index == 5
                      ? AppColors.textColor2
                      : Colors.transparent,
                ),
                child: FittedBox(
                  child: Text(
                    'Shares',
                    style: TextStyle(
                      fontSize: getScreenHeight(15),
                      fontWeight: FontWeight.w400,
                      color: _tabController!.index == 5
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: Stack(
          alignment: Alignment.topCenter,
          fit: StackFit.passthrough,
          clipBehavior: Clip.none,
          children: <Widget>[
            /// Banner image
            SizedBox(
              height: getScreenHeight(140),
              width: size.width,
              child: Image.network(
                'https://wallpaperaccess.com/full/3956728.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                onPressed: () =>
                    RouteNavigators.route(context, const HomeScreen()),
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
                  await showKebabBottomSheet(context);
                },
                splashRadius: 20,
              )
            ]).paddingOnly(t: 25),

            Positioned(
              top: size.height * 0.1,
              child: AnimatedContainer(
                width: isGoingDown ? width : getScreenWidth(100),
                height: isGoingDown ? height : getScreenHeight(100),
                duration: const Duration(seconds: 1),
                child: globals.user!.profilePicture == null
                    ? ImagePlaceholder(
                        width: isGoingDown ? width : getScreenWidth(100),
                        height: isGoingDown ? height : getScreenHeight(100),
                        border:
                            Border.all(color: Colors.grey.shade50, width: 3.0),
                      )
                    : ProfilePicture(
                        width: isGoingDown ? width : getScreenWidth(100),
                        height: isGoingDown ? height : getScreenHeight(100),
                        border:
                            Border.all(color: Colors.grey.shade50, width: 3.0),
                      ),
                // child: ProfilePicture(
                //   width: isGoingDown ? width : 100,
                //   height: isGoingDown ? height : 100,
                //   border: Border.all(color: AppColors.white, width: 3.0),
                // ),
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<UserBloc, UserState>(
          bloc: globals.userBloc,
          listener: (context, state) {
            if (state is UserData) {
              globals.user = state.user;
            }
          },
          builder: (context, state) {
            return NotificationListener<ScrollUpdateNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollViewController.position.userScrollDirection ==
                    ScrollDirection.reverse) {
                  setState(() {
                    message = 'going down';
                    width = getScreenWidth(50);
                    height = getScreenHeight(50);
                    isGoingDown = true;
                  });
                } else {
                  if (scrollViewController.position.userScrollDirection ==
                      ScrollDirection.forward) {
                    setState(() {
                      message = 'going up';
                      width = getScreenWidth(100);
                      height = getScreenHeight(100);
                    });
                  }
                }
                return false;
              },
              child: NestedScrollView(
                controller: scrollViewController,
                headerSliverBuilder:
                    (BuildContext context, bool boxIsScrolled) {
                  return <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
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
                              Text(globals.user!.username ?? '@username',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(13),
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textColor2,
                                  )),
                              SizedBox(height: getScreenHeight(15)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Column(
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
                                      SizedBox(width: getScreenWidth(20)),
                                      Column(
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
                                      SizedBox(width: getScreenWidth(20)),
                                      Column(
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
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              globals.user!.bio != null &&
                                      globals.user!.bio != ''
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
                              globals.user!.bio != null &&
                                      globals.user!.bio != ''
                                  ? SizedBox(height: getScreenHeight(20))
                                  : const SizedBox.shrink(),
                              SizedBox(
                                  width: getScreenWidth(150),
                                  height: getScreenHeight(41),
                                  child: CustomButton(
                                    label: 'Edit Profile',
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
                        ],
                      ),
                    )
                  ];
                },
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(
                      color: const Color(0xFF767474).withOpacity(0.5),
                      thickness: 0.5,
                    ),
                    _tabBar,
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          //COMMENTS TAB
                          ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            children: const [
                              EmptyTabWidget(
                                  title:
                                      'Comments you made on a post and comments made on your post',
                                  subtitle:
                                      'Here you will find all comments you’ve made on a post and also those made on your own posts')
                            ],
                          ),

                          //REACHES TAB
                          ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            children: const [
                              EmptyTabWidget(
                                title: "Reaches you’ve made",
                                subtitle:
                                    "Find all posts or contributions you’ve made here ",
                              )
                            ],
                          ),

                          //SHOUTOUT TAB
                          ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            children: const [
                              EmptyTabWidget(
                                title:
                                    "Posts you’ve shouted out and your posts that has been shouted out",
                                subtitle:
                                    "See posts you’ve shouted out and your post that has been shouted out",
                              )
                            ],
                          ),

                          //SHOUTDOWN TAB
                          ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            children: const [
                              EmptyTabWidget(
                                title:
                                    "Posts you’ve shouted down and your posts that has been shouted down",
                                subtitle:
                                    "See posts you’ve shouted down and your post that has been shouted down",
                              )
                            ],
                          ),

                          //LIKES TAB
                          ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            children: const [
                              EmptyTabWidget(
                                title: "Likes made",
                                subtitle:
                                    "Find post you liked and your post that was liked",
                              )
                            ],
                          ),

                          //SHARES TAB
                          ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            children: const [
                              EmptyTabWidget(
                                title: "Post you shared",
                                subtitle: "Find post you’ve shared here",
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
