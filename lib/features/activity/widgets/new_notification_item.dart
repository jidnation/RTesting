import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/features/activity/widgets/notification_item.dart';
import 'package:reach_me/features/home/data/models/notifications.dart';

class NewNotificationContainer extends StatelessWidget {
  const NewNotificationContainer({Key? key, required this.notifications})
      : super(key: key);

  final List<NotificationsModel> notifications;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('New',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: AppColors.black)),
        const SizedBox(height: 10),
        ListView.separated(
          itemBuilder: (context, index) =>
             SizedBox(),
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
          itemCount: notifications.length,
        ),
      ],
    );
  }
}
