import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reach_me/core/components/custom_textfield.dart';
import 'package:reach_me/core/components/empty_state.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/features/activity/widgets/notification_item.dart';

import '../bloc/notifications-bloc/bloc/notifications_bloc.dart';

class NotificationsScreen extends StatefulWidget {
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
  void initState() {
    globals.notificationsBloc!.add(GetNotificationsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
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
                  //suffixIcon: Icon(Icons.search),
                ),
                const SizedBox(height: 20),
                BlocBuilder<NotificationsBloc, NotificationsState>(
                  bloc: globals.notificationsBloc,
                  builder: (context, state) {
                    if (state is GetNotificationsLoading) {
                      return const CircularProgressIndicator.adaptive();
                    }
                    if (state is GetNotificationsSuccess) {
                      return SizedBox(
                        height: size.height * 0.75,
                        child: ListView.separated(
                            itemBuilder: (context, index) => NotificationItem(
                                model: state.notifications[index]),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: state.notifications.length),
                      );
                    }
                    return const EmptyNotificationScreen();
                  },
                )
              ],
            ).paddingOnly(t: 22, r: 24, l: 24),
          ),
        ),
      ),
    );
  }
}
