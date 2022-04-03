import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reach_me/core/components/empty_state.dart';
import 'package:reach_me/features/activity/widgets/month_notification_item.dart';
import 'package:reach_me/features/activity/widgets/new_notification_item.dart';
import 'package:reach_me/features/activity/widgets/week_notification_item.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';

class NotificationsScreen extends HookWidget {
  static const String id = "notification_screen";
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final changeState = useState<bool>(false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor2),
            ).paddingOnly(l: 20),
            const Divider(thickness: 0.5, color: AppColors.textColor2),
          ],
        ),
        titleSpacing: 0,
        leadingWidth: 0,
      ),
      body: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () => changeState.value = !changeState.value,
          child: Container(
            width: size.width,
            height: size.height,
            color: const Color(0xFFF5F5F5),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: !changeState.value
                    ? const EmptyWidget(
                        emptyText: 'Uh Oh! You currently have no notifications',
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: kToolbarHeight + 30),
                          const NewNotificationContainer()
                              .paddingSymmetric(v: 10),
                          const ThisWeekNotificationContainer()
                              .paddingSymmetric(v: 10),
                          const ThisMonthNotificationContainer()
                              .paddingSymmetric(v: 10)
                        ],
                      ).paddingSymmetric(h: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
