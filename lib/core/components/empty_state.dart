import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/rm_spinner.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:skeletons/skeletons.dart';

class EmptyTimelineWidget extends HookWidget {
  const EmptyTimelineWidget({Key? key, required this.loading})
      : super(key: key);

  final bool loading;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final reachBtnTap = useState<bool>(false);
    return SizedBox(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SizedBox(height: getScreenHeight(30)),
          Text(
            'We are happy to have you on\nReachMe ${globals.fname!.toTitleCase()} 🎉',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textColor2,
              fontSize: getScreenHeight(20),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: getScreenHeight(12)),
          Text(
            "Let’s get you up to speed on the happenings and\nevents around you, reach people to see contents\nthey share.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF767474),
              fontSize: getScreenHeight(14),
            ),
          ),
          SizedBox(height: getScreenHeight(30)),
          Text(
            "ReachMe recommended",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textColor2,
              fontSize: getScreenHeight(15),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: getScreenHeight(15)),
          SizedBox(
            height: getScreenHeight(350),
            width: getScreenWidth(300),
            child: Swiper(
              loop: false,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {},
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(
                            Icons.close,
                            size: 20,
                            color: Color(0xFF979797),
                          ),
                        ),
                      ),
                      ImagePlaceholder(
                        height: getScreenHeight(88),
                        width: getScreenHeight(88),
                      ),
                      SizedBox(height: getScreenHeight(11)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              "Bad Guy ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textColor2,
                                fontSize: getScreenHeight(16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SvgPicture.asset('assets/svgs/verified.svg')
                        ],
                      ),
                      Text(
                        "@badguy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textColor2.withOpacity(0.5),
                          fontSize: getScreenHeight(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: getScreenHeight(15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: getScreenWidth(65),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '2K',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(13),
                                    color: AppColors.greyShade2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Reachers',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(12),
                                    color: AppColors.greyShade2,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: getScreenWidth(65),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '270',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(13),
                                    color: AppColors.greyShade2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Reaching',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(12),
                                    color: AppColors.greyShade2,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: getScreenWidth(65),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '300',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(13),
                                    color: AppColors.greyShade2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Stars',
                                  style: TextStyle(
                                    fontSize: getScreenHeight(12),
                                    color: AppColors.greyShade2,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: getScreenHeight(15)),
                      CustomButton(
                        label: reachBtnTap.value ? 'Reaching' : 'Reach',
                        color: reachBtnTap.value
                            ? AppColors.white
                            : AppColors.primaryColor,
                        onPressed: () {
                          reachBtnTap.value = !reachBtnTap.value;
                        },
                        size: size,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        textColor: reachBtnTap.value
                            ? AppColors.primaryColor
                            : AppColors.white,
                        borderSide: reachBtnTap.value
                            ? const BorderSide(
                                color: AppColors.primaryColor, width: 1)
                            : BorderSide.none,
                      ).paddingSymmetric(h: 45),
                      SizedBox(height: getScreenHeight(9)),
                    ],
                  ).paddingSymmetric(h: 16, v: 16),
                );
              },
              itemCount: 10,
              viewportFraction: 0.8,
              scale: 0.9,
            ),
          )
        ],
      ),
    ).paddingSymmetric(h: 13);
  }
}

class SkeletonLoadingWidget extends HookWidget {
  const SkeletonLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: SkeletonItem(
            child: Column(
          children: [
            Row(
              children: [
                const SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      shape: BoxShape.circle, width: 50, height: 50),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                        lines: 3,
                        spacing: 6,
                        lineStyle: SkeletonLineStyle(
                          randomLength: true,
                          height: 10,
                          borderRadius: BorderRadius.circular(8),
                          minLength: MediaQuery.of(context).size.width / 6,
                          maxLength: MediaQuery.of(context).size.width / 3,
                        )),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            SkeletonParagraph(
              style: SkeletonParagraphStyle(
                  lines: 3,
                  spacing: 6,
                  lineStyle: SkeletonLineStyle(
                    randomLength: true,
                    height: 10,
                    borderRadius: BorderRadius.circular(8),
                    minLength: MediaQuery.of(context).size.width / 2,
                  )),
            ),
            const SizedBox(height: 12),
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: double.infinity,
                minHeight: MediaQuery.of(context).size.height / 8,
                maxHeight: MediaQuery.of(context).size.height / 3,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    SkeletonAvatar(
                        style: SkeletonAvatarStyle(width: 20, height: 20)),
                    SizedBox(width: 8),
                    SkeletonAvatar(
                        style: SkeletonAvatarStyle(width: 20, height: 20)),
                    SizedBox(width: 8),
                    SkeletonAvatar(
                        style: SkeletonAvatarStyle(width: 20, height: 20)),
                  ],
                ),
                SkeletonLine(
                  style: SkeletonLineStyle(
                      height: 16,
                      width: 64,
                      borderRadius: BorderRadius.circular(8)),
                )
              ],
            )
          ],
        )),
      ),
    );
  }
}

class EmptyChatListScreen extends StatelessWidget {
  const EmptyChatListScreen({
    Key? key,
    this.title,
    this.subtitle,
    this.image,
  }) : super(key: key);
  final String? title;
  final String? subtitle;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          image!,
          width: getScreenWidth(150),
          height: getScreenHeight(150),
        ),
        SizedBox(height: getScreenWidth(20)),
        Text(
          title!,
          style: TextStyle(
            fontSize: getScreenHeight(19),
            fontWeight: FontWeight.w500,
            color: AppColors.textColor2,
          ),
        ),
        SizedBox(height: getScreenHeight(6)),
        Text(
          subtitle!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: getScreenHeight(14),
            fontWeight: FontWeight.w400,
            color: const Color(0xFF767474),
          ),
        ),
      ],
    ).paddingSymmetric(h: 20, v: 30);
  }
}

class EmptyNotificationScreen extends StatelessWidget {
  const EmptyNotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'New',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor2,
                ),
              ),
              const SizedBox(height: 5),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const ImagePlaceholder(width: 65, height: 65),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text(
                          'ReachMe',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/svgs/verified.svg',
                          width: 16,
                          height: 16,
                        ),
                      ],
                    ),
                    const Text(
                      'Welcome to Reachme, Reach for updates and info around the globe',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textColor2,
                      ),
                    ),
                    const Text(
                      '3mins ago',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF767474),
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: CustomButton(
                        label: 'Reach',
                        labelFontSize: 13,
                        color: AppColors.primaryColor,
                        onPressed: () {},
                        size: size,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 10,
                        ),
                        textColor: AppColors.white,
                        borderSide: BorderSide.none,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: CustomButton(
                        label: 'Delete',
                        labelFontSize: 13,
                        color: AppColors.white,
                        onPressed: () {},
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 10,
                        ),
                        size: size,
                        textColor: const Color(0xFF767474),
                        borderSide: const BorderSide(
                          color: Color(0xFF767474),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        SvgPicture.asset(
          'assets/svgs/notifications-empty.svg',
          width: size.width * 0.8,
          height: size.height * 0.3,
        ),
        const Text(
          'No notifications',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor2,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'All forms of notifications will be found here',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF767474),
          ),
        ),
      ],
    );
  }
}

class EmptyTabWidget extends StatelessWidget {
  const EmptyTabWidget({Key? key, required this.subtitle, required this.title})
      : super(key: key);
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: getScreenHeight(40)),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: getScreenHeight(20),
            color: AppColors.textColor2,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: getScreenHeight(6)),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: getScreenHeight(14),
            color: const Color(0xFF767474),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ).paddingSymmetric(h: 20);
  }
}
