import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/timeline/timeline_control_room.dart';
import 'package:reach_me/features/timeline/timeline_feed.dart';
import 'package:skeletons/skeletons.dart';

import '../../core/utils/helpers.dart';

class UserSuggestionWidget extends StatelessWidget {
  const UserSuggestionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // ([]);
    // final isLoading = useState<bool>(true);
    // useEffect(() {
    //   globals.socialServiceBloc!.add(SuggestUserEvent());
    //   return null;
    // }, []);
    return SizedBox(
      child: ValueListenableBuilder(
          valueListenable: TimeLineFeedStore(),
          builder: (context, List<TimeLineModel> value, child) {
            return ListView(
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
                  height: getScreenHeight(305),
                  width: getScreenWidth(100),
                  child: Swiper(
                    loop: false,
                    allowImplicitScrolling: true,
                    itemBuilder: (BuildContext context, int index) {
                      CustomUser customUser =
                          timeLineFeedStore.suggestedUser[index];
                      bool isReaching =
                          customUser.user.reaching?.reachingId != null;
                      print(
                          ":::>>>>>> ${customUser.user.reaching?.reacherId} <<<<<");
                      return SuggestedUserContainer(
                        user: customUser,
                        isReaching: isReaching,
                        // size: size,
                        // profilePicture:
                        // suggestedUsers.value[index].profilePicture,
                        // user: suggestedUsers.value[index],
                        // onReach: () {
                        //   handleTap(index);
                        //   if (active.contains(index)) {
                        //     reachingUser.value = true;
                        //     // if (suggestedUsers
                        //     //         .value[index].reaching!.reacherId ==
                        //     //     null) {
                        //     globals.userBloc!.add(ReachUserEvent(
                        //         userIdToReach:
                        //         suggestedUsers.value[index].id!));
                        //   } else {
                        //     globals.userBloc!.add(
                        //         DelReachRelationshipEvent(
                        //             userIdToDelete:
                        //             suggestedUsers.value[index].id!));
                        //   }
                        //   //}
                        // },
                        // onDelete: () {
                        //   handleTap(index);
                        //   if (active.contains(index)) {
                        //     suggestedUsers.value.removeAt(index);
                        //   }
                        // },
                        // loaderColor: AppColors.white,
                        // btnColour: active.contains(index)
                        //     ? reachLabel.value == 'Reaching'
                        //     ? Colors.transparent
                        //     : AppColors.primaryColor
                        //     : AppColors.primaryColor,
                        // textColor: active.contains(index)
                        //     ? reachLabel.value == 'Reaching'
                        //     ? AppColors.primaryColor
                        //     : AppColors.white
                        //     : AppColors.white,
                        // isLoading: active.contains(index)
                        //     ? reachingUser.value
                        //     : false,
                        // label: active.contains(index)
                        //     ? reachLabel.value
                        //     : 'Reach',
                      );
                    },
                    // itemCount: suggestedUsers.value.length,
                    itemCount: timeLineFeedStore.suggestedUser.length,
                    viewportFraction: getScreenHeight(0.7),
                    scale: getScreenHeight(0.1),
                  ),
                )
              ],
            );
          }),
    ).paddingSymmetric(h: 13);
  }
}

class SuggestedUserContainer extends StatelessWidget {
  final CustomUser user;
  final bool isReaching;
  const SuggestedUserContainer({
    Key? key,
    required this.user,
    required this.isReaching,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                timeLineFeedStore.deleteSuggestedUser(id: user.id);
              },
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(0),
              icon: const Icon(
                Icons.close,
                size: 20,
                color: Color(0xFF979797),
              ),
            ),
          ),
          Helper.renderRecommendPicture(
            user.user.profilePicture,
            size: 80,
          ),
          SizedBox(height: getScreenHeight(5)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              constraints: const BoxConstraints(
                maxWidth: 161.5,
              ),
              child: FittedBox(
                child: Text(
                  "@${user.user.username}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textColor2,
                    fontSize: getScreenHeight(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: getScreenWidth(5)),
            user.user.verified!
                ? SvgPicture.asset('assets/svgs/verified.svg')
                : const SizedBox.shrink(),
          ]),
          SizedBox(height: getScreenHeight(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: getScreenWidth(65),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.user.nReachers.toString(),
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
                width: getScreenWidth(58),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.user.nReaching.toString(),
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
                      user.user.nStaring.toString(),
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
          SizedBox(height: getScreenHeight(19)),
          // btnColour: active.contains(index)
          //     ? reachLabel.value == 'Reaching'
          //     ? Colors.transparent
          //     : AppColors.primaryColor
          //     : AppColors.primaryColor,
          // textColor: active.contains(index)
          //     ? reachLabel.value == 'Reaching'
          //     ? AppColors.primaryColor
          //     : AppColors.white
          //     : AppColors.white,
          // isLoading: active.contains(index)
          //     ? reachingUser.value
          //     : false,
          CustomButton(
            label: isReaching ? "Reaching" : "Reach",
            color: isReaching ? Colors.transparent : AppColors.primaryColor,
            // onPressed: onReach,
            onPressed: () {
              timeLineFeedStore.reachUser(id: user.id);
            },
            // isLoading: isLoading,
            // loaderColor: loaderColor,
            labelFontSize: getScreenHeight(14),
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 5,
            ),
            textColor: isReaching ? AppColors.primaryColor : AppColors.white,
            borderSide:
                const BorderSide(color: AppColors.primaryColor, width: 1),
          ).paddingSymmetric(h: 45),
          SizedBox(height: getScreenHeight(5)),
        ],
      ).paddingSymmetric(h: 16, v: 16),
    );
  }
}

class SkeletonLoadingWidget extends HookWidget {
  const SkeletonLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
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
        SizedBox(height: getScreenHeight(40)),
        SvgPicture.asset(
          image!,
          width: getScreenWidth(190),
          height: getScreenHeight(190),
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
                        const SizedBox(width: 5),
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
                    const SizedBox(height: 8),
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
          width: size.width * 1.3,
          height: size.height * 0.3,
        ),
        const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor2,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'All forms of notifications will be found here',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
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
