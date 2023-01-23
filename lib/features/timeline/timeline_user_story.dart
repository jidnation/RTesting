import 'package:flutter/material.dart';
import 'package:get/utils.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/dimensions.dart';
import '../../core/utils/helpers.dart';

class TimeLineUserStory extends StatelessWidget {
  const TimeLineUserStory({
    Key? key,
    required this.size,
    required this.isLive,
    required this.isMe,
    required this.username,
    required this.hasWatched,
    this.image,
    this.isMeOnTap,
    this.isMuted,
    this.onTap,
  }) : super(key: key);
  final Size size;
  final bool isMe;
  final bool isLive;
  final bool hasWatched;
  final bool? isMuted;
  final String username;
  final String? image;
  final Function()? isMeOnTap;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isMe ? isMeOnTap : onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              !hasWatched
                  ? Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isMuted ?? false
                            ? AppColors.greyShade10
                            : !isLive
                                ? AppColors.primaryColor
                                : const Color(0xFFDE0606),
                      ),
                      child: Container(
                          padding: const EdgeInsets.all(3.5),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Helper.renderProfilePicture(
                            image,
                            size: 60,
                          )),
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
                            gaplessPlayback: true,
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
                          right: size.width / 20,
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
          Text(
              (username.length > 11
                  ? '${username.substring(0, 11)}...'
                  : username),
              style: TextStyle(
                  fontSize: getScreenHeight(11),
                  fontWeight: FontWeight.w400,
                  color: isMuted ?? false ? AppColors.greyShade3 : null,
                  overflow: TextOverflow.ellipsis))
        ],
      ).paddingOnly(right: 16),
    );
  }
}
