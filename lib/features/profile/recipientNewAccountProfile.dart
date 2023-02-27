import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:get/get.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import '../../core/components/custom_button.dart';
import '../../core/components/profile_picture.dart';
import '../../core/components/snackbar.dart';
import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/app_globals.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/custom_text.dart';
import '../account/presentation/views/account.details.dart';
import '../account/presentation/views/edit_profile_screen.dart';
import '../account/presentation/widgets/bottom_sheets.dart';
import '../account/presentation/widgets/image_placeholder.dart';
import '../chat/presentation/views/msg_chat_interface.dart';
import '../home/data/models/status.model.dart';
import '../home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import '../home/presentation/bloc/user-bloc/user_bloc.dart';
import '../home/presentation/views/home_screen.dart';
import '../timeline/image_loader.dart';
import '../timeline/timeline_feed.dart';
import 'tabs.dart';

class RecipientNewAccountScreen extends StatefulHookWidget {
  final String? recipientEmail;
  final String? recipientImageUrl;
  final String? recipientId;
  final String? recipientCoverImageUrl;

  const RecipientNewAccountScreen(
      {this.recipientEmail,
      this.recipientImageUrl,
      this.recipientId,
      this.recipientCoverImageUrl,
      Key? key})
      : super(key: key);

  @override
  State<RecipientNewAccountScreen> createState() =>
      _RecipientNewAccountScreenState();
}

class _RecipientNewAccountScreenState extends State<RecipientNewAccountScreen> {
  @override
  void initState() {
    timeLineFeedStore.fetchAll(userId: widget.recipientId, isFirst: true);
    timeLineController.isScrolling(false);
    globals.userBloc!.add(GetRecipientProfileEvent(email: widget.recipientId));
    globals.socialServiceBloc!
        .add(GetStatusFeedEvent(pageLimit: 15, pageNumber: 1));
    globals.userBloc!.add(GetReachRelationshipEvent(
        userIdToReach: widget.recipientId,
        type: ReachRelationshipType.reaching));
    globals.userBloc!
        .add(GetStarRelationshipEvent(userIdToStar: widget.recipientId));
    super.initState();
  }

  bool _isReaching = false;
  bool _isStarring = false;

  final CarouselController topCarouselController = CarouselController();
  final CarouselController bodyCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final _userStatus = useState<List<StatusFeedResponseModel>>([]);
    // ValueNotifier<bool> foldMe = useState(false);
    List<String> pageTab = [
      'Reaches',
      'Likes',
      'Comments',
      'Shoutouts',
      'shoutdown',
      'Quote',
    ];

