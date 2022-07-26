import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/empty_state.dart';
import 'package:reach_me/features/activity/widgets/month_notification_item.dart';
import 'package:reach_me/features/activity/widgets/new_notification_item.dart';
import 'package:reach_me/features/activity/widgets/week_notification_item.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';

class NotificationsScreen extends StatefulHookWidget {
  static const String id = "notification_screen";
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with AutomaticKeepAliveClientMixin<NotificationsScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    final changeState = useState<bool>(false);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: GestureDetector(
            // onTap: () => changeState.value = !changeState.value,
            child: Container(
              width: size.width,
              height: size.height,
              color: const Color(0xFFF5F5F5),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const CustomRoundTextField(
                      hintText: "Search notifications",
                      fillColor: AppColors.white,
                      suffixIcon: Icon(Icons.search),
                    ),
                    const SizedBox(height: 20),
                    !changeState.value
                        ? const EmptyNotificationScreen()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const NewNotificationContainer()
                                  .paddingSymmetric(v: 10),
                              const ThisWeekNotificationContainer()
                                  .paddingSymmetric(v: 10),
                              const ThisMonthNotificationContainer()
                                  .paddingSymmetric(v: 10)
                            ],
                          ).paddingSymmetric(h: 20),
                  ],
                ).paddingOnly(t: 22, r: 24, l: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
