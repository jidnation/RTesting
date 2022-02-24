import 'package:flutter/material.dart';
import 'package:reach_me/screens/activity/widgets/month_notification_item.dart';
import 'package:reach_me/screens/activity/widgets/new_notification_item.dart';
import 'package:reach_me/screens/activity/widgets/week_notification_item.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:reach_me/utils/extensions.dart';

class NotificationsScreen extends StatelessWidget {
  static const String id = "notification_screen";
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const SizedBox.shrink(),
          backgroundColor: Colors.grey.shade50,
          elevation: 0,
          title: const Text(
            'Notifications',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor2),
          ),
          titleSpacing: 0,
          leadingWidth: 20,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(thickness: 0.5, color: AppColors.textColor2),
              const NewNotificationContainer().paddingSymmetric(h: 15, v: 10),
              const ThisWeekNotificationContainer()
                  .paddingSymmetric(h: 15, v: 10),
              const ThisMonthNotificationContainer()
                  .paddingSymmetric(h: 15, v: 10)
            ],
          ),
        ));
  }
}
