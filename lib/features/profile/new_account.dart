import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:get/get.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';

import '../../core/components/custom_button.dart';
import '../../core/components/profile_picture.dart';
import '../../core/services/navigation/navigation_service.dart';
import '../../core/utils/app_globals.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/custom_text.dart';
import '../account/presentation/views/account.details.dart';
import '../account/presentation/views/edit_profile_screen.dart';
import '../account/presentation/widgets/bottom_sheets.dart';
import '../timeline/timeline_feed.dart';
import 'tabs.dart';

class NewAccountScreen extends StatefulHookWidget {
  const NewAccountScreen({Key? key}) : super(key: key);

  @override
  State<NewAccountScreen> createState() => _NewAccountScreenState();
}

class _NewAccountScreenState extends State<NewAccountScreen> {
  @override
  void initState() {
    timeLineFeedStore.fetchAll();
    super.initState();
  }

  final CarouselController topCarouselController = CarouselController();
  final CarouselController bodyCarouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    List<String> pageTab = [
      'Reaches',
      'Likes',
      'Comments',
      'Shoutouts',
      'Shoutdown',
      'Quote',
      "Saved"
    ];
    Map<String, Widget> profileTabMapping = {
      "reaches": const ReachTab(),
      'likes': const LikedTab(),
      'shoutouts': const UpVotedTab(),
      'shoutdown': const DownVotedTab(),
      'saved': const SavedTab(),
      'quote': const QuotedTab(),
      'comments': const CommentsTab(),
    };

    List<Widget> profileTabs = [
      const ReachTab(),
      const LikedTab(),
      const CommentsTab(),
      const UpVotedTab(),
      const DownVotedTab(),
      const QuotedTab(),
      const SavedTab(),
    ];
    ValueNotifier<String> selectedTab = useState('Reaches');
    var size = MediaQuery.of(context).size;
    return Obx(() {
      bool foldMe = !timeLineController.isScrolling.value;
      return SafeArea(
        child: Scaffold(
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
                                      Container(height: getScreenHeight(100)),
                                      const CoverPicture(),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Visibility(
                                visible:
                                    timeLineController.currentPageIndex.value !=
                                        4,
                                child: IconButton(
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
                                  onPressed: () => Navigator.pop(context),
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
                            ]),
                      ),
                      Positioned(
                        top: size.height * 0.2 - 20,
                        child: AnimatedContainer(
                            // width:
                            // isGoingDown ? width : getScreenWidth(100),
                            // height:
                            // isGoingDown ? height : getScreenHeight(100),
                            duration: const Duration(seconds: 1),
                            child: GestureDetector(
                              child: const ProfilePicture(height: 90),
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
                                            title:
                                                const Text('Profile Picture'),
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
                            )),
                      ),
                    ]),
              ),
              Visibility(
                visible: foldMe,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(children: [
                    SizedBox(height: getScreenHeight(10)),
                    Text(
                        ('${globals.user!.firstName} ${globals.user!.lastName}')
                            .toString()
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
                              onTap: () => RouteNavigators.route(
                                  context, const AccountStatsInfo(index: 0)),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                  ]),
                            ),
                            SizedBox(width: getScreenWidth(20)),
                            InkWell(
                              onTap: () => RouteNavigators.route(
                                  context, const AccountStatsInfo(index: 1)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                              onTap: () => RouteNavigators.route(
                                  context, const AccountStatsInfo(index: 2)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                              onTap: () => RouteNavigators.route(
                                  context, const AccountStatsInfo(index: 3)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                    'EX',
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
                          borderSide:
                              const BorderSide(color: AppColors.greyShade5),
                        )),
                    SizedBox(height: getScreenHeight(15)),
                  ]),
                ),
              ),
              Visibility(
                visible: !foldMe,
                child: Container(
                  height: getScreenHeight(200),
                  width: SizeConfig.screenWidth,
                  color: AppColors.textColor,
                  child: Stack(children: [
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
                                    Container(height: getScreenHeight(100)),
                                    const CoverPicture(),
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
                      left: 0,
                      child: Row(children: [
                        GestureDetector(
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
                            child: const ProfilePicture(height: 50)),
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
              Container(
                height: 60,
                width: SizeConfig.screenWidth,
                color: AppColors.backgroundShade4,
                child: CarouselSlider(
                  carouselController: topCarouselController,
                  options: CarouselOptions(
                    padEnds: false,
                    viewportFraction: 0.3,
                    height: 60,
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
                ),
              ),
              Expanded(
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
            ]),
          ),
        ),
      );
    });
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
