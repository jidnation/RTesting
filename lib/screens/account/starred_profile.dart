import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/components/custom_button.dart';
import 'package:reach_me/components/profile_picture.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/screens/activity/widgets/month_notification_item.dart';
import 'package:reach_me/screens/activity/widgets/new_notification_item.dart';
import 'package:reach_me/screens/activity/widgets/week_notification_item.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:reach_me/utils/extensions.dart';

class StarredProfileScreen extends StatelessWidget {
  static const String id = "starred_profile";
  const StarredProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: SvgPicture.asset(
                'assets/svgs/arrow-back.svg',
                width: 19,
                height: 12,
                color: AppColors.black,
              ),
              onPressed: () => NavigationService.goBack()),
          backgroundColor: Colors.grey.shade50,
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 50,
          title: const Text(
            'Starred Profile',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor2),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(thickness: 0.5, color: AppColors.textColor2),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        'Profiles',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: AppColors.textColor2),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Remove all',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: AppColors.textColor2),
                        ),
                      )
                    ],
                  )),
              const StarredProfileListTile(
                fullName: 'Bad Guy',
                username: 'badboydoings',
              ).paddingSymmetric(h: 15, v: 5),
              const StarredProfileListTile(
                fullName: 'Bad Guy',
                username: 'badboydoings',
              ).paddingSymmetric(h: 15, v: 5),
              const StarredProfileListTile(
                fullName: 'Bad Guy',
                username: 'badboydoings',
              ).paddingSymmetric(h: 15, v: 5),
              const StarredProfileListTile(
                fullName: 'Bad Guy',
                username: 'badboydoings',
              ).paddingSymmetric(h: 15, v: 5),
            ],
          ),
        ));
  }
}

class StarredProfileListTile extends StatelessWidget {
  const StarredProfileListTile({
    Key? key,
    required this.fullName,
    required this.username,
  }) : super(key: key);

  final String username;
  final String fullName;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ListTile(
      leading: const ProfilePicture(width: 50, height: 50),
      contentPadding: EdgeInsets.zero,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                fullName,
                style: const TextStyle(
                    color: AppColors.textColor2,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 3),
              SvgPicture.asset('assets/svgs/starred-1.svg')
            ],
          ),
          Text(
            username,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor2,
            ),
          )
        ],
      ),
      trailing: SizedBox(
        width: 100,
        height: 30,
        child: CustomButton(
            label: 'Remove',
            labelFontSize: 12,
            color: AppColors.greyShade4,
            onPressed: () {},
            size: size,
            textColor: AppColors.textColor2,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            borderSide: BorderSide.none),
      ),
    ).paddingSymmetric(v: 3);
  }
}
