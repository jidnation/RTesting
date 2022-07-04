import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reach_me/core/services/database/secure_storage.dart';
import 'package:reach_me/core/services/navigation/navigation_service.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/core/utils/constants.dart';
import 'package:reach_me/core/utils/dimensions.dart';
import 'package:reach_me/core/utils/extensions.dart';
import 'package:reach_me/core/utils/helpers.dart';
import 'package:reach_me/features/account/presentation/views/saved_post.dart';
import 'package:reach_me/features/auth/presentation/views/login_screen.dart';

class AppDrawer extends HookWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showOtherItem = useState<bool>(true);
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
                  Helper.renderProfilePicture(
                    globals.user!.profilePicture,
                    size: 49,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            ('${globals.user!.firstName} ${globals.user!.lastName}')
                                .toTitleCase(),
                            style: TextStyle(
                              color: AppColors.textColor2,
                              fontSize: getScreenHeight(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '@${globals.user!.username!}',
                            style: TextStyle(
                              color: const Color(0xFF6C6A6A),
                              fontSize: getScreenHeight(13),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => showOtherItem.value = !showOtherItem.value,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            showOtherItem.value
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getScreenHeight(20)),
                  Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            globals.user!.nReachers.toString(),
                            style: TextStyle(
                              fontSize: getScreenHeight(16),
                              color: AppColors.textColor2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Reachers',
                            style: TextStyle(
                              fontSize: getScreenHeight(14),
                              color: AppColors.greyShade2,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: getScreenWidth(20)),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            globals.user!.nReaching.toString(),
                            style: TextStyle(
                                fontSize: getScreenHeight(16),
                                color: AppColors.textColor2,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Reaching',
                            style: TextStyle(
                                fontSize: getScreenHeight(14),
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
            visible: showOtherItem.value ? false : true,
            child: Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  DrawerItem(
                      action: 'Add an existing account',
                      color: AppColors.primaryColor,
                      showIcon: false,
                      icon: '',
                      onPressed: () {}),
                  DrawerItem(
                      action: 'Create a new account',
                      color: AppColors.primaryColor,
                      showIcon: false,
                      icon: '',
                      onPressed: () {}),
                ],
              ),
            ),
          ),
          Visibility(
            visible: showOtherItem.value,
            child: Expanded(
              child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: [
                    DrawerItem(
                      action: 'Reaches',
                      icon: 'assets/svgs/reaches-d.svg',
                      onPressed: () {},
                    ),
                    // DrawerItem(
                    //   action: 'Shoutouts',
                    //   icon: 'assets/svgs/shoutout-d.svg',
                    //   onPressed: () {},
                    // ),
                    // DrawerItem(
                    //   action: 'Shoutdown',
                    //   icon: 'assets/svgs/shoutdown-d.svg',
                    //   onPressed: () {},
                    // ),
                    DrawerItem(
                      action: 'Saved posts',
                      icon: 'assets/svgs/saved-d.svg',
                      onPressed: () => RouteNavigators.route(
                          context, const SavedPostScreen()),
                    ),
                    DrawerItem(
                      action: 'Abbreviation',
                      icon: 'assets/svgs/na.svg',
                      onPressed: () {},
                    ),
                    DrawerItem(
                      action: 'Dictionary',
                      icon: 'assets/svgs/dictionary-d.svg',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Color(0xFFEBEBEB), thickness: 0.5),
                  ]),
            ),
          ),
          DrawerItem(
            action: 'Logout',
            icon: 'assets/svgs/logout.svg',
            onPressed: () {
              SecureStorage.deleteSecureData();
              RouteNavigators.routeNoWayHome(context, const LoginScreen());
            },
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
      required this.icon,
      this.onPressed,
      this.showIcon = true,
      this.color = AppColors.textColor2})
      : super(key: key);

  final String action;
  final String icon;
  final Function()? onPressed;
  final bool showIcon;
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
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          showIcon
              ? SizedBox(
                  height: getScreenHeight(20),
                  width: getScreenWidth(20),
                  child: SvgPicture.asset(icon),
                )
              : const SizedBox.shrink(),
          showIcon
              ? SizedBox(width: getScreenWidth(17))
              : const SizedBox.shrink(),
          Text(
            action,
            style: TextStyle(
              fontSize: getScreenHeight(15),
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
          action == 'Logout' ? const Spacer() : const SizedBox.shrink(),
          action == 'Logout'
              ? SizedBox(
                  height: getScreenHeight(20),
                  width: getScreenWidth(20),
                  child: SvgPicture.asset('assets/svgs/scan.svg'),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
