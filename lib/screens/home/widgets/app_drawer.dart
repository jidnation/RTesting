import 'package:flutter/material.dart';
import 'package:reach_me/utils/constants.dart';
import 'package:reach_me/utils/extensions.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool showOtherItem = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * 0.35,
            child: DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    clipBehavior: Clip.hardEdge,
                    child:
                        Image.asset('assets/images/user.png', fit: BoxFit.fill),
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Rooney Brown',
                            style: TextStyle(
                              color: AppColors.textColor2,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '@RooneyBrown',
                            style: TextStyle(
                              color: Color(0xFF6C6A6A),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showOtherItem = !showOtherItem;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            showOtherItem
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '2K',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textColor2,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Reachers',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.greyShade2,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '270',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textColor2,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Reaching',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.greyShade2,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: showOtherItem ? false : true,
            child: Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  DrawerItem(
                      action: 'Add an existing account',
                      color: AppColors.primaryColor,
                      notification: '',
                      onPressed: () {}),
                  DrawerItem(
                      action: 'Create a new account',
                      color: AppColors.primaryColor,
                      notification: '',
                      onPressed: () {}),
                ],
              ),
            ),
          ),
          Visibility(
            visible: showOtherItem,
            child: Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  DrawerItem(
                    action: 'Reachers',
                    notification: '+2 new...',
                    onPressed: () {},
                  ),
                  DrawerItem(
                    action: 'Reaching',
                    notification: '+7 new...',
                    onPressed: () {},
                  ),
                  DrawerItem(
                    action: 'Starring',
                    notification: '+10 new...',
                    onPressed: () {},
                  ),
                  DrawerItem(
                    action: 'Dictionary',
                    notification: '+19 new...',
                    onPressed: () {},
                  ),
                  DrawerItem(
                    action: 'Abbreviation',
                    notification: '+47 new...',
                    onPressed: () {},
                  ),
                  DrawerItem(
                    action: 'Saved post',
                    notification: '',
                    onPressed: () {},
                  ),
                  DrawerItem(
                    action: 'Leading',
                    notification: 'Video, Audio...',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: AppColors.primaryColor, thickness: 0.5),
          DrawerItem(
            action: 'Logout',
            notification: '',
            onPressed: () {},
          ),
        ],
      ).paddingOnly(r: 6, l: 6, b: 10),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem(
      {Key? key,
      required this.action,
      this.notification,
      this.onPressed,
      this.color = AppColors.textColor2})
      : super(key: key);

  final String action;
  final String? notification;
  final Function()? onPressed;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            action,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
          notification == ''
              ? const SizedBox.shrink()
              : Text(
                  notification ?? '',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryColor,
                  ),
                ),
        ],
      ),
    );
  }
}