    List<Widget> profileTabs = [
      ReachTab(authId: widget.recipientId),
      LikedTab(authId: widget.recipientId),
      CommentsTab(authId: widget.recipientId),
      UpVotedTab(authId: widget.recipientId),
      DownVotedTab(authId: widget.recipientId),
      QuotedTab(authId: widget.recipientId),
    ];
    ValueNotifier<String> selectedTab = useState('Reaches');
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Obx(() {
        bool foldMe = !timeLineController.isScrolling.value;
        return Scaffold(
          body: SizedBox(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            child: Column(children: [
              Visibility(
                visible: foldMe,
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
                                    imageUrl:
                                        globals.recipientUser!.coverPicture,
                                  ),
                                ]),
                                Positioned(
                                  top: 0.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: AppBar(
                                    title: const Text('Cover Photo'),
                                    // You can add title here
                                    leading: IconButton(
                                      icon: const Icon(Icons.arrow_back,
                                          color: AppColors.white),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    backgroundColor: AppColors.black,
                                    //You can make this transparent
                                    elevation: 0.0, //No shadow
                                  ),
                                ),
                              ]),
                            ));
                      },
                    ),
                    const SizedBox(height: 40),
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
                              onPressed: () => RouteNavigators.pop(context)),
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
                                  isStarring: false
                                  // isStarring: _isStarring
                                  );
                            },
                            splashRadius: 20,
                          )
                        ]),

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
                                      color: Colors.grey.shade50, width: 3.0),
                                ),
                                onTap: () {
                                  if (_userStatus.value.any((e) =>
                                      e.username ==
                                      globals.recipientUser!.username)) {
                                    showProfilePictureOrViewStatus2(
                                      context,
                                      user: globals.recipientUser,
                                      userStatus: _userStatus.value,
                                    );
                                  } else if (globals
                                          .recipientUser!.profilePicture !=
                                      null) {
                                    RouteNavigators.route(
                                        context,
                                        pictureViewer2(context,
                                            ownerProfilePicture:
                                                globals.recipientUser));
                                  } else {
                                    Snackbars.error(context,
                                        message: 'No Profile photo');
                                  }
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocConsumer<SocialServiceBloc, SocialServiceState>(
                bloc: globals.socialServiceBloc,
                listener: (context, state) {
                  if (state is GetStatusFeedSuccess) {
                    _userStatus.value = state.status!;
                  }
                },
                builder: (context, state) {
                  return BlocConsumer<UserBloc, UserState>(
                    bloc: globals.userBloc,
                    listener: (context, state) {
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
                        globals.userBloc!.add(GetRecipientProfileEvent(
                            email: widget.recipientId));
                        setState(() {});
                      }

                      if (state is UserLoaded) {
                        Snackbars.success(context,
                            message: "Reached User Successfully");
                        globals.userBloc!.add(GetRecipientProfileEvent(
                            email: widget.recipientId));
                        _isReaching = true;

                        setState(() {});
                      }
                    },
                    builder: (context, state) {
                      bool _isLoading = state is UserLoading;
                      return Stack(children: [
                        Visibility(
                          visible: foldMe,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Column(children: [
                              SizedBox(height: getScreenHeight(15)),
                              Text(
                                  ('@${globals.recipientUser!.username}')
                                      .toLowerCase(),
                                  style: TextStyle(
                                    fontSize: getScreenHeight(15),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor2,
                                  )),
                              SizedBox(height: getScreenHeight(15)),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(children: [
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
                                    ]),
                                  ]),
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
                                                  userIdToDelete: globals
                                                      .recipientUser!.id));
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
                                        label: 'Reachout',
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
                            ]),
                          ),
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
                                            starIdToDelete:
                                                widget.recipientId));
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
                      ]);
                    },
                  );
                },
              ),
              Visibility(
                visible: foldMe,
                child: Divider(
                  height: 0,
                  color: const Color(0xFF767474).withOpacity(0.6),
                  thickness: 0.5,
                ),
              ),
              Visibility(
                visible: !foldMe,
                child: Container(
                  height: getScreenHeight(170),
                  width: SizeConfig.screenWidth,
                  color: AppColors.textColor,
                  child: Stack(children: [
                    SizedBox(
                      height: getScreenHeight(200),
                      width: size.width,
                      child: GestureDetector(
                        child: RecipientCoverPicture(
                          imageUrl: globals.recipientUser?.coverPicture,
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
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RecipientCoverPicture(
                                          imageUrl: globals
                                              .recipientUser?.coverPicture,
                                        ),
                                      ]),
                                  Positioned(
                                    top: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: AppBar(
                                      title: const Text('Cover Photo'),
                                      // You can add title here
                                      leading: IconButton(
                                        icon: const Icon(Icons.arrow_back,
                                            color: AppColors.white),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      backgroundColor: AppColors.black,
                                      //You can make this transparent
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
                          Visibility(
                            visible:
                                timeLineController.currentPageIndex.value != 4,
                            child: IconButton(
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
                              onPressed: () => RouteNavigators.pop(context),
                            ),
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
                                  user: globals.user!);
                            },
                            splashRadius: 20,
                          )
                        ]),
                    Positioned(
                      bottom: 10,
                      left: -10,
                      child: Row(children: [
                        GestureDetector(
                            onTap: () {
                              RouteNavigators.route(
                                  context,
                                  FullScreenWidget(
                                    child: Stack(children: <Widget>[
                                      Container(
                                          color: AppColors
                                              .black // Your screen background color
                                          ),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: getScreenHeight(100)),
                                            Image.network(
                                              globals.recipientUser!
                                                  .profilePicture!,
                                              fit: BoxFit.contain,
                                            ),
                                          ]),
                                      Positioned(
                                        top: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: AppBar(
                                          title: const Text('Profile Picture'),
                                          // You can add title here
                                          leading: IconButton(
                                            icon: const Icon(Icons.arrow_back,
                                                color: AppColors.white),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                          backgroundColor: AppColors.black,
                                          //You can make this transparent
                                          elevation: 0.0, //No shadow
                                        ),
                                      ),
                                    ]),
                                  ));
                            },
                            child: RecipientProfilePicture(
                              height: 50,
                              imageUrl: globals.recipientUser?.profilePicture,
                            )),
                        // Column(children: [
                        //   Text(
                        //       ('${globals.user!.firstName} ${globals.user!.lastName}')
                        //           .toString()
                        //           .toTitleCase(),
                        //       style: TextStyle(
                        //         fontSize: getScreenHeight(17),
                        //         fontWeight: FontWeight.w500,
                        //         color: Colors.white,
                        //       )),
                        //   Text('@${globals.user!.username ?? 'username'}',
                        //       style: TextStyle(
                        //         fontSize: getScreenHeight(13),
                        //         fontWeight: FontWeight.w400,
                        //         color: Colors.white,
                        //       )),
                        // ])
                      ]),
                    ),
                  ]),
                ),
              ),
              Visibility(
                visible: _isReaching,
                child: Container(
                    height: 60,
                    width: SizeConfig.screenWidth,
                    color: AppColors.backgroundShade4,
                    child: CarouselSlider(
                      carouselController: topCarouselController,
                      options: CarouselOptions(
                        padEnds: false,
                        viewportFraction: 0.3,
                        height: 60,
                        // aspectRatio: 0.3,
                        onPageChanged: (index, _) {
                          bodyCarouselController.animateToPage(index);
                          selectedTab.value = pageTab[index];
                        },
                        enableInfiniteScroll: false,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: List.generate(
                          pageTab.length,
                          (index) => ProfileTab(
                              isSelected: selectedTab.value == pageTab[index],
                              value: pageTab[index],
                              onClick: () {
                                bodyCarouselController.animateToPage(index);
                                selectedTab.value = pageTab[index];
                              })),
                    )

                    // ListView.builder(
                    //     shrinkWrap: true,
                    //     controller: _controller,
                    //     itemCount: pageTab.length,
                    //     physics: const ScrollPhysics(),
                    //     padding: const EdgeInsets.only(left: 5),
                    //     scrollDirection: Axis.horizontal,
                    //     itemBuilder: (context, index) {
                    //       String value = pageTab[index];
                    //       return ProfileTab(
                    //           isSelected: selectedTab.value == value,
                    //           value: value,
                    //           onClick: () {
                    //             selectedTab.value = value;
                    //           });
                    //     }),
                    ),
              ),
              Visibility(
                visible: _isReaching,
                child: Expanded(
                  child: SizedBox(
                    child: CarouselSlider(
                      carouselController: bodyCarouselController,
                      options: CarouselOptions(
                        viewportFraction: 1,
                        height: 580,
                        onPageChanged: (index, _) {
                          // checkMeOut(index);
                          topCarouselController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInToLinear,
                          );
                          selectedTab.value = pageTab[index];
                        },
                        enableInfiniteScroll: false,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: profileTabs,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        );
      }),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    Key? key,
    required this.isSelected,
    required this.value,
    this.onClick,
  }) : super(key: key);

  final bool isSelected;
  final String value;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Row(children: [
        Container(
          constraints: const BoxConstraints(
            minWidth: 100,
            maxHeight: 40,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isSelected ? Colors.black : Colors.transparent,
          ),
          child: CustomText(
            text: value,
            size: 15,
            weight: FontWeight.w500,
            color: isSelected ? Colors.white : null,
          ),
        ),
      ]),
    );
  }
}
