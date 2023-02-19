import 'package:flutter/material.dart';
import 'package:reach_me/core/components/custom_button.dart';
import 'package:reach_me/core/components/profile_picture.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';

import '../../home/data/models/notifications.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({Key? key, required this.model}) : super(key: key);

  final NotificationsModel model;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ListTile(
      leading: globals.user!.profilePicture == null
          ? ImagePlaceholder(
              width: getScreenWidth(50),
              height: getScreenHeight(50),
            )
          : ProfilePicture(
              width: getScreenWidth(50),
              height: getScreenHeight(50),
            ),
      contentPadding: EdgeInsets.zero,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textScaleFactor: 0.8,
            text: TextSpan(
              text: model.title,
              style: TextStyle(
                color: AppColors.black,
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: model.isRead ? FontWeight.w400 : FontWeight.w500,
              ),
              children: const [],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            model.message,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF767474),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: SizedBox(
                  width: 100,
                  height: 30,
                  child: CustomButton(
                      label: 'View',
                      labelFontSize: 12,
                      color: AppColors.primaryColor,
                      onPressed: () {},
                      size: size,
                      textColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 3),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: SizedBox(
                  width: 100,
                  height: 30,
                  child: CustomButton(
                      label: 'Delete',
                      labelFontSize: 12,
                      color: Colors.grey.shade50,
                      onPressed: () {},
                      size: size,
                      textColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 3),
                      borderSide: const BorderSide(
                          color: AppColors.primaryColor, width: 1)),
                ),
              ),
            ],
          ),
        ],
      ),
    ).paddingSymmetric(v: 3);
  }
}
