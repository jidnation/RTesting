import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/screens/home/chats_list_screen.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:reach_me/utils/extensions.dart';

class TimelineScreen extends StatelessWidget {
  static const String id = "timeline_screen";

  const TimelineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DemoSourceEntity> sourceList = [
      DemoSourceEntity(0, 'image', 'http://file.jinxianyun.com/inter_06.jpg'),
      DemoSourceEntity(1, 'image', 'http://file.jinxianyun.com/inter_05.jpg'),
      DemoSourceEntity(2, 'image', 'http://file.jinxianyun.com/inter_02.jpg'),
      DemoSourceEntity(3, 'image', 'http://file.jinxianyun.com/inter_03.gif'),
      DemoSourceEntity(4, 'video', 'http://file.jinxianyun.com/inter_04.mp4',
          previewUrl: 'http://file.jinxianyun.com/inter_04_pre.png'),
      DemoSourceEntity(5, 'video',
          'http://file.jinxianyun.com/6438BF272694486859D5DE899DD2D823.mp4',
          previewUrl: 'http://file.jinxianyun.com/102.png'),
    ];
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        shadowColor: const Color(0x1A000000),
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {},
            icon: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                  image: DecorationImage(
                    image: AssetImage("assets/images/user.png"),
                    fit: BoxFit.cover,
                  ),
                ))),
        title: SvgPicture.asset('assets/svgs/Logo.svg', width: 100, height: 25),
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/svgs/Vector.svg',
                width: 25, height: 25),
            onPressed: () {
              NavigationService.navigateTransparentRoute(
                  context, const ChatsListScreen(), 1.0, 0.0);
              // NavigationService.navigateTo(ChatsListScreen.id);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primaryColor,
        child: SvgPicture.asset('assets/svgs/reach-icon.svg',
            width: 25, height: 25),
      ),
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          color: AppColors.white,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            username: 'Add Moment'),
                        UserStory(
                            size: size,
                            isMe: false,
                            isLive: false,
                            username: 'John'),
                        UserStory(
                            size: size,
                            isMe: false,
                            isLive: true,
                            username: 'Daniel'),
                        UserStory(
                            size: size,
                            isMe: false,
                            isLive: false,
                            username: 'John'),
                        UserStory(
                            size: size,
                            isMe: false,
                            isLive: true,
                            username: 'Daniel'),
                        UserStory(
                            size: size,
                            isMe: false,
                            isLive: false,
                            username: 'John'),
                      ],
                    ),
                  ).paddingOnly(l: 11),
                ),
                const SizedBox(height: 12),
                const Divider(thickness: 0.5, color: AppColors.greyShade4),
                const SizedBox(height: 5),
                //ListView.builder(itemBuilder: itemBuilder)
                ReacherCard(size: size),
                ReacherCard(size: size),
              ],
            ),
          ).paddingOnly(t: 10),
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
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: AppColors.blackShade4,
                offset: Offset(0, 4),
                blurRadius: 8,
                spreadRadius: 0)
          ],
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
                      width: 50,
                      height: 50,
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset('assets/images/user.png',
                          fit: BoxFit.fill),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                    ).paddingOnly(l: 15, t: 10),
                    const SizedBox(width: 9),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Text('Rooney Brown',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textColor2)),
                            const SizedBox(width: 3),
                            SvgPicture.asset('assets/svgs/verified.svg')
                          ],
                        ),
                        const Text('Manchester, United Kingdom',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor2,
                                height: 1)),
                      ],
                    ).paddingOnly(t: 10),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/svgs/starred.svg'),
                    const SizedBox(width: 9),
                    IconButton(
                        onPressed: () async {
                          await showKebabBottomSheet(context);
                        },
                        iconSize: 19,
                        padding: const EdgeInsets.all(0),
                        icon:
                            SvgPicture.asset('assets/svgs/more-vertical.svg')),
                  ],
                )
              ],
            ),
            const Divider(
              thickness: 0.5,
              color: AppColors.greyShade4,
            ),
            Flexible(
              child: const Text(
                "Someone said “when you become independent, you’ld understand why the prodigal son came back home”",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ).paddingSymmetric(v: 10, h: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    height: 152,
                    width: 152,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/post.png'),
                            fit: BoxFit.fitHeight)),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Stack(
                    children: [
                      Container(
                        height: 152,
                        width: 152,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: const DecorationImage(
                              image: AssetImage('assets/images/post.png'),
                              fit: BoxFit.fitHeight),
                        ),
                      ),
                      Positioned(
                        bottom: size.width * 0.12,
                        left: size.width * 0.12,
                        child: Container(
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Color(0x80000000),
                                offset: Offset(0, 0),
                                blurRadius: 7,
                                spreadRadius: 0)
                          ]),
                          child: SvgPicture.asset('assets/svgs/video play.svg',
                              color: AppColors.white,
                              height: size.width * 0.15,
                              width: size.width * 0.15),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingOnly(r: 16, l: 16, b: 16, t: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: IconButton(
                        onPressed: () {},
                        padding: const EdgeInsets.all(0),
                        constraints: const BoxConstraints(),
                        icon: SvgPicture.asset('assets/svgs/like.svg'),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Flexible(
                      child: Text('1.2k',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor3)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: IconButton(
                        onPressed: () {},
                        padding: const EdgeInsets.all(0),
                        constraints: const BoxConstraints(),
                        icon: SvgPicture.asset('assets/svgs/comments.svg'),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Flexible(
                      child: Text('102k',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor3)),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(),
                  icon: SvgPicture.asset(
                    'assets/svgs/comment-post.svg',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: IconButton(
                        onPressed: () {},
                        padding: const EdgeInsets.all(0),
                        constraints: const BoxConstraints(),
                        icon: SvgPicture.asset('assets/svgs/shout-out.svg'),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Flexible(
                      child: Text('1.2k',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor3)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: IconButton(
                        onPressed: () {},
                        padding: const EdgeInsets.all(0),
                        constraints: const BoxConstraints(),
                        icon: SvgPicture.asset('assets/svgs/shout-out.svg'),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Flexible(
                      child: Text('5k',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor3)),
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
  }) : super(key: key);

  final Size size;
  final bool isMe;
  final bool isLive;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
                width: 80,
                height: 80,
                clipBehavior: Clip.hardEdge,
                child: Image.asset('assets/images/user.png', fit: BoxFit.fill),
                decoration: const BoxDecoration(shape: BoxShape.circle)),
            isMe
                ? Positioned(
                    bottom: size.width * 0.01,
                    right: size.width * 0.008,
                    child: Container(
                        width: 18,
                        height: 18,
                        child: const Icon(
                          Icons.add,
                          color: AppColors.white,
                          size: 13,
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
                        right: size.width * 0.065,
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: const Text('Live',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.white)),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: const Color(0xFFDE0606),
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(3))),
                      )
                    : const SizedBox.shrink(),
          ],
        ),
        isLive ? const SizedBox(height: 7) : const SizedBox(height: 11),
        Text(username,
            style: const TextStyle(
              fontSize: 11,
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
                    height: 4,
                    width: 58,
                    decoration: BoxDecoration(
                        color: AppColors.greyShade4,
                        borderRadius: BorderRadius.circular(40))),
              ).paddingOnly(t: 23),
              const SizedBox(height: 20),
              KebabBottomTextButton(label: 'Share Post', onPressed: () {}),
              KebabBottomTextButton(label: 'Save Post', onPressed: () {}),
              const KebabBottomTextButton(label: 'Report'),
              const KebabBottomTextButton(label: 'Reach'),
              const KebabBottomTextButton(label: 'Star User'),
              const KebabBottomTextButton(label: 'Copy Links'),
              const SizedBox(height: 20),
            ]));
      });
}

class KebabBottomTextButton extends StatelessWidget {
  const KebabBottomTextButton({Key? key, required this.label, this.onPressed})
      : super(key: key);

  final String label;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 15),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(label,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.black,
                fontWeight: FontWeight.w400,
              )),
        ));
  }
}

class DemoSourceEntity {
  int id;
  String url;
  String? previewUrl;
  String type;

  DemoSourceEntity(this.id, this.url, this.type, {this.previewUrl});
}
