import 'package:flutter/material.dart';
import 'package:reach_me/features/activity/widgets/notification_item.dart';
import 'package:reach_me/core/utils/constants.dart';

class NewNotificationContainer extends StatelessWidget {
  const NewNotificationContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('New',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: AppColors.black)),
        SizedBox(height: 10),
        NotificationItem(
          actor: "Gospel Chapel, ",
          action: 'posted on your timeline',
        ),
        NotificationItem(
          actor: "Victor Smith, Paul Andrew and 3 others,  ",
          action: 'posted on your timeline',
        ),
      ],
    );
  }
}
