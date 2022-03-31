import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/features/account/presentation/views/edit_profile_screen.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/features/account/presentation/widgets/comment_reacher_card.dart';
import 'package:reach_me/features/home/home_screen.dart';
import 'package:reach_me/features/timeline/presentation/views/timeline.dart'
    hide showKebabBottomSheet;
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';

class AccountScreen extends StatefulWidget {
  static const String id = "account_screen";
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  TabBar get _tabBar => const TabBar(
        isScrollable: true,
        indicatorWeight: 1.5,
        indicator: UnderlineTabIndicator(
          insets: EdgeInsets.symmetric(horizontal: 80.0),
          borderSide: BorderSide(
            width: 2.0,
            color: AppColors.primaryColor,
          ),
        ),
        indicatorColor: AppColors.primaryColor,
        unselectedLabelColor: AppColors.greyShade4,
        labelColor: AppColors.primaryColor,
        labelStyle: TextStyle(
          fontSize: 15,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 15,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(child: Text('Comments')),
          Tab(child: Text('Reachouts')),
          Tab(child: Text('Shoutouts')),
          Tab(child: Text('Shoutdown')),
          Tab(child: Text('Likes')),
          Tab(child: Text('Shares')),
        ],
      );
  String message = '';
  bool isGoingDown = false;
  bool isGoingUp = false;
  double width = 100;
  double height = 100;
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
            Container(
              height: 140,
              width: size.width,
              padding: const EdgeInsets.only(top: 28),
              child: Image.network(
                'https://i.pinimg.com/originals/5a/6f/fa/5a6ffa53e1874276e8f042e58510f7c5.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/svgs/arrow-back.svg',
                  width: 19,
                  height: 12,
                  color: AppColors.white,
                ),
                onPressed: () =>
                    RouteNavigators.route(context, const HomeScreen()),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/svgs/more-vertical.svg',
                  color: AppColors.white,
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
                width: isGoingDown ? width : 100,
                height: isGoingDown ? height : 100,
                duration: const Duration(seconds: 1),
                child: ProfilePicture(
                  width: isGoingDown ? width : 100,
                  height: isGoingDown ? height : 100,
                  border: Border.all(color: AppColors.white, width: 3.0),
                ),
              ),
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 6,
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollViewController.position.userScrollDirection ==
                ScrollDirection.reverse) {
              setState(() {
                message = 'going down';
                width = 50;
                height = 50;
                isGoingDown = true;
              });
            } else {
              if (scrollViewController.position.userScrollDirection ==
                  ScrollDirection.forward) {
                setState(() {
                  message = 'going up';

                  width = 100;
                  height = 100;
                });
              }
            }
            return false;
          },
          child: NestedScrollView(
              controller: scrollViewController,
              headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
                return <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Column(
                          children: [
                            const Text('Jason Statham',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textColor2)),
                            const Text('@jasonstatham',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textColor2)),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Text(
                                          '2K',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.textColor2,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          'Reachers',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.greyShade2,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Text(
                                          '270',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.textColor2,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          'Reaching',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.greyShade2,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Text(
                                          '5',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.textColor2,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          'Starring',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.greyShade2,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const SizedBox(
                                width: 290,
                                child: Text(
                                  "English actor, typecast as the antihro, Born in shirebrook, Derbyshire",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.greyShade2,
                                      fontWeight: FontWeight.w400),
                                )),
                            const SizedBox(height: 20),
                            SizedBox(
                                width: 130,
                                height: 41,
                                child: CustomButton(
                                    label: 'Edit Profile',
                                    color: AppColors.primaryColor,
                                    onPressed: () {
                                      RouteNavigators.route(
                                          context, const EditProfileScreen());
                                    },
                                    size: size,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 9, horizontal: 21),
                                    textColor: AppColors.white,
                                    borderSide: BorderSide.none)),
                            const SizedBox(height: 15),
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
                  Stack(
                    fit: StackFit.passthrough,
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: AppColors.greyShade5, width: 1.0),
                          ),
                        ),
                      ),
                      _tabBar
                    ],
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: [
                          const SizedBox(height: 14),
                          CommentReacherCard(size: size)
                        ],
                      ),
                      ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: [
                          const SizedBox(height: 14),
                          ReacherCard(size: size),
                        ],
                      ).paddingSymmetric(h: 14),
                      ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: [
                          const SizedBox(height: 14),
                          ReacherCard(size: size),
                        ],
                      ).paddingSymmetric(h: 14),
                      ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: [
                          const SizedBox(height: 14),
                          ReacherCard(size: size),
                        ],
                      ).paddingSymmetric(h: 14),
                      ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: [
                          const SizedBox(height: 14),
                          ReacherCard(size: size),
                        ],
                      ).paddingSymmetric(h: 14),
                      ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: [
                          const SizedBox(height: 14),
                          ReacherCard(size: size),
                        ],
                      ).paddingSymmetric(h: 14),
                    ]),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
