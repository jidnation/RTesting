import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/components/media_card.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/features/account/presentation/widgets/bottom_sheets.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';

class SavedPostReacherCard extends StatelessWidget {
  const SavedPostReacherCard({
    Key? key,
    required this.size,
    this.isPhoto = true,
    this.isVideo = false,
    this.isVoice = false,
  }) : super(key: key);

  final Size size;
  final bool isPhoto;
  final bool isVoice;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  globals.user!.profilePicture == null
                      ? ImagePlaceholder(
                          width: getScreenWidth(65),
                          height: getScreenHeight(65),
                        ).paddingOnly(l: 20, t: 15)
                      : ProfilePicture(
                          width: getScreenWidth(65),
                          height: getScreenHeight(65),
                        ).paddingOnly(l: 20, t: 15),
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
                      const SizedBox(height: 3),
                      const Text(
                        'Manchester, United Kingdom',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor4,
                          height: 1,
                        ),
                      )
                    ],
                  ).paddingOnly(t: 15),
                ],
              ),
              IconButton(
                      onPressed: () async {
                        await showKebabCommentBottomSheet(context);
                      },
                      iconSize: 19,
                      padding: const EdgeInsets.all(0),
                      icon: SvgPicture.asset('assets/svgs/more-vertical.svg'))
                  .paddingOnly(r: 10, t: 13),
            ],
          ),
          Row(
            children: [
              const Flexible(
                child: Text(
                  "Someone said “when you become independent, you’ld understand why the prodigal son came back home”",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              MediaCard(
                  size: size,
                  width: 80,
                  height: 80,
                  isVideo: isVideo,
                  isPhoto: isPhoto)
            ],
          ).paddingOnly(t: 10, b: 10, r: 30, l: 20),
          const SizedBox(height: 20)
        ],
      ),
    ).paddingOnly(t: 16.0, l: 16.0, r: 16.0);
  }
}
