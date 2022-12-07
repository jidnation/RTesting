import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/models/user.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';
import 'package:reach_me/features/home/presentation/bloc/social-service-bloc/ss_bloc.dart';
import 'package:reach_me/features/home/presentation/bloc/user-bloc/user_bloc.dart';
import 'package:skeletons/skeletons.dart';

class EmptyTimelineWidget extends StatefulHookWidget {
  const EmptyTimelineWidget({Key? key, required this.loading})
      : super(key: key);

  final bool loading;

  @override
  State<EmptyTimelineWidget> createState() => _EmptyTimelineWidgetState();
}

class _EmptyTimelineWidgetState extends State<EmptyTimelineWidget> {
  Set<int> active = {};

  handleTap(int index) {
    if (active.isNotEmpty) active.clear();
    setState(() {
      active.add(index);
    });
    return active;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final reachLabel = useState('Reach');
    final reachingUser = useState(false);
    final suggestedUsers = useState<List<User>>([]);
    final isLoading = useState<bool>(true);
    useEffect(() {
      globals.socialServiceBloc!.add(SuggestUserEvent());
      return null;
    }, []);
    return SizedBox(
      child: BlocConsumer<SocialServiceBloc, SocialServiceState>(
          bloc: globals.socialServiceBloc,
          listener: (context, state) {
            if (state is SuggestUserError) {
              isLoading.value = false;
              suggestedUsers.value = [];
            }
            if (state is SuggestUserSuccess) {
              isLoading.value = false;
              suggestedUsers.value = state.users!;
            }
          },
          builder: (context, state) {
            return BlocConsumer<UserBloc, UserState>(
                bloc: globals.userBloc,
                listener: (context, state) {
                  if (state is UserLoaded) {
                    reachingUser.value = false;
                  }
                  if (state is UserError) {
                    if (state.error!.contains('reaching')) {
                      reachLabel.value = 'Reaching';
                    }
                    reachingUser.value = false;
                  }
                },
                builder: (context, state) {
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
                            return SuggestedUserContainer(
                              size: size,
                              profilePicture:
                                  suggestedUsers.value[index].profilePicture,
                              user: suggestedUsers.value[index],
                              onReach: () {
                                handleTap(index);
                                if (active.contains(index)) {
                                  reachingUser.value = true;
                                  if (suggestedUsers
                                          .value[index].reaching!.reacherId ==
                                      null) {
                                    globals.userBloc!.add(ReachUserEvent(
                                        userIdToReach:
                                            suggestedUsers.value[index].id!));
                                  } else {
                                    globals.userBloc!.add(
                                        DelReachRelationshipEvent(
                                            userIdToDelete: suggestedUsers
                                                .value[index].id!));
                                  }
                                }
                              },
                              onDelete: () {
                                handleTap(index);
                                if (active.contains(index)) {
                                  suggestedUsers.value.removeAt(index);
                                }
                              },
                              loaderColor: AppColors.white,
                              btnColour: active.contains(index)
                                  ? reachLabel.value == 'Reaching'
                                      ? Colors.transparent
                                      : AppColors.primaryColor
                                  : AppColors.primaryColor,
                              textColor: active.contains(index)
                                  ? reachLabel.value == 'Reaching'
                                      ? AppColors.primaryColor
                                      : AppColors.white
                                  : AppColors.white,
                              isLoading: active.contains(index)
                                  ? reachingUser.value
                                  : false,
                              label:
                                  active.contains(index) ? "Reaching" : 'Reach',
                            );
                          },
                          itemCount: suggestedUsers.value.length,
                          viewportFraction: getScreenHeight(0.7),
                          scale: getScreenHeight(0.1),
                        ),
                      )
                    ],
                  );
                });
          }),
    ).paddingSymmetric(h: 13);
  }
}

class SuggestedUserContainer extends StatelessWidget {
  const SuggestedUserContainer({
    Key? key,
    required this.size,
    required this.onReach,
    required this.user,
    required this.profilePicture,
    required this.btnColour,
    required this.loaderColor,
    required this.isLoading,
    required this.label,
    required this.textColor,
    required this.onDelete,
  }) : super(key: key);

  final Size size;
  final User user;
  final String? profilePicture;
  final VoidCallback onReach, onDelete;
  final Color textColor, btnColour, loaderColor;
  final bool isLoading;
  final String label;

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
              onPressed: onDelete,
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
            profilePicture,
            size: 80,
          ),
          SizedBox(height: getScreenHeight(5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 162,
                ),
                child: FittedBox(
                  child: Text(
                    "@${user.username}",
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
              user.verified!
                  ? SvgPicture.asset('assets/svgs/verified.svg')
                  : const SizedBox.shrink(),
            ],
          ),
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
                      user.nReachers.toString(),
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
                      user.nReaching.toString(),
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
                      user.nStaring.toString(),
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
          CustomButton(
            label: label,
            color: btnColour,
            onPressed: onReach,
            isLoading: isLoading,
            loaderColor: loaderColor,
            labelFontSize: getScreenHeight(14),
            size: size,
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 5,
            ),
            textColor: textColor,
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
