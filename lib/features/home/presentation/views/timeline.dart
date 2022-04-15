import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/bottom_sheet_list_tile.dart';
import 'package:reach_me/core/components/empty_state.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/chat/presentation/views/chats_list_screen.dart';
import 'package:reach_me/features/home/presentation/views/post_reach.dart';
import 'package:reach_me/features/home/presentation/views/view_comments.dart';
import 'package:reach_me/core/components/media_card.dart';
import 'package:reach_me/features/home/presentation/widgets/app_drawer.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';

// ignore: must_be_immutable
class TimelineScreen extends HookWidget {
  static const String id = "timeline_screen";
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey =
        useState<GlobalKey<ScaffoldState>>(GlobalKey<ScaffoldState>());
    var size = MediaQuery.of(context).size;
    final changeState = useState<bool>(false);
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
            icon: globals.user!.profilePicture == null
                ? ImagePlaceholder(
                    width: getScreenWidth(35),
                    height: getScreenHeight(35),
                  )
                : ProfilePicture(
                    width: getScreenWidth(35),
                    height: getScreenHeight(35),
                    border: Border.all(color: Colors.grey.shade50, width: 3.0),
                  )),
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
        child: GestureDetector(
          //onTap: () => changeState.value = !changeState.value,
          child: Container(
            width: size.width,
            height: size.height,
            color: const Color(0xFFF5F5F5),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: !changeState.value
                    ? const EmptyTimelineWidget()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: kToolbarHeight + 30),
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
                                  UserStory(
                                      size: size,
                                      isMe: false,
                                      isLive: false,
                                      hasWatched: false,
                                      username: 'John'),
                                  UserStory(
                                      size: size,
                                      isMe: false,
                                      isLive: true,
                                      hasWatched: false,
                                      username: 'Daniel'),
                                  UserStory(
                                      size: size,
                                      isMe: false,
                                      isLive: false,
                                      hasWatched: true,
                                      username: 'John'),
                                  UserStory(
                                      size: size,
                                      isMe: false,
                                      isLive: true,
                                      hasWatched: false,
                                      username: 'Daniel'),
                                  UserStory(
                                      size: size,
                                      isMe: false,
                                      isLive: false,
                                      hasWatched: true,
                                      username: 'John'),
                                ],
                              ),
                            ).paddingOnly(l: 11),
                          ),
                          SizedBox(height: getScreenHeight(12)),
                          const Divider(
                            thickness: 0.5,
                            color: AppColors.greyShade4,
                          ),
                          ReacherCard(size: size),
                          ReacherCard(size: size),
                        ],
                      ),
              ).paddingOnly(t: 10),
            ),
          ),
        ),
      ),
    );
  }
}

class ReacherCard extends StatelessWidget {
  const ReacherCard({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
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
        child: Column(
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
                    Container(
                      width: getScreenWidth(33),
                      height: getScreenHeight(33),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/images/user.png',
                        fit: BoxFit.fill,
                      ),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                    ).paddingOnly(l: 15, t: 10),
                    SizedBox(width: getScreenWidth(9)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Rooney Brown',
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
                        await showKebabBottomSheet(context);
                      },
                      iconSize: getScreenHeight(19),
                      padding: const EdgeInsets.all(0),
                      icon: SvgPicture.asset('assets/svgs/kebab card.svg'),
                    ),
                  ],
                )
              ],
            ),
            Flexible(
              child: Text(
                "Someone said “when you become independent, you’ld understand why the prodigal son came back home”",
                style: TextStyle(
                  fontSize: getScreenHeight(14),
                  fontWeight: FontWeight.w400,
                ),
              ).paddingSymmetric(v: 10, h: 15),
            ),
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
            ).paddingOnly(
              r: 16,
              l: 16,
              b: 16,
              t: 10,
            ),
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
                          ),
                        ),
                        SizedBox(width: getScreenWidth(4)),
                        FittedBox(
                          child: Text(
                            '1.2k',
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
                            RouteNavigators.route(
                                context, const ViewCommentsScreen());
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
                            '102k',
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
                            Flexible(child: SizedBox(width: getScreenWidth(4))),
                            FittedBox(
                              child: Text(
                                '40',
                                style: TextStyle(
                                  fontSize: getScreenHeight(12),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textColor3,
                                ),
                              ),
                            ),
                            Flexible(child: SizedBox(width: getScreenWidth(4))),
                            IconButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: SvgPicture.asset(
                                'assets/svgs/shoutdown.svg',
                              ),
                            ),
                            Flexible(child: SizedBox(width: getScreenWidth(4))),
                            FittedBox(
                              child: Text(
                                '20',
                                style: TextStyle(
                                  fontSize: getScreenHeight(12),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textColor3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ).paddingOnly(b: 32, r: 16, l: 16, t: 5),
          ],
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
                        right: size.width * 0.054,
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

Future showKebabBottomSheet(BuildContext context) {
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
                    height: getScreenHeight(4),
                    width: getScreenWidth(58),
                    decoration: BoxDecoration(
                        color: AppColors.greyShade4,
                        borderRadius: BorderRadius.circular(40))),
              ).paddingOnly(t: 23),
              SizedBox(height: getScreenHeight(20)),
              KebabBottomTextButton(label: 'Share Post', onPressed: () {}),
              KebabBottomTextButton(label: 'Save Post', onPressed: () {}),
              const KebabBottomTextButton(label: 'Report'),
              const KebabBottomTextButton(label: 'Reach'),
              const KebabBottomTextButton(label: 'Star User'),
              const KebabBottomTextButton(label: 'Copy Links'),
              SizedBox(height: getScreenHeight(20)),
            ]));
      });
}

class DemoSourceEntity {
  int id;
  String url;
  String? previewUrl;
  String type;

  DemoSourceEntity(this.id, this.url, this.type, {this.previewUrl});
}
